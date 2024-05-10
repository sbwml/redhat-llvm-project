#!/bin/bash

script_action=${1}

setup() {
	# setup environment
 	curl -s https://repo.cooluc.com/mailbox.repo > /etc/yum.repos.d/mailbox.repo
	yum install -y centos-release-scl-rh centos-release-scl epel-release
	yum install -y libedit-devel libxml2-devel python3 python3-devel automake ncurses-devel git2 zlib-devel libffi-devel libxml2-devel zstd libzstd-devel xz xz-devel
	yum install -y devtoolset-11-gcc devtoolset-11-gcc-c++ devtoolset-11-binutils-devel devtoolset-11-runtime devtoolset-11-libstdc++-devel
}

build_dll() {
	source /opt/rh/devtoolset-11/enable
	export PATH="/opt/tools/bin:/opt/clang/bin:$PATH"
	export LD_LIBRARY_PATH="/opt/clang/lib:$LD_LIBRARY_PATH"
	TOP=$(pwd)
	# libxml2
	CC=clang CXX=clang++ cmake -S libxml2 -B libxml2-build \
		-DCMAKE_INSTALL_PREFIX=libxml2-install \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-C "/cmake/libxml2.cmake"
	CC=clang CXX=clang++ cmake --build libxml2-build
	CC=clang CXX=clang++ cmake --build libxml2-build --target install
	# ncurses
	cd $TOP/ncurses
	CC=clang CXX=clang++ ./configure --with-shared --prefix="$TOP/ncurses-install"
	make -j$(nproc)
	make install
	# libedit
	cd $TOP/libedit
	CC=clang CXX=clang++ ./configure --prefix="$TOP/libedit-install" \
		CFLAGS="-I$TOP/ncurses-install/include" \
		LDFLAGS="-L$TOP/ncurses-install/lib"
	touch aclocal.m4 configure Makefile.am Makefile.in
	make -j$(nproc)
	make install
	# xz
	cd $TOP
	CC=clang CXX=clang++ cmake -S xz -B xz-build \
		-DCMAKE_INSTALL_PREFIX=xz-install \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-C "/cmake/xz.cmake"
	CC=clang CXX=clang++ cmake --build xz-build
	CC=clang CXX=clang++ cmake --build xz-build --target install
	# libs
	cd $TOP
	mkdir lib-install
	cp -a libxml2-install/lib/libxml2.so* lib-install
	cp -a ncurses-install/lib/libncurses.so* lib-install
	cp -a libedit-install/lib/libedit.so* lib-install
	cp -a xz-install/lib/liblzma.so* lib-install
	ls -l lib-install
}

build_llvm() {
	source /opt/rh/devtoolset-11/enable
	export PATH="/opt/tools/bin:/opt/clang/bin:$PATH"
	export LD_LIBRARY_PATH="/opt/clang/lib:$LD_LIBRARY_PATH"
	# Configure LLVM host tools
	CC=clang CXX=clang++ cmake -G Ninja -S llvm-project/llvm -B llvm-host \
		-DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" \
		-DCMAKE_BUILD_TYPE=Release -Wno-dev

	# Build LLVM host tools
	CC=clang CXX=clang++ cmake --build llvm-host \
		--target llvm-tblgen clang-tblgen llvm-config clang-tidy-confusable-chars-gen clang-pseudo-gen
	export HOSTBIN_PATH="/llvm-host/bin"
	export LLVM_NATIVE_TOOL_DIR="$HOSTBIN_PATH"
	export LLVM_TABLEGEN="$HOSTBIN_PATH/llvm-tblgen"
	export CLANG_TABLEGEN="$HOSTBIN_PATH/clang-tblgen"
	export LLVM_CONFIG_PATH="$HOSTBIN_PATH/llvm-config"
	export LLVM_VERSION="$1"

	# Configure LLVM
	CMAKE_TOOLCHAIN_FILE="/cmake/x86_64-redhat-linux.cmake"
	CMAKE_INITIAL_CACHE="/cmake/llvm-distribution.cmake"
	CC=clang CXX=clang++ cmake -G Ninja -S llvm-project/llvm -B llvm-build \
		-DCMAKE_INSTALL_PREFIX=llvm-install \
		-DCMAKE_TOOLCHAIN_FILE="$CMAKE_TOOLCHAIN_FILE" \
		-C $CMAKE_INITIAL_CACHE -Wno-dev

	# Build LLVM
	CC=clang CXX=clang++ cmake --build llvm-build

	# Install LLVM
	CC=clang CXX=clang++ cmake --build llvm-build --target install-distribution
}

case $script_action in
	"setup")
		setup
	;;
	"dll")
		build_dll
	;;
	"llvm")
		build_llvm "$2"
	;;
	*)
		exit 0
	;;
esac
