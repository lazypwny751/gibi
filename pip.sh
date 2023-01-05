#!/bin/sh

# Generate python package for library module will be used in bcpm.

set -e
command -v ln

if [ -d lib ] ; then
    if ! [ -f "lib/build.py" ] ; then
        ln "scripts/setup.py" "lib/setup.py"
    fi
    if command -v "python3" > /dev/null ; then
        python3 -m pip install ./lib 
    elif command -v "python" > /dev/null ; then
        # If you're using rolling distro or just installed python-is-python3 package on debian.
        python -m pip install ./lib
    else
        echo "there is not found available python interpreter."
    fi
else
    echo "the \"lib\" directory not found in \"${PWD}\"."
    exit 1
fi