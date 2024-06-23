
if(DEFINED ENV{CMAKE_INSTALL_PREFIX})
    set(CMAKE_INSTALL_PREFIX $ENV{CMAKE_INSTALL_PREFIX} CACHE FILEPATH "")
endif()

if(DEFINED ENV{LLVM_NATIVE_TOOL_DIR})
    set(LLVM_NATIVE_TOOL_DIR $ENV{LLVM_NATIVE_TOOL_DIR} CACHE FILEPATH "")
    message(STATUS "LLVM_NATIVE_TOOL_DIR: ${LLVM_NATIVE_TOOL_DIR}")
endif()

if(DEFINED ENV{CLANG_TABLEGEN})
    set(CLANG_TABLEGEN $ENV{CLANG_TABLEGEN} CACHE FILEPATH "")
    message(STATUS "CLANG_TABLEGEN: ${CLANG_TABLEGEN}")
endif()

if(DEFINED ENV{LLVM_TABLEGEN})
    set(LLVM_TABLEGEN $ENV{LLVM_TABLEGEN} CACHE FILEPATH "")
    message(STATUS "LLVM_TABLEGEN: ${LLVM_TABLEGEN}")
endif()

if(DEFINED ENV{LLVM_CONFIG_PATH})
    set(LLVM_CONFIG_PATH $ENV{LLVM_CONFIG_PATH} CACHE FILEPATH "")
    message(STATUS "LLVM_CONFIG_PATH: ${LLVM_CONFIG_PATH}")
endif()

if(DEFINED ENV{LLVM_VERSION})
    set(LLVM_VERSION $ENV{LLVM_VERSION} CACHE FILEPATH "")
    message(STATUS "LLVM_VERSION: ${LLVM_VERSION}")
endif()

if(CMAKE_INSTALL_PREFIX)
    message(STATUS "CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
endif()

set(LLVM_TARGETS_TO_BUILD
    "X86"
    "ARM"
    "AArch64"
    "Mips"
    "PowerPC"
    "RISCV"
    "NVPTX"
    "Hexagon"
    "WebAssembly"
    "AMDGPU"
    "SystemZ"
    "BPF"
    CACHE STRING "")

set(LLVM_ENABLE_PROJECTS
    "clang"
    "clang-tools-extra"
    "compiler-rt"
    "llvm"
    "lld"
    "polly"
    CACHE STRING "")

set(LLVM_ENABLE_RUNTIMES "all" CACHE STRING "")
set(LLVM_DEFAULT_TARGET_TRIPLE "x86_64-redhat-linux" CACHE STRING "")

set(LLVM_ENABLE_BACKTRACES OFF CACHE BOOL "")
set(LLVM_ENABLE_DIA_SDK OFF CACHE BOOL "")
set(LLVM_ENABLE_TERMINFO OFF CACHE BOOL "")
set(LLVM_ENABLE_LIBXML2 ON CACHE BOOL "")
set(LLVM_ENABLE_ZLIB ON CACHE BOOL "")
set(LLVM_ENABLE_ZSTD OFF CACHE BOOL "")
set(LLVM_ENABLE_UNWIND_TABLES OFF CACHE BOOL "")
set(LLVM_ENABLE_Z3_SOLVER OFF CACHE BOOL "")
set(LLVM_ENABLE_RTTI ON CACHE BOOL "")
set(LLVM_ENABLE_EH ON CACHE BOOL "")
set(LLVM_INCLUDE_DOCS OFF CACHE BOOL "")
set(LLVM_INCLUDE_TESTS OFF CACHE BOOL "")
set(LLVM_INCLUDE_EXAMPLES OFF CACHE BOOL "")
set(LLVM_INCLUDE_GO_TESTS OFF CACHE BOOL "")

set(LLVM_BUILD_LLVM_C_DYLIB OFF CACHE BOOL "")
set(LLVM_BUILD_32_BITS OFF CACHE BOOL "")

set(LLVM_ENABLE_ASSERTIONS ON CACHE BOOL "")
set(CMAKE_BUILD_TYPE Release CACHE STRING "")

set(LLVM_INSTALL_TOOLCHAIN_ONLY OFF CACHE BOOL "")

set(LLVM_BUILD_RUNTIME OFF CACHE BOOL "")
set(LLVM_BUILD_TOOLS ON CACHE BOOL "")
set(LLVM_INCLUDE_TOOLS ON CACHE BOOL "")
set(LLVM_LIT_ARGS "-v" CACHE STRING "")
set(LLVM_LIBDIR_SUFFIX "" CACHE STRING "")
set(LLVM_USE_PERF ON CACHE BOOL "")
set(BUILD_SHARED_LIBS OFF CACHE BOOL "")
set(LLVM_LINK_LLVM_DYLIB ON CACHE BOOL "")
set(CLANG_LINK_CLANG_DYLIB ON CACHE BOOL "")

# PACKAGE_VENDOR clang version 16.0.6 (CLANG_REPOSITORY_STRING hash)
set(PACKAGE_VENDOR "" CACHE STRING "")
set(CLANG_REPOSITORY_STRING "" CACHE STRING "")

set(LLVM_BINUTILS_INCDIR "/usr/include" CACHE STRING "")

set(LLVM_CCTOOLS_COMPONENTS
    llvm-lipo
    llvm-libtool-darwin
    llvm-install-name-tool
    llvm-bitcode-strip
    CACHE STRING "")

set(LLVM_BINUTILS_COMPONENTS
    llvm-ar
    llvm-cxxfilt
    llvm-dwp
    llvm-nm
    llvm-objcopy
    llvm-objdump
    llvm-rc
    llvm-readobj
    llvm-size
    llvm-strings
    llvm-symbolizer
    CACHE STRING "")

set(LLVM_TOOLCHAIN_TOOLS
    llc
    lli
    opt
    dsymutil
    llvm-as
    llvm-cat
    llvm-cov
    llvm-config
    llvm-diff
    llvm-dis
    llvm-dlltool
    llvm-dwarfdump
    llvm-ifs
    llvm-gsymutil
    llvm-lib
    llvm-link
    llvm-mt
    llvm-pdbutil
    llvm-profdata
    llvm-ranlib
    llvm-readelf
    llvm-strip
    llvm-xray
    ${LLVM_CCTOOLS_COMPONENTS}
    ${LLVM_BINUTILS_COMPONENTS}
    CACHE STRING "")

if (${LLVM_VERSION} STREQUAL "12.0.1")
    set(LLD_EXPORTED_TARGETS
        lldCommon
        lldCore
        lldDriver
        lldMachO
        lldYAML
        lldReaderWriter
        lldCOFF
        lldELF
        lldMachO2
        lldMinGW
        lldWasm)
else()
    set(LLD_EXPORTED_TARGETS
        lldCommon
        lldCOFF
        lldELF
        lldMachO
        lldMinGW
        lldWasm)
endif()

set(LLVM_BUILD_UTILS ON CACHE BOOL "")
set(LLVM_INSTALL_UTILS ON CACHE BOOL "")
set(LLVM_TOOLCHAIN_UTILITIES
    FileCheck
    yaml2obj
    CACHE STRING "")

set(LLVM_DEVELOPMENT_COMPONENTS
    cmake-exports
    llvm-headers
    llvm-libraries
    clang-headers
    clang-libraries
    clang-cmake-exports
    clang-resource-headers
    libclang-headers
    lld-headers # requires patch
    lld-libraries # requires patch
    ${LLD_EXPORTED_TARGETS} # cmake export fix
    lld-cmake-exports
    CACHE STRING "")

set(LLVM_DISTRIBUTION_COMPONENTS
    clang
    lld
    LTO
    clang-format
    clang-tidy
    runtimes
    ${LLVM_DEVELOPMENT_COMPONENTS}
    ${LLVM_TOOLCHAIN_TOOLS}
    ${LLVM_TOOLCHAIN_UTILITIES}
    CACHE STRING "")
