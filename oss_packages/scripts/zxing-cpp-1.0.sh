#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="zxing-cpp-master"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.zip"

# download link for the sources to be stored in dl directory
# https://github.com/glassechidna/zxing-cpp.git
# https://github.com/glassechidna/zxing-cpp/archive/master.zip
PKG_DOWNLOAD="https://github.com/glassechidna/zxing-cpp/archive/master.zip"

# md5 checksum of archive in dl directory
#PKG_CHECKSUM="ec635e5c4487d9bf1a12d00322b74038"



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
    export CFLAGS="${M3_CFLAGS}"
    export LDFLAGS="${M3_LDFLAGS}"
    export M3_CROSS_COMPILE="/usr/bin/armv7a-hardfloat-linux-gnueabi-"

    cd "${PKG_BUILD_DIR}"
    mkdir "build"
    cd "build"
    cmake -DCMAKE_SYSTEM_NAME=LINUX -DCMAKE_SYSTEM_VERSION=1 -DCMAKE_C_COMPILER=armv7a-hardfloat-linux-gcc -DCMAKE_CXX_COMPILER=armv7a-hardfloat-linux-g++
          -DCMAKE_FIND_ROOT_PATH=/usr/armv7a-hardfloat-linux-gnueabi -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY
          -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY
}

compile()
{
    cd "${PKG_BUILD_DIR}"
    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
