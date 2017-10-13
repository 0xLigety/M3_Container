#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="latest-OpenCV"
TARGET="latest-OpenCV"
# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.deb"
# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://github.com/jabelone/OpenCV-for-Pi/raw/master/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="bfd046a94764f83e755e847af04f204e"

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
   
    cp -r ./data/usr/local/include/opencv2 /usr/armv7a-hardfloat-gnueabi/usr/include/
    cp ./data/usr/local/lib/* /usr/armv7a-hardfloat-gnueabi/usr/lib/
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
   
    cp /data/usr/local/lib/libopencv_core* "${STAGING_DIR}/lib/"
    cp /data/usr/local/lib/libopencv_imgproc* "${STAGING_DIR}/lib/"
    cp /data/usr/local/lib/libopencv_imgcodecs* "${STAGING_DIR}/lib/"
}

. ${HELPERSDIR}/call_functions.sh
