cmake_minimum_required(VERSION 3.19)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 20)

project(
  material_color_utilities 
  VERSION 1.0.0
  LANGUAGES CXX
)

if(BUILD_SHARED_LIBS AND MSVC)
  set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

add_library(material_color_utilities
  cpp/blend/blend.cc
  cpp/blend/blend.h
  cpp/cam/cam.cc
  cpp/cam/cam.h
  cpp/cam/hct_solver.cc
  cpp/cam/hct_solver.h
  cpp/cam/hct.cc
  cpp/cam/hct.h
  cpp/cam/viewing_conditions.cc
  cpp/cam/viewing_conditions.h
  cpp/contrast/contrast.cc
  cpp/contrast/contrast.h
  cpp/dislike/dislike.cc
  cpp/dislike/dislike.h
  cpp/dynamiccolor/contrast_curve.h
  cpp/dynamiccolor/dynamic_color.cc
  cpp/dynamiccolor/dynamic_color.h
  cpp/dynamiccolor/dynamic_scheme.cc
  cpp/dynamiccolor/dynamic_scheme.h
  cpp/dynamiccolor/material_dynamic_colors.cc
  cpp/dynamiccolor/material_dynamic_colors.h
  cpp/dynamiccolor/tone_delta_pair.h
  cpp/dynamiccolor/variant.h
  cpp/palettes/core.h
  cpp/palettes/tones.cc
  cpp/palettes/tones.h
  cpp/quantize/celebi.cc
  cpp/quantize/celebi.h
  cpp/quantize/lab.cc
  cpp/quantize/lab.h
  cpp/quantize/wsmeans.cc
  cpp/quantize/wsmeans.h
  cpp/quantize/wu.cc
  cpp/quantize/wu.h
  cpp/scheme/scheme_content.cc
  cpp/scheme/scheme_content.h
  cpp/scheme/scheme_expressive.cc
  cpp/scheme/scheme_expressive.h
  cpp/scheme/scheme_fidelity.cc
  cpp/scheme/scheme_fidelity.h
  cpp/scheme/scheme_fruit_salad.cc
  cpp/scheme/scheme_fruit_salad.h
  cpp/scheme/scheme_monochrome.cc
  cpp/scheme/scheme_monochrome.h
  cpp/scheme/scheme_neutral.cc
  cpp/scheme/scheme_neutral.h
  cpp/scheme/scheme_rainbow.cc
  cpp/scheme/scheme_rainbow.h
  cpp/scheme/scheme_tonal_spot.cc
  cpp/scheme/scheme_tonal_spot.h
  cpp/scheme/scheme_vibrant.cc
  cpp/scheme/scheme_vibrant.h
  cpp/score/score.cc
  cpp/score/score.h
  cpp/temperature/temperature_cache.cc
  cpp/temperature/temperature_cache.h
  cpp/utils/utils.cc
  cpp/utils/utils.h
)

find_package(absl REQUIRED)

target_link_libraries(
  material_color_utilities PRIVATE 
    absl::strings
    absl::flat_hash_map
)

if (MSVC)
  target_compile_definitions(material_color_utilities PRIVATE _USE_MATH_DEFINES)  
endif()

include(GNUInstallDirs)

target_include_directories(material_color_utilities 
  PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>"
    "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
)

install(
    TARGETS material_color_utilities
    EXPORT material_color_utilities-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

include(CMakePackageConfigHelpers)
configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/material_color_utilities-config.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/material_color_utilities-config.cmake"
  INSTALL_DESTINATION "share/material_color_utilities"
)
install(
  FILES "${CMAKE_CURRENT_BINARY_DIR}/material_color_utilities-config.cmake"
  DESTINATION "share/material_color_utilities"
)

install(
  EXPORT material_color_utilities-targets
  DESTINATION share/material_color_utilities
  NAMESPACE material_color_utilities::
)

# install all header files while keeping the subdirectories
# replace cpp prefix with material_color_utilities
install(
  DIRECTORY cpp/
  DESTINATION include/material_color_utilities
  FILES_MATCHING PATTERN "*.h"
)

# replace cpp prefix with material_color_utilities for all include statements 
install(CODE [[
  # Recursively find all .h files under the installation directory
  file(GLOB_RECURSE header_files "${CMAKE_INSTALL_PREFIX}/include/material_color_utilities/*.h")

  foreach(file ${header_files})
    # Read the file content
    file(READ "${file}" file_content)

    # Replace #include "cpp with #include "material_color_utilities
    string(REPLACE "#include \"cpp" "#include \"material_color_utilities" new_content "${file_content}")

    # Write the modified content back to the file
    file(WRITE "${file}" "${new_content}")
  endforeach()
]])
