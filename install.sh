#!/bin/sh

# POSIX compatible installer if you love shell like me.

# Initialize
set -e

command -v install
command -v mkdir
command -v cp
command -v rm

echo "required commands found."

# Configuration
[ -z "${ROOT}" ]    && ROOT=""
[ -z "${PREFIX}" ]  && PREFIX="${ROOT}/usr"
[ -z "${BINDIR}" ]  && BINDIR="${PREFIX}/bin"
[ -z "${WORKDIR}" ] && WORKDIR="${PREFIX}/share/bcpm"

echo "Configuration:\n\tset ROOT: ${ROOT}\n\tset PREFIX: ${PREFIX}\n\tset BINDIR: ${BINDIR}\n\tset WORKDIR: ${WORKDIR}"

mkdir -p "${BINDIR}" "${WORKDIR}"
echo "directory created \"${BINDIR}\" & \"${WORKDIR}\""
cp -r ./lib "${WORKDIR}"
echo "copy \"${PWD}/lib\" to \"${WORKDIR}\""
cp ./src/bcpm.py "${WORKDIR}"
echo "copy \"${PWD}/src/bcpm.py\" to \"${WORKDIR}\""
install -m 755 ./src/bcpm.sh "${BINDIR}/bcpm"
echo "copy \"${PWD}/src/bcpm.sh\" to \"${BINDIR}\" as \"bcpm\" give permitions \"755\""
echo "installed."