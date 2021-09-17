#! /bin/bash
INSTALL_PATH=/Develop/vendor/toolchain/x86_64-mac-linux
TARGET=x86_64-linux
USE_NEWLIB=0
LINUX_ARCH=x86_64
CONFIGURATION_OPTIONS="--disable-multilib --disable-nls" # --disable-threads --disable-shared
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

