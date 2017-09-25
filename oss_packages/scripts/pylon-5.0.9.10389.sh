#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="pylon-5.0.9.10389-x86"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
#https://www.baslerweb.com/fp-1496749873/media/downloads/software/pylon_software/pylon-5.0.9.10389-x86.tar.gz
#https://www.baslerweb.com/fp-1496749873/media/downloads/software/pylon_software/pylon-5.0.9.10389-arm-hf.tar.gz
PKG_DOWNLOAD="https://www.baslerweb.com/fp-1496749873/media/downloads/software/pylon_software/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
#x86
PKG_CHECKSUM="2804501f1cc874ab5fa693a4b034c637"



SCRIPTSDIR="$(dirname $0)"
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR="$(realpath ${SCRIPTSDIR}/../..)"
. ${TOPDIR}/scripts/common_settings.sh
. ${HELPERSDIR}/functions.sh
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    cd "${PKG_BUILD_DIR}"
    tar -C /opt -xzf pylonSDK*.tar.
    export CFLAGS="${M3_CFLAGS}"
    export LDFLAGS="${M3_LDFLAGS}"
    export TARGET_ARCH="-march=armv7-a"
    export TARGET_TUNE="-mtune=cortex-a8 -mfpu=neon -mfloat-abi=hardfp -mthumb-interwork -mno-thumb"
    export CC="armv7a-hardfloat-linux-gnueabi-gcc"
    export CXX="armv7a-hardfloat-linux-gnueabi-g++"
    export CPP="armv7a-hardfloat-linux-gnueabi-gcc -E"
    export LD="armv7a-hardfloat-linux-gnueabi-ld"
    export CC_host="gcc"
    export CXX_host="g++"
    ./configure --target="${M3_TARGET}" --host="${M3_TARGET}"
}

compile()
{
    cd "${PKG_SRC_DIR}"
    
    make ${M3_MAKEFLAGS}
}

install_staging()
{
    cd "${PKG_SRC_DIR}"
    cp 
}

. ${HELPERSDIR}/call_functions.sh
