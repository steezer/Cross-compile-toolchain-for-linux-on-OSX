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

cd src
# Extract everything
for f in ../../download/*.tar*; do 
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
