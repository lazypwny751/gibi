#!/usr/bin/env -S awk -v opt=$OPT -f

($1 == opt":") {
    $1 = ""
    print($0)
}