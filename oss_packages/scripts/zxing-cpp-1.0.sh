#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="zxing-cpp-master"
TARGET="zxing"
LIB="libzxing.a"
# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.zip"

# download link for the sources to be stored in dl directory
# https://github.com/glassechidna/zxing-cpp.git
# https://github.com/glassechidna/zxing-cpp/archive/master.zip
PKG_DOWNLOAD="https://github.com/glassechidna/zxing-cpp/archive/master.zip"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="76234c8f68872d35694b417147a70f63"



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
    export TARGET_ARCH="-march=armv7-a"
    export TARGET_TUNE="-mtune=cortex-a8 -mfpu=neon -mfloat-abi=hardfp -mthumb-interwork -mno-thumb"
    export CC="armv7a-hardfloat-linux-gnueabi-gcc"
    export CXX="armv7a-hardfloat-linux-gnueabi-g++"
    export CPP="armv7a-hardfloat-linux-gnueabi-gcc -E"
    export LD="armv7a-hardfloat-linux-gnueabi-ld"
    export CC_host="gcc"
    export CXX_host="g++"

    cd "${PKG_BUILD_DIR}"
    mkdir "build"
    cd "build"
    cmake -G "Unix Makefiles" ..
}

compile()
{
    cd "${PKG_BUILD_DIR}"
    cd "build"
    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp "${TARGET}" "${STAGING_DIR}"
    cp "${LIB}" "${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
