# MEME OS
Welcome to MEME OS, the only linux based operating system dedicated strictly
to the lolz. The goal of this project is to set up the infastructure for 
rapidly building, deploying, and debuging minimal (modified) linux images that
target the qemu x86_64 emulator using the buildroot build system. The purpose
is to have a sandbox for building linux systems and a starting point for 
future linux builds that actaully target real hardware. Project milestones
include but are not limited too:

- [X] Archived buildroot build system and linux source
- [X] Set of out of tree user apps that are "compiled" into image
- [ ] Set of out of tree kernel mods that are "compiled" into image
- [X] Script to create boiler plate for new user apps
- [ ] Script to create boiler plate for new kernel modules
- [X] Set of scripts to build and clean from scratch
- [X] Set of scripts to iterativly build apps without rebuilding entire tool 
      chain and kernel
- [ ] Set of scripts to iterativly build kernel modules without rebuilding 
      entire tool chain and kernel
- [X] Script to rebuild kernel only
- [X] Saved out of tree buildroot .config
- [X] Saved out of tree linux .config

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
