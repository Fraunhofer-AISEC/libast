#!/bin/bash
OS=`uname -s | tr '[:upper:]' '[:lower:]'`
ARCH=`arch`

if [ $OS == "darwin" ]
then
    EXTENSION="dylib"
else
    EXTENSION="so"
fi

if [[ $OS == mingw64* ]]
then
    EXTENSION="dll"
fi

echo "Building on $OS for $ARCH"

if [ $OS == "darwin" ]
then
    CGO_ENABLED=1 GOARCH=arm64 go build -buildmode=c-shared -o libgoast-arm64.${EXTENSION} lib.go
    CGO_ENABLED=1 GOARCH=amd64 go build -buildmode=c-shared -o libgoast-amd64.${EXTENSION} lib.go
fi

if [ $OS == "linux" ]
then
    if [ $ARCH == "aarch64" ]
    then
        CGO_ENABLED=1 GOARCH=arm64 go build -buildmode=c-shared -o libgoast-arm64.${EXTENSION} lib.go
    fi

    if [ $ARCH == "x86_64" ]
    then
        CGO_ENABLED=1 GOARCH=amd64 go build -buildmode=c-shared -o libgoast-amd64.${EXTENSION} lib.go
    fi
fi

if [[ $OS == mingw64* ]]
then
    CGO_ENABLED=1 GOARCH=amd64 go build -buildmode=c-shared -o libgoast-amd64.${EXTENSION} lib.go
    ls -l
else
    echo "Unsupported OS"
    echo "Current OS: $OS"
fi
