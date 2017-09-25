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
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --disable-largefile --disable-nls --disable-rpath --disable-browser --disable-extra --disable-libmagic --disable-mouse --disable-speller --disable-glibtest --enable-utf8 --disable-help

    cmake . build
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
