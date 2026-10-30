#!/bin/bash
set -e

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

echo "Building on $OS for $ARCH"

# Publishes the library ahead-of-time for the .NET runtime identifier $1 and copies it to $2
publish() {
    dotnet publish -c Release -r "$1"
    cp "bin/Release/net8.0/$1/publish/$3" "$2"
}

if [ "$OS" = "darwin" ]; then
    publish osx-arm64 ./libcsharpast-arm64.dylib csharpast.dylib
    publish osx-x64 ./libcsharpast-amd64.dylib csharpast.dylib

elif [ "$OS" = "linux" ]; then
    if [ "$ARCH" = "aarch64" ]; then
        publish linux-arm64 ./libcsharpast-arm64.so csharpast.so
    elif [ "$ARCH" = "x86_64" ]; then
        publish linux-x64 ./libcsharpast-amd64.so csharpast.so
    else
        echo "Unsupported Linux architecture: $ARCH"
        exit 1
    fi

elif [[ "$OS" == mingw64* ]] || [[ "$OS" == msys* ]]; then
    publish win-x64 ./libcsharpast-amd64.dll csharpast.dll

else
    echo "Unsupported OS"
    echo "Current OS: $OS"
    exit 1
fi

echo "Build complete"
