#!/bin/bash
set -e

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

echo "Building on $OS for $ARCH"

if [ "$OS" = "darwin" ]; then
    cargo build --release --target aarch64-apple-darwin
    cargo build --release --target x86_64-apple-darwin

    cp target/aarch64-apple-darwin/release/libcpgrust.dylib ./libcpgrust-arm64.dylib
    cp target/x86_64-apple-darwin/release/libcpgrust.dylib ./libcpgrust-amd64.dylib

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
