#!/bin/bash
set -e

# Not called OS, since that would overwrite the OS environment variable on Windows, which MSBuild
# needs to detect the host
HOST_OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

echo "Building on $HOST_OS for $ARCH"

# Publishes the library ahead-of-time for the .NET runtime identifier $1 and copies it to $2
publish() {
    dotnet publish -c Release -r "$1"
    cp "bin/Release/net8.0/$1/publish/$3" "$2"
}

if [ "$HOST_OS" = "darwin" ]; then
    publish osx-arm64 ./libcsharpast-arm64.dylib csharpast.dylib
    publish osx-x64 ./libcsharpast-amd64.dylib csharpast.dylib

elif [ "$HOST_OS" = "linux" ]; then
    if [ "$ARCH" = "aarch64" ]; then
        publish linux-arm64 ./libcsharpast-arm64.so csharpast.so
    elif [ "$ARCH" = "x86_64" ]; then
        publish linux-x64 ./libcsharpast-amd64.so csharpast.so
    else
        echo "Unsupported Linux architecture: $ARCH"
        exit 1
    fi

elif [[ "$HOST_OS" == mingw64* ]] || [[ "$HOST_OS" == msys* ]]; then
    publish win-x64 ./libcsharpast-amd64.dll csharpast.dll

else
    echo "Unsupported OS"
    echo "Current OS: $HOST_OS"
    exit 1
fi

echo "Build complete"
