## Ubuntu Server Autoinstaller iso
Instructions and helper script to build ubuntu server auto installation iso

### Doc
 - [Official doc](https://ubuntu.com/server/docs/install/autoinstall)
 - [Helpful tutorial](https://www.pugetsystems.com/labs/hpc/ubuntu-22-04-server-autoinstall-iso/)

### Tested on:
 - 7z 16.02 `sudo apt install p7zip`
 - iso 1.5.2 `sudo apt install xorriso`
 - Windows 10 WSL2
 - ubuntu-22.04.1-live-server-amd64.iso

### Instructions
 1. [download iso](https://releases.ubuntu.com/22.04/ubuntu-22.04.1-live-server-amd64.iso)
 2. extract: `7z -y x ubuntu-22.04.1-live-server-amd64.iso -oiso`
 3. `cd iso` 
 4. for simplicity: `mv  '[BOOT]' BOOT`
 5. add autoinstall option to the loader config `boot/grub/grub.cfg`:
    ```
    menuentry "Autoinstall Ubuntu Server" {
      set gfxpayload=keep
    	linux   /casper/vmlinuz quiet autoinstall ds=nocloud\;s=/cdrom/server/  ---
    	initrd  /casper/initrd
    }
    ```
 6. create folder for autoinstaller configs: `mkdir server`
 7. create empty meta-data file: `touch server/meta-data`
 8. create user-data file at `server/user-data` with the follwoing content (see full [doc](https://ubuntu.com/server/docs/install/autoinstall-reference)):
    ```
    #cloud-config
    autoinstall:
      version: 1
     # interactive-sections:  # Install groups listed here will wait for user input
     #  - storage
      storage:  # This should set the interactive (lvm set) default
        layout:
          name: direct
      locale: en_US.UTF-8
      keyboard:
        layout: us
      identity:
        hostname: m3
        password: $6$exDY1mhS4KUYCE/2$zmn9ToZwTKLhCw.b4/b.ZRTIZM30JZ4QrOQ2aOXJ8yk96xpcCof0kxKwuX1kqLG/ygbJ1f8wxED22bTL4F46P0
        username: ubuntu
      ssh:
        allow-pw: true
        install-server: true
     # apt:
     #   primary:
     #     - arches: [default]
     #       uri: http://us.archive.ubuntu.com/ubuntu/
     #   sources:     # Example for adding a ppa source
     #     ignored1:  # This is here to get the yaml formatting right when adding a ppa
     #       source: ppa:graphics-drivers/ppa
     # packages:
     #   - build-essential
     #   - network-manager
     #   - dkms
     #   - emacs-nox
     # - ubuntu-desktop-minimal^  # uncomment to add a minimal desktop
      package_update: false
      package_upgrade: false
      shutdown: poweroff
    ```
 9. `cd ..` and run [`create_iso_args.sh`](./create_iso_args.sh)
 10. flash the iso and install
 11. in case the `create_iso_args.sh` fails, run `xorriso -indev ubuntu-22.04.1-live-server-amd64.iso -report_el_torito as_mkisofs` that will help to adjust arguments in `create_iso_args.sh`
 12. use virtual machine for debugging

