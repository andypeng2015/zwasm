#!/usr/bin/env bash
# Update flake.nix wasm-tools URLs and sha256 hashes to match versions.lock.
#
# Reads WASM_TOOLS_VERSION from .github/versions.lock, fetches the four
# release tarballs (aarch64-macos / x86_64-macos / x86_64-linux /
# aarch64-linux), computes nix-style base32 sha256 via `nix-prefetch-url
# --unpack`, then in-place rewrites the URL and sha256 lines plus the
# comment / wrapper name in flake.nix.
#
# Run from repo root. Requires nix-prefetch-url (provided by Nix).
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

# shellcheck disable=SC1091
source .github/versions.lock
NEW="$WASM_TOOLS_VERSION"
OLD=$(awk -F'-' '/wasm-tools-[0-9]+\.[0-9]+\.[0-9]+-aarch64-macos/ { match($0, /[0-9]+\.[0-9]+\.[0-9]+/); print substr($0, RSTART, RLENGTH); exit }' flake.nix)

if [ "$OLD" = "$NEW" ]; then
    echo "flake.nix already at $NEW; nothing to do."
    exit 0
fi

echo "Updating flake.nix wasm-tools $OLD -> $NEW"

declare -A HASH
for arch in aarch64-macos x86_64-macos x86_64-linux aarch64-linux; do
    url="https://github.com/bytecodealliance/wasm-tools/releases/download/v${NEW}/wasm-tools-${NEW}-${arch}.tar.gz"
    echo "  prefetch $arch ..."
    HASH[$arch]=$(nix-prefetch-url --unpack "$url" 2>/dev/null | tail -1)
    if [ -z "${HASH[$arch]}" ]; then
        echo "  ERROR: nix-prefetch-url failed for $arch" >&2
        exit 1
    fi
done

# Map arch name -> sed key in flake.nix (only mac uses "macos" suffix
# matching the URL; linux uses "linux" — mirrored verbatim).
sed -i.bak \
    -e "s|wasm-tools ${OLD} (per-architecture|wasm-tools ${NEW} (per-architecture|" \
    -e "s|wasm-tools-${OLD}-wrapper|wasm-tools-${NEW}-wrapper|" \
    flake.nix

for arch in aarch64-macos x86_64-macos x86_64-linux aarch64-linux; do
    # Rewrite the URL line (matches the unique arch suffix) and the
    # following sha256 line. Pass arch / version / hash via env so perl
    # does not misinterpret them as filenames.
    ARCH="$arch" NEW="$NEW" OLD="$OLD" HASH="${HASH[$arch]}" \
    perl -i -pe '
        BEGIN { $arch = $ENV{ARCH}; $new = $ENV{NEW}; $old = $ENV{OLD}; $hash = $ENV{HASH}; }
        if (/wasm-tools-\Q$old\E-\Q$arch\E\.tar\.gz/) {
            s/v\Q$old\E/v$new/g;
            s/wasm-tools-\Q$old\E-\Q$arch\E/wasm-tools-$new-$arch/g;
            $rewrite_next = 1;
        } elsif ($rewrite_next && /sha256 = "[^"]+"/) {
            s/sha256 = "[^"]+"/sha256 = "$hash"/;
            $rewrite_next = 0;
        }
    ' flake.nix
done

rm -f flake.nix.bak
echo "Done. Verify with: bash scripts/sync-versions.sh"
