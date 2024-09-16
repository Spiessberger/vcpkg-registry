vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO material-foundation/material-color-utilities
  REF 2144e9d915b7370a95481c3d331b34c05c392638
  SHA512 ac7f2a817f86e071da10a9603c5b70449bf1ee4306ac243199bbed385ff628893be36ebed29ffb3acebf22098f8caa9b398bc138317353cf7fb0cb3cf187508e
  HEAD_REF main
  PATCHES 
    0001-add-missing-cmath-includes.patch 
    0002-add-missing-optional-include.patch
    0003-fix-constructor-call-for-structs.patch
    0004-cast-to-signed-integer.patch
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")
file(COPY "${CMAKE_CURRENT_LIST_DIR}/material_color_utilities-config.cmake.in" DESTINATION "${SOURCE_PATH}")

vcpkg_cmake_configure(SOURCE_PATH ${SOURCE_PATH})
vcpkg_cmake_install()
vcpkg_copy_pdbs()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")