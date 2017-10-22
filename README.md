# qemu-vm

The purpose of this project is to illustrate how to build and run a minimal
Debian 9 (stretch) qemu virtual machine that is capable of using qemu's curses
display.

## build

Execute `make build` to build the virtual machine image.

## run

Execute `start-vm-curses` to run the virtual machine in the foreground with a
curses display. Log in at the console or via ssh.

Execute `start-vm-daemon` to run the virtual machine in the background with no
display. Log in via ssh.

## log in

Log in with username of `sysadmin` and password of `sysadmin` either at the
console (curses display) or via ssh:

```
ssh -p 10022 sysadmin@localhost
```

## observations

`qemu-system-x86_64` uses the Bochs VGA interface (aka qemu stdvga). To disable
the framebuffer for this emulated video card, `bochs_drm.fbdev=off` is passed
to the Linux kernel per [this advice][1].

## license

This project is copyright (C) 2017 Luca Filipozzi <luca.filipozzi@gmail.com>
and is released subject to the terms of the Mozilla Public License v2. Please
see the included LICENSE.txt for the full text of Mozilla Public License v2.

[1]: https://unix.stackexchange.com/a/347751/105853

