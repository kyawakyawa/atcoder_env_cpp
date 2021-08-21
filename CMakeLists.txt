cmake_minimum_required(VERSION 3.10)
project(atcoder_env_cpp LANGUAGES CXX C)

message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

option(BUILD_TEMPLATE "Build template.cc" OFF)
option(USE_GLOG "Enable glog" OFF)
option(USE_SANITIZER "Use Sanitizer" OFF)

# Check C++17 support
if(NOT CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

include(CheckCXXCompilerFlag)
check_cxx_compiler_flag("-std=c++17" COMPILER_SUPPORTS_CXX17)
if (COMPILER_SUPPORTS_CXX17)
    message(STATUS "C++17 support: OK (-std=c++17)")
else(COMPILER_SUPPORTS_CXX17)
    message(FATAL_ERROR "The compiler ${CMAKE_CXX_COMPILER} has no C++17 support. Please use a different C++ compiler.")
endif(COMPILER_SUPPORTS_CXX17)

endif(NOT CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

# Warning
set(ATCODER_CLANG_WARNING_FLAGS
  -Wall -Wextra -Weverything -Wno-c++98-compat -Wno-c++98-compat-pedantic -Wno-padded -Wno-unused-macros -Wno-missing-prototypes -Wno-missing-variable-declarations -Wno-global-constructors -Wno-exit-time-destructors -Wno-sign-conversion -Wno-gnu-zero-variadic-macro-arguments)
set(ATCODER_GCC_WARNING_FLAGS
  -pedantic -Wall -Wextra -Wcast-align -Wcast-qual -Wctor-dtor-privacy -Wdisabled-optimization -Wformat=2 -Winit-self -Wlogical-op -Wmissing-declarations -Wmissing-include-dirs -Wnoexcept -Wold-style-cast -Woverloaded-virtual -Wredundant-decls -Wshadow -Wsign-conversion -Wsign-promo -Wstrict-null-sentinel -Wstrict-overflow=5 -Wswitch-default -Wundef -Werror -Wno-unused)
set(ATCODER_MSVC_WARNING_FLAGS /W4)

# Binary directry
set(ATCODER_BIN_DIR ${PROJECT_BINARY_DIR})

# Compile feature
set(ATCODER_COMPILE_FEATURES "cxx_std_17")


# Compile definition
set(ATCODER_CLANG_DEFINITIONS ${ATCODER_CLANG_DEFINITIONS} "")
set(ATCODER_GCC_DEFINITIONS ${ATCODER_GCC_DEFINITIONS} "")
set(ATCODER_MSVC_DEFINITIONS ${ATCODER_MSVC_DEFINITIONS} "")

# Libraries
set(ATCODER_LINK_LIBRARIES ${ATCODER_LINK_LIBRARIES} "")

# GLOG
if(USE_GLOG)
    message(STATUS "google-glog: ENABLED")
    # Glog
    find_package(Glog REQUIRED)

    list (APPEND ATCODER_CLANG_DEFINITIONS USE_GLOG)
    list (APPEND ATCODER_GCC_DEFINITIONS USE_GLOG)
    list (APPEND ATCODER_MSVC_DEFINITIONS USE_GLOG)

    list (APPEND ATCODER_LINK_LIBRARIES "glog::glog")
else()
    message(STATUS "google-glog: DISABLED")
endif()


# Executable
set(EXECUTABLES "")

# list(APPEND EXECUTABLES A)
# list(APPEND EXECUTABLES B)
# list(APPEND EXECUTABLES C)
# list(APPEND EXECUTABLES D)
# list(APPEND EXECUTABLES E)
# list(APPEND EXECUTABLES F)

if (BUILD_TEMPLATE)
  list(APPEND EXECUTABLES template)
endif (BUILD_TEMPLATE)

foreach(EXECUTABLE IN LISTS EXECUTABLES)
  add_executable(${EXECUTABLE} ${EXECUTABLE}.cc)
  target_link_libraries(${EXECUTABLE} PRIVATE ${ATCODER_LINK_LIBRARIES})

  ## Compile Option
  target_compile_options(${EXECUTABLE} PRIVATE
    $<$<CXX_COMPILER_ID:Clang>:${ATCODER_CLANG_WARNING_FLAGS}>
    $<$<CXX_COMPILER_ID:GCC>:  ${ATCODER_GCC_WARNING_FLAGS}>
    $<$<CXX_COMPILER_ID:MSVC>: ${ATCODER_MSVC_WARNING_FLAGS}>)

  ## Adress Sanitizer
  if (USE_SANITIZER)
    if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
      target_compile_options(${EXECUTABLE} PRIVATE "-fno-omit-frame-pointer" "-fsanitize=address")
      target_link_options(${EXECUTABLE} PRIVATE "-fno-omit-frame-pointer" "-fsanitize=address")
    endif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  endif(USE_SANITIZER)


  ## Compile Feature
  target_compile_features(${EXECUTABLE} PRIVATE ${ATCODER_COMPILE_FEATURES})

  ## Compile definition
  target_compile_definitions(${EXECUTABLE} PRIVATE
    $<$<CXX_COMPILER_ID:Clang>:${ATCODER_CLANG_DEFINITIONS}>
    $<$<CXX_COMPILER_ID:GCC>:  ${ATCODER_GCC_DEFINITIONS}>
    $<$<CXX_COMPILER_ID:MSVC>: ${ATCODER_MSVC_DEFINITIONS}>)

  set_target_properties(${EXECUTABLE} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${ATCODER_BIN_DIR})
endforeach(EXECUTABLE IN LISTS EXECUTABLES)
