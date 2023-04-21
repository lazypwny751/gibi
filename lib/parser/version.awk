#!/usr/bin/env -S awk -f

($1 == "version") {
    $1 = ""
    print($0)
    exit(0)
}