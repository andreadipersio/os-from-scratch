Research into operating system development.

Aim of this project:

- Learn operating system internals piece by piece at a very low level
- Document every single step so anyone with programming experience
can understand what's happening and why

### How it work
Every folder contain an *experiment*, which is simply the minimum code
required to boot the system and perform a specific task.
Every experiment can be run with `make`.

### real-mode-x86 [need documentation]
Display hello world in Real mode on x86 architecture.

### protected-mode-x86_64 [todo]
Jump into protected mode, create a system call to print on screen
and call it to display hello world (x86_64 architecture)

### Requirements

- [NASM](http://www.nasm.us/)
- [QEMU](http://wiki.qemu.org/Main_Page)
