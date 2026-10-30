# libast

This repository contains a set of native AST libraries for different implementation languages. The goal is to provide a shared, cross-language foundation for working with parsed source code structures and exposing them through C-compatible interfaces.

The project currently includes:

- `goast`: a Go/C library exposing parts of the `go/ast` and `go/token` APIs as exported C functions
- `rustast`: a Rust library that builds a native shared library for AST interoperability
- `csharpast`: a .NET 8 AOT library that exports a C#-based AST implementation as a shared native library

This is useful when code analysis or tooling needs to consume AST data from multiple runtimes without reimplementing the same abstractions in each language.

## Repository layout

- `goast/` – Go implementation and build script
- `rustast/` – Rust implementation and build script
- `csharpast/` – C# implementation and build script
- `.github/workflows/` – CI configuration

## Building

Each language target has its own build script and produces a platform-specific shared library.

### Go

```bash
cd goast
./build.sh
```

This builds the Go shared library in the current directory, for example:

- `libgoast-amd64.so`
- `libgoast-amd64.dylib`
- `libgoast-amd64.dll`

### Rust

```bash
cd rustast
./build.sh
```

This produces a Rust shared library such as:

- `librustast-amd64.so`
- `librustast-arm64.dylib`
- `librustast-amd64.dll`

### C#

```bash
cd csharpast
./build.sh
```

This publishes the .NET 8 native library for the current platform and copies it to the repository root, for example:

- `libcsharpast-amd64.so`
- `libcsharpast-arm64.dylib`
- `libcsharpast-amd64.dll`

## Notes

- The Go module is built with CGO and `-buildmode=c-shared`.
- The Rust project uses Cargo and produces a native shared object.
- The C# project targets .NET 8 and uses AOT publishing to generate a shared library with C exports.
- The project is meant to be extended with additional language bindings as needed.
