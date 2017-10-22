# Copyright (C) 2017 Luca Filipozzi <luca.filipozzi@gmail.com>
# Released subject to the terms of the Mozilla Public License.

# reduce boot delay
busybox sed -i -e 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub

# disable quiet; enable text mode; disable framebuffer
busybox sed -i -e 's/"quiet"/"text bochs_drm.fbdev=off"/' /etc/default/grub

# enable console
busybox sed -i -e 's/#GRUB_TERMINAL=console/GRUB_TERMINAL=console/' /etc/default/grub

update-grub

# vim: set ft=sh:
