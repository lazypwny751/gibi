#!/usr/bin/env python3

# There is another trigger named as "bcpm.sh" you can 
# intialize the project just with the other shell script
# the shell script finds correct python version and generates
# bcpm work directory path as variable then triggering this file.

import sys, os

if "BCPMLIBDIR" in os.environ:
    LIBDIR  =  os.environ["BCPMLIBDIR"]
else:
    LIBDIR  = "/usr/share/bcpm/lib"

sys.path.append(LIBDIR)

if __name__ == "__main__":
    print(LIBDIR)