# MEME OS
Welcome to MEME OS, the only linux based operating system dedicated strictly
to the lolz. The goal of this project is to 1) set up the infastructure for 
rapidly building, deploying, and debuging minimal (modified) linux images that
target the qemu x86_64 emulator (ideally on a local ubuntu box). And 2) to 
serve as repo for holding custom linux kernel code, drivers, user apps, etc. 
all with the sole purpose of the author understanding the Linux kernel better.

# Directory Layout
## archives
Tar balls used as seed of project. Contains lts build root source and intial
linux source (4.19.218) that serves as the base for out modifications.

## buildroot (not source controlled)
Contains the buildroot build system that will build the rootfs and kernel. This
is not source controlled as the buildroot system will be treated as a black box.
The init_dir.sh script will unpack the archived source and modify the required
files to compile our linux kernel, our user apps, and our kernel modules and
pack them into the outputed image. 

## docs
Useful documentation on buildroot and linux. Also any documentation associated
with this project will be here.

## kernel-modules
Out of tree kernel modules

## linux-4.19.218
Our custom linux source directory

## scripts
Scripts for initializing the build system, building, and launching

## user-apps
User space applications