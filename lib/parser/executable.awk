#!/usr/bin/env -S awk -f

($1 == "exec:>") {
    $1 = ""
    print($0)
    exit(0)
}