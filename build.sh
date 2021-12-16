#! /bin/bash
set -e
#-------------------------------------------------------------------------------------------
# This script will configure, build and install a GCC cross-compiler.
# It assumes that all packages have been downloaded using download.sh before this file is run.
# Customize the variables (INSTALL_PATH, TARGET, etc.) in vars.sh to your liking before running.
# If you get an error and need to resume the script from some point in the middle,
# just delete/comment the preceding lines before running it again.
#
# See: http://preshing.com/20141119/how-to-build-a-gcc-cross-compiler
#
# This script requires gnu-sed, not the normal sed that comes with OSX.  If you don't want to
# mess with the normal sed, perhaps add to the front of PATH the path to gnu-sed before you
# run this script?  e.g. export PATH=/path/to/gnu-sed-directory/bin:$PATH
#
# This script should be run in a case-sensitive partition which you can make using OSX's disk 
# utility.
#-------------------------------------------------------------------------------------------

source ./vars.sh

# extra flags and env variables are needed to get this to compile on OSX
export BUILD_ALL_BASE_DIR=`pwd`
export HOST_EXTRACFLAGS="-I$BUILD_ALL_BASE_DIR/endian"

# these are needed for gettext and assuming that it was installed using brew
export BUILD_CPPFLAGS='-I/usr/local/include -I/usr/include'
export BUILD_LDFLAGS='-L/usr/lib -L/usr/local/lib -lintl'

ulimit -n 4096
# clean all
if [[ "$1" = "clean" ]]; then
    rm -rf ./build/build-*
    rm -rf ${INSTALL_PATH}/*
fi
if [[ ! -d "build" ]]; then
    mkdir build
fi
cd build

buildStep1(){
	echo "Step 1. Binutils">step.log
	echo "  start: $(date "+%Y-%m-%d %H:%M:%S")">>step.log
	echo -e "\nStep 1 - building binutils...\n" && sleep 2
	[ -d build-binutils ] || rm -rf build-binutils
	mkdir -p build-binutils
	cd build-binutils
	../../src/$BINUTILS_VERSION/configure --prefix=$INSTALL_PATH --target=$TARGET $BINUTIL_OPTIONS
	make $PARALLEL_MAKE
	make install
	cd ..
	echo "    end: $(date "+%Y-%m-%d %H:%M:%S")">>step.log
}

buildStep2(){
	echo "Step 2. Linux Kernel Headers">>step.log
	echo "  start: $(date "+%Y-%m-%d %H:%M:%S")">>step.log
	echo -e "\nStep 2 - Linux kernel headers...\n" && sleep 2
	if [ $USE_NEWLIB -eq 0 ]; then
	    cd ../src/$LINUX_KERNEL_VERSION
	    if [[ ! -d "arch/aarch64" ]]; then
	    	cp -r arch/arm64 arch/aarch64
	    fi
	    make V=1 ARCH=$LINUX_ARCH INSTALL_HDR_PATH=$CROSS_SYSROOT/usr headers_install
	    cd ../../build
	fi
	echo "    end: $(date "+%Y-%m-%d %H:%M:%S")">>step.log
}

buildStep3(){
	echo "Step 3. C/C++ Compilers">>step.log
	echo "  start: $(date "+%Y-%m-%d %H:%M:%S")">>step.log
	echo -e "\nStep 3 - C/C++ compilers...\n" && sleep 2
	[ -d build-gcc ] || rm -rf build-gcc
	mkdir -p build-gcc
	cd build-gcc
	../../src/$GCC_VERSION/configure --prefix=$INSTALL_PATH  --target=$TARGET --enable-languages=c,c++ $GCC_OPTIONS
	# gcc_cv_libc_provides_ssp=no 
	make $PARALLEL_MAKE all-gcc
	make install-gcc
	cd ..
	echo "    end: $(date "+%Y-%m-%d %H:%M:%S")">>step.log
}

buildStep4(){
	echo "Step 4. Standard C Library Headers and Startup Files">>step.log
	echo "  start: $(date "+%Y-%m-%d %H:%M:%S")">>step.log
	echo -e "\nStep 4 - standard lib headers...\n" && sleep 2
	[ -d build-glibc ] || rm -rf build-glibc
	mkdir -p build-glibc
	cd build-glibc
	
	../../src/$GLIBC_VERSION/configure --prefix=/usr --build=$MACHTYPE --host=$TARGET --target=$TARGET --with-headers=$CROSS_SYSROOT/usr/include $GLIBC_OPTIONS libc_cv_forced_unwind=yes
	make install-bootstrap-headers=yes install-headers DESTDIR=$CROSS_SYSROOT
	make $PARALLEL_MAKE csu/subdir_lib
	[ -d "${CROSS_SYSROOT}/usr/lib" ] || mkdir -p "${CROSS_SYSROOT}/usr/lib"
	install csu/crt1.o csu/crti.o csu/crtn.o ${CROSS_SYSROOT}/usr/lib
	$TARGET-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o ${CROSS_SYSROOT}/usr/lib/libc.so
	touch ${CROSS_SYSROOT}/usr/include/gnu/stubs.h
	cd ..
	echo "    end: $(date "+%Y-%m-%d %H:%M:%S")">>step.log
}

# Two static libraries, libgcc.a and libgcc_eh.a, 
# are installed to /opt/cross/lib/gcc/aarch64-linux/4.9.2/.
# A shared library, libgcc_s.so, is installed to /opt/cross/aarch64-linux/lib64.
buildStep5(){
	echo "Step 5. Compiler Support Library">>step.log
	echo "  start: $(date "+%Y-%m-%d %H:%M:%S")">>step.log
	echo -e "\nStep 5 - building libgcc...\n" && sleep 2
	cd build-gcc
	make $PARALLEL_MAKE all-target-libgcc
	make install-target-libgcc
	cd ..
	echo "    end: $(date "+%Y-%m-%d %H:%M:%S")">>step.log
}

# In this step, we finish off the Glibc package, 
# which builds the standard C library and installs its files to /opt/cross/aarch64-linux/lib/. 
# The static library is named libc.a and the shared library is libc.so.
buildStep6(){
	echo "Step 6. Standard C Library & the rest of Glibc">>step.log
	echo "  start: $(date "+%Y-%m-%d %H:%M:%S")">>step.log
	echo -e "\nStep 6 - standard C library and the rest of glibc...\n" && sleep 2
	cd build-glibc
	make $PARALLEL_MAKE
	make install DESTDIR=$CROSS_SYSROOT
	cd ..
	echo "    end: $(date "+%Y-%m-%d %H:%M:%S")">>step.log
}

# Finally, we finish off the GCC package, which builds the standard C++ library 
# and installs it to /opt/cross/aarch64-linux/lib64/. 
# It depends on the C library built in step 6. 
# The resulting static library is named libstdc++.a and the shared library is libstdc++.so.
buildStep7(){
	echo "Step 7. Standard C++ Library & the rest of GCC">>step.log
	echo "  start: $(date "+%Y-%m-%d %H:%M:%S")">>step.log
	echo -e "\nStep 7 - building C++ library and rest of gcc\n"  && sleep 2
	cd build-gcc
	make $PARALLEL_MAKE all
	make install
	cd ..
	echo "    end: $(date "+%Y-%m-%d %H:%M:%S")">>step.log
}

#################################################################
#####################Build step##################################

# # Step 1. Binutils
buildStep1

# # Step 2. Linux Kernel Headers
buildStep2

# # Step 3. C/C++ Compilers
buildStep3

# Step 4. Standard C Library Headers and Startup Files
buildStep4

# Step 5. Compiler Support Library
buildStep5

# Step 6. Standard C Library & the rest of Glibc
buildStep6

#Step 7. Standard C++ Library & the rest of GCC
buildStep7

echo "Build successfully!"
echo "Success: $(date "+%Y-%m-%d %H:%M:%S")">>step.log
