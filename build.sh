#!/bin/sh

# This script compiles a Go application and places the output in a 'build' directory.
# It assumes that the Go source file is located at 'cmd/main.go'.

set -e

[ ! -d "build" ] && mkdir build

echo "Compiling Go application..."
go build -o "build/${PWD##*/}" "cmd/main.go"
echo "Build completed successfully. Output is in the 'build' directory."
exit 0
