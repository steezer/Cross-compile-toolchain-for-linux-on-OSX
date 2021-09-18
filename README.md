# Build an x86_64 GCC toolchain for Linux on OSX
## Synopsis

This builds an x86_64 GCC toolchain for Linux on OSX.

This is based on the extremely helpful script, located here:  
https://github.com/johnlondon/Cross-compile-toolchain-for-linux-on-OSX.git

## Installation notes

- You will need `gettext` and `gnu-sed` installed, plus possibly other packages (I have a load installed on my machine already, so I don't know what exactly you'll need on yours).  I suggest installing using brew.
- The makefiles require gnu-sed, not the normal sed that comes with OSX.  If you don't want to mess with the normal sed, perhaps add to the front of PATH the path to gnu-sed before you run this script?  
  Installing using brew will result in the installation of a binary called `gsed` which is not what you want and you'd have to symlink to it from `sed` to get this to work.  You can get
  around the problem by installing like this: `brew install gnu-sed --with-default-names`, which will keep the name as `sed`.
- Edit `vars.sh` first to set package versions.  The versions that will result in a successful build will vary - some package versions will work, some will not.
- You will need to increase the number of open files that are permitted by OSX (check your existing limit using `ulimit -a`). I use 4096.
- This needs to be run/built in a case sensitive partition.  You can create one using OSX's disk utility - I used a 10GB sparse image.  It will be installed to a destination of your choosing, so you can delete the partition file when you're done.
- Clone this repository, change into the directory, download the packages then build.

~~~~
brew install gettext gnu-sed bison
ulimit -n 4096
export PATH=/usr/local/Cellar/gnu-sed/4.8/bin:$PATH
git clone https://github.com/steezer/Cross-compile-toolchain-for-linux-on-OSX.git
./download.sh
./build.sh
~~~~

## Download binary directly
If you want to build by yourself, you can download binary directly, located here:     
https://github.com/steezer/Cross-compile-toolchain-for-linux-on-OSX/releases/download/v1.0.0/x86_64-mac-linux-gcc-8.3.0.tar.gz