#!/bin/bash
set -e

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

echo "Building on $OS for $ARCH"

if [ "$OS" = "darwin" ]; then
    if [ "$ARCH" = "arm64" ]; then
        cargo build --release
        cp target/release/libcpgrust.dylib ./libcpgrust-arm64.dylib

    elif [ "$ARCH" = "x86_64" ]; then
        cargo build --release
        cp target/release/libcpgrust.dylib ./libcpgrust-amd64.dylib

    else
        echo "Unsupported macOS architecture: $ARCH"
        exit 1
    fi

elif [ "$OS" = "linux" ]; then
    if [ "$ARCH" = "aarch64" ]; then
        cargo build --release
        cp target/release/libcpgrust.so ./libcpgrust-arm64.so
    elif [ "$ARCH" = "x86_64" ]; then
        cargo build --release
        cp target/release/libcpgrust.so ./libcpgrust-amd64.so
    else
        echo "Unsupported Linux architecture: $ARCH"
        exit 1
    fi

elif [[ "$OS" == mingw64* ]] || [[ "$OS" == msys* ]]; then
    cargo build --release
    cp target/release/cpgrust.dll ./libcpgrust-amd64.dll

else
    echo "Unsupported OS"
    echo "Current OS: $OS"
    exit 1
fi

echo "Build complete"
