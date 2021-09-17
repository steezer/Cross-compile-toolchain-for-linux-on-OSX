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

mkdir download
cd download

startDownload(){
	if [[ ! -f "$(basename $1)" ]]; then
		wget -nc $1
	fi
}

# Download packages
if [[ USE_NEWLIB=1 ]]; then
	startDownload https://ftp.gnu.org/gnu/binutils/$BINUTILS_VERSION.tar.gz
	startDownload https://ftp.gnu.org/gnu/gcc/$GCC_VERSION/$GCC_VERSION.tar.gz
	startDownload https://www.kernel.org/pub/linux/kernel/v4.x/$LINUX_KERNEL_VERSION.tar.xz
	startDownload https://ftp.gnu.org/gnu/glibc/$GLIBC_VERSION.tar.xz
	startDownload https://ftp.gnu.org/gnu/mpfr/$MPFR_VERSION.tar.xz
	startDownload https://ftp.gnu.org/gnu/gmp/$GMP_VERSION.tar.xz
	startDownload https://ftp.gnu.org/gnu/mpc/$MPC_VERSION.tar.gz
	startDownload ftp://gcc.gnu.org/pub/gcc/infrastructure/$ISL_VERSION.tar.bz2
	startDownload ftp://gcc.gnu.org/pub/gcc/infrastructure/$CLOOG_VERSION.tar.gz
else
	startDownload https://ftp.gnu.org/gnu/binutils/$BINUTILS_VERSION.tar.gz
	startDownload https://ftp.gnu.org/gnu/gcc/$GCC_VERSION/$GCC_VERSION.tar.gz
	startDownload https://www.kernel.org/pub/linux/kernel/v4.x/$LINUX_KERNEL_VERSION.tar.gz
	startDownload https://ftp.gnu.org/gnu/glibc/$GLIBC_VERSION.tar.gz
	startDownload https://ftp.gnu.org/gnu/mpfr/$MPFR_VERSION.tar.gz
	startDownload https://ftp.gnu.org/gnu/gmp/$GMP_VERSION.tar.gz
	startDownload https://ftp.gnu.org/gnu/mpc/$MPC_VERSION.tar.gz
	startDownload ftp://gcc.gnu.org/pub/gcc/infrastructure/$ISL_VERSION.tar.gz
	startDownload ftp://gcc.gnu.org/pub/gcc/infrastructure/$CLOOG_VERSION.tar.gz
fi

cd ..

mkdir src
cd src
# Extract everything
for f in ../download/*.tar*; do 
	echo "Tar $f ..."
	tar xfk $f; 
	echo "Tar Success $f"
done

# Make symbolic links
cd $GCC_VERSION
ln -sf `ls -1d ../mpfr-*/` mpfr
ln -sf `ls -1d ../gmp-*/` gmp
ln -sf `ls -1d ../mpc-*/` mpc
ln -sf `ls -1d ../isl-*/` isl
ln -sf `ls -1d ../cloog-*/` cloog
cd ..

trap - EXIT
echo 'Success!'
