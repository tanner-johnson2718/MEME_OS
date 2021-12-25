# MEME OS
Welcome to MEME OS, the only linux based operating system dedicated strictly
to the lolz. The goal of this project is to set up the infastructure for 
rapidly building, deploying, and debuging minimal (modified) linux images that
target the qemu x86_64 emulator initially and hopefully other arch. with
minimal modifications. The intent is to have this minimal infastructure ready
to go so if one needs to debug kernel modifications its ready to go.

# Directory Layout
- *archives*
Tar balls used as seed of project. Contains build root source and intial linux 
source (4.19.218) that serves as the base for out modifications.

- *buildroot* (not source controlled)
Contains the buildroot build system that will build the rootfs and kernel. This
is not source controlled as the buildroot system will be treated as a black box.
The init_dir.sh script will unpack the archived source and modify the required
files to compile our linux kernel, our user apps, and our kernel modules and
pack them into the outputed image. 

- *docs*
Useful documentation on buildroot and linux. Also any documentation associated
with this project will be here.

- *kernel-modules*
Out of tree kernel modules

- *linux-4.19.218*
Our custom linux source directory

- *scripts*
Scripts for initializing the build system, building, and launching

- *user-apps*
User space applications. Each application gets a directory here with a flat dir
structure i.e. no placing several user apps in a sub folder here. Every app 
needs to adhere to the following structure:
  - user-apps
    - app_name
      - Config.in
      - app_name.mk
      - src
        - Makefile
        - application source code

For more info on the Config.in and .mk file see the buildroot slised in docs.
Or take a look at the hello example. As a final note the meta data (Config.in 
and .mk) are copied into the buildroot dir and the meta data itself should
point to the source contained in src.
