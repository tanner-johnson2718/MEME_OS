# MEME OS
Welcome to MEME OS, the only linux based operating system dedicated strictly
to the lolz. The goal of this project is to set up the infastructure for 
rapidly building, deploying, and debuging minimal (modified) linux images that
target the qemu x86_64 emulator using the buildroot build system. The purpose
is to have a sandbox for building linux systems where one can modify and debug 
the linux kernel. This project will also be a starting point for future linux 
builds that actaully target real hardware. Project milestones include but are
not limited too:

- [X] Set of out of tree user apps that are "compiled" into image
- [-] Set of out of tree kernel mods that are "compiled" into image
- [X] Script to create boiler plate for new user apps
- [-] Script to create boiler plate for new kernel modules
- [ ] Set of scripts to build and clean from scratch
- [-] Set of scripts to iterativly build apps without rebuilding entire tool 
      chain and kernel
- [ ] Set of scripts to iterativly build kernel modules without rebuilding 
      entire tool chain and kernel
- [-] Script to rebuild kernel only
- [-] Saved out of tree buildroot .config
- [-] Saved out of tree linux .config
- [-] GDB attached to kernel execution

# System Set Up
* Clone this repo
* git submodule init on buildroot subrepo
* Check [deps](./docs/deps.txt) and install if need be.

# Buildroot and Linux Menuconfig

The menuconfig system is used to configure both linux and the buildroot system. The [buildroot user man](./docs/build_root_manual.pdf) has some good info on how to configure buildroot. It is accessed via `make menuconfig` from inside the buildroot dir. The linux menuconfig can be accessed with the command `make linux-menuconfig`. This will export the cofigured linux .config to the location you specify. Save off this linux config into `scripts/.config`.

Further more in buildroot be sure to export the rootFS as an ext4 filesystem, build the kernel with debug symbols, and point the system to use our custom linux .config.

```
BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG=y
BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="$(TOPDIR)/../scripts/.config"  #Path to linux config
BR2_ENABLE_DEBUG=y
BR2_ENABLE_RUNTIME_DEBUG=y
BR2_TARGET_ROOTFS_EXT2=y 
BR2_TARGET_ROOTFS_EXT2_4=y
```

Recommend to use `make menuconfig` to set these values as there are several sub params that will be automatically set if on uses the `menucofig`. The above values can be searched in the buildroot menuconfig. Once buildroot is configured to your liking, Save off `.config` and the `package/Config.in` files into the scripts directory. Save buildroot `.config` as `buildroot.config`.

# Build and Execute

* `source ./scripts/env_init.sh`
  * The source script exports several important variables that will be used by other scripts
  * It also sets and checks that you are in the base dir of the git repo
* `./scripts/build`, then y to build 
  * 
* `./scipts/launch.sh`

# Creating a User Space Application
* 


# Directory Layout
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
Out of tree kernel modules. See *user-apps* below for package structure. Also see [hellomod](./kernel-modules/hellomod/) as an example.

- *scripts*
Scripts for initializing the build system, building, and launching. Also contains buildroot and linux .config files.

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
