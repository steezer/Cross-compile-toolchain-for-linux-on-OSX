#! /bin/bash
set -e
trap 'previous_command=$this_command; this_command=$BASH_COMMAND' DEBUG
trap 'echo FAILED COMMAND: $previous_command' EXIT

#-------------------------------------------------------------------------------------------
# This script will download packages for a GCC cross-compiler.
# Customize the variables (INSTALL_PATH, TARGET, etc.) in vars.sh to your liking before running.
#
# See: http://preshing.com/20141119/how-to-build-a-gcc-cross-compiler
#-------------------------------------------------------------------------------------------

source ./vars.sh

cd ../download

startDownload(){
	if [[ ! -f "$(basename $1)" ]]; then
		wget -nc $1
	fi
}

# Download packages
export http_proxy=$HTTP_PROXY https_proxy=$HTTP_PROXY ftp_proxy=$HTTP_PROXY
startDownload https://ftp.gnu.org/gnu/binutils/$BINUTILS_VERSION.tar.gz
startDownload https://ftp.gnu.org/gnu/gcc/$GCC_VERSION/$GCC_VERSION.tar.gz
if [ $USE_NEWLIB -ne 0 ]; then
    wget -nc -O newlib-master.zip https://github.com/bminor/newlib/archive/master.zip || true
    unzip -qo newlib-master.zip
else
    startDownload https://www.kernel.org/pub/linux/kernel/v4.x/$LINUX_KERNEL_VERSION.tar.xz
    startDownload https://ftp.gnu.org/gnu/glibc/$GLIBC_VERSION.tar.xz
fi
startDownload https://ftp.gnu.org/gnu/mpfr/$MPFR_VERSION.tar.xz
startDownload https://ftp.gnu.org/gnu/gmp/$GMP_VERSION.tar.xz
startDownload https://ftp.gnu.org/gnu/mpc/$MPC_VERSION.tar.gz
startDownload ftp://gcc.gnu.org/pub/gcc/infrastructure/$ISL_VERSION.tar.bz2
startDownload ftp://gcc.gnu.org/pub/gcc/infrastructure/$CLOOG_VERSION.tar.gz

trap - EXIT
echo 'Success!'
