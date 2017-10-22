# Copyright (C) 2017 Luca Filipozzi <luca.filipozzi@gmail.com>
# Released subject to the terms of the Mozilla Public License.

bootargs  = auto
bootargs += console-keymaps-at/keymap=us
bootargs += console-setup/ask_detect=false
bootargs += debconf/frontend=noninteractive
bootargs += debian-installer=en_US
bootargs += fb=false
bootargs += install
bootargs += kbd-chooser/method=us
bootargs += keyboard-configuration/xkb-keymap=us
bootargs += locale=en_US
bootargs += netcfg/get_domain=debian.local
bootargs += netcfg/get_hostname=vm
bootargs += preseed/url=http://10.0.2.10:8080/preseed.cfg

.PHONY: default
default: build

.PHONY: build
build: disk.qcow2

.PHONY: clean
clean:
	rm -f disk.qcow2 disk.img kernel initrd netinst.iso

.PHONY: distclean
distclean: clean
	rm -f debian-9.2.1-amd64-netinst.iso

disk.qcow2: disk.img kernel initrd netinst.iso
	qemu-system-x86_64 -enable-kvm -m size=1G -smp cpus=2 -display curses \
	  -drive if=virtio,file=disk.img,format=raw,index=1,cache=unsafe \
	  -cdrom netinst.iso -boot d -no-reboot \
	  -net nic,name=eth0,model=virtio \
	  -net user,name=eth0,guestfwd=:10.0.2.10:8080-cmd:"busybox httpd -i" \
	  -kernel kernel -initrd initrd -append "${bootargs}"
	qemu-img convert -f raw -O qcow2 disk.img disk.qcow2

.INTERMEDIATE: disk.img
disk.img:
	qemu-img create -f raw disk.img 4G

.INTERMEDIATE: kernel
kernel: netinst.iso
	isoinfo -R -J -i netinst.iso -x /install.amd/vmlinuz > $@

.INTERMEDIATE: initrd
initrd: netinst.iso
	isoinfo -R -J -i netinst.iso -x /install.amd/initrd.gz > $@

.INTERMEDIATE: netinst.iso
netinst.iso: debian-9.2.1-amd64-netinst.iso
	ln -sf $^ $@

.PRECIOUS: debian-9.2.1-amd64-netinst.iso
debian-9.2.1-amd64-netinst.iso:
	wget -c -N https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.2.1-amd64-netinst.iso

