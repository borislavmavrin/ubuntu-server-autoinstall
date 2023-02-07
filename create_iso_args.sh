#!/bin/bash
xorriso -as mkisofs "$(pwd)/iso/" \
	-r -V 'Ubuntu-Server 22.04.1 auto' \
	-o ubuntu-22.04.1-auto-server-amd64.iso \
	--grub2-mbr iso/BOOT/1-Boot-NoEmul.img \
	-partition_offset 16 \
	--mbr-force-bootable \
	-append_partition 2 28732ac11ff8d211ba4b00a0c93ec93b iso/BOOT/2-Boot-NoEmul.img \
	-appended_part_as_gpt \
	-iso_mbr_part_type a2a0d0ebe5b9334487c068b6b72699c7 \
	-c '/boot.catalog' \
	-b '/boot/grub/i386-pc/eltorito.img' \
	-no-emul-boot -boot-load-size 4 -boot-info-table --grub2-boot-info \
	-eltorito-alt-boot \
	-e '--interval:appended_partition_2_start_717863s_size_8496d:all::' \
	-no-emul-boot
