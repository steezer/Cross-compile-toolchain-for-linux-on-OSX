#! /bin/bash
INSTALL_PATH=/Develop/vendor/toolchain/x86_64-mac-linux-gnu
TARGET=x86_64-linux
USE_NEWLIB=0
LINUX_ARCH=x86_64
CROSS_BASEDIR=${INSTALL_PATH}/${TARGET}
CROSS_SYSROOT=${CROSS_BASEDIR}/sysroot
CROSS_USRROOT=${CROSS_BASEDIR}/sysroot/usr

# --with-build-sysroot=$CROSS_BASEDIR
CROSS_OPTIONS="--with-local-prefix=$CROSS_SYSROOT/usr/local "
CROSS_OPTIONS="$CROSS_OPTIONS --with-native-system-header-dir=/usr/local/include "
CROSS_OPTIONS="$CROSS_OPTIONS --with-native-system-header-dir=/usr/include "
OTHER_OPTIONS="--disable-multilib --disable-nls --enable-lto --enable-threads=posix --enable-target-optspace "
OTHER_OPTIONS="$OTHER_OPTIONS --enable-plugin --enable-gold "

BINUTIL_OPTIONS="--with-sysroot=$CROSS_SYSROOT $CROSS_OPTIONS $OTHER_OPTIONS"
GCC_OPTIONS="--with-sysroot=$CROSS_SYSROOT $CROSS_OPTIONS $OTHER_OPTIONS"
GCC_BUILD_OPTIONS="$OTHER_OPTIONS"
GLIBC_OPTIONS="$OTHER_OPTIONS"


PARALLEL_MAKE=-j4
BINUTILS_VERSION=binutils-2.25
GCC_VERSION=gcc-8.3.0
LINUX_KERNEL_VERSION=linux-4.19.1
GLIBC_VERSION=glibc-2.28
MPFR_VERSION=mpfr-4.1.0
GMP_VERSION=gmp-6.2.1
MPC_VERSION=mpc-1.2.1
ISL_VERSION=isl-0.18
CLOOG_VERSION=cloog-0.18.1
export PATH=/usr/local/Cellar/gnu-sed/4.8/bin:/usr/local/opt/bison/bin:$INSTALL_PATH/bin:$PATH
export CFLAGS="-std=gnu11 -O2"
export CXXFLAGS="-std=gnu++11 -O2"
export LDFLAGS="-L$CROSS_SYSROOT/usr/lib"

