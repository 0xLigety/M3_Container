#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="zxing-cpp-1.0"

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
    cmake -DCMAKE_C_COMPILER=${M3_CROSS_COMPILE}gcc -DCMAKE_C_FLAGS="${CFLAGS} -fPIC -I${STAGING_INCLUDE} -L${STAGING_LIB}" -DCMAKE_AR=${AR} \
          -DCMAKE_LINKER=${M3_CROSS_COMPILE}ld -DCMAKE_STRIP=${M3_CROSS_COMPILE}strip -DCMAKE_NM=${NM} -DCMAKE_OBJCOPY=${M3_CROSS_COMPILE}objcopy \
          -DCMAKE_OBJDUMP=${M3_CROSS_COMPILE}objdump -DCMAKE_RANLIB=${RANLIB} \
          -DCMAKE_SHARED_LINKER_FLAGS="${LDFLAGS}" -DCMAKE_EXE_LINKER_FLAGS="${M3_LDFLAGS}" -DCMAKE_MODULE_LINKER_FLAGS="${M3_LDFLAGS}" \
          -DPAHO_WITH_SSL=ON -DCMAKE_INSTALL_PREFIX="" ..
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
