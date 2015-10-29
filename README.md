Go CDA Tools
-----

This is a ruby gem for importing and exporting CDA documents (beginning with QRDA Category 1) using Golang XML handling through [Ruby FFI](https://github.com/ffi/ffi). Until cross-compiled libraries are included in this repository, usage requires that [Golang 1.5](https://golang.org/dl/) or later be installed locally.

For local testing, run `go build -buildmode=c-shared -o libgoimport.so go-import.go` in the `ext` directory (this example builds the import library), making sure that the argument after `-o` matches the shared object being referenced in the `ffi_lib` statement of your ruby code.

If this gem is added and installed as a dependency elsewhere, the Golang shared objects will be compiled based on `extconf.rb` and the `Makefile` in the `ext` directory.
