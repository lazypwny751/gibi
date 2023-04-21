#!/usr/bin/env -S awk -f

($1 == "build:?") {
    $1 = ""
    print($0)
    exit(0)
}