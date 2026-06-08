#!/bin/bash
set -e

cargo build --release

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$OS" in
    linux)
        EXT=so
        ;;
    darwin)
        EXT=dylib
        ;;
    mingw*|msys*)
        EXT=dll
        ;;
    *)
        echo "Unsupported OS"
        exit 1
        ;;
esac

echo "Built target/release/libcpgrust.${EXT}"
