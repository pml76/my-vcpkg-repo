
vcpkg_download_distfile(ARCHIVE
    URLS "http://www.flintlib.org/flint-${VERSION}.zip"
    FILENAME "flint-${VERSION}.zip"
    SHA512 9392576de76ec853ccdf51b36802ddb917de4ed9c6e16366c9cf62716ba959da1d844b79aa65e702c6d67cdb1292112deea0e7fb641e10d32020867935fa6c4f
    )

vcpkg_find_acquire_program(PYTHON3)

vcpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    PATCHES
        fix-cmakelists.patch
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DPYTHON_EXECUTABLE=${PYTHON3}
        -DWITH_NTL=OFF
        -DWITH_CBLAS=OFF
)

vcpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

if (VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic" AND VCPKG_TARGET_IS_WINDOWS)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/flint/flint-config.h"
        "#elif defined(MSC_USE_DLL)" "#elif 1"
    )
endif()

file(INSTALL "${SOURCE_PATH}/gpl-2.0.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
