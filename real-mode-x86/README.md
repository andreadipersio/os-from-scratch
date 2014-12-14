### Requirements
You need to install NASM and QEMU
If you are on a OSX use brew:

    brew install nasm
    brew install qemu

### Run it!
Running `make` will invoke nasm to create our image file
and launch QEMU.

### How the image file is generated
When calling make, the following command is invoked:

	nasm boot_sect.asm -f bin -o boot_sect.bin

Let stop for a moment and understand what exactly mean to generate a binary
file using nasm.

[From the nasm manual](http://www.nasm.us/doc/nasmdoc7.html)

>The bin format does not produce object files: it generates nothing in the output file except the code you wrote. Such `pure binary' files are used by MS-DOS: .COM executables and .SYS device drivers are pure binary files. Pure binary output is also useful for operating system and boot loader development.

>The bin format supports multiple section names. For details of how NASM handles sections in the bin format, see section 7.1.3.

>Using the bin format puts NASM by default into 16-bit mode (see section 6.1). In order to use bin to write 32-bit or 64-bit code, such as an OS kernel, you need to explicitly issue the BITS 32 or BITS 64 directive.

>bin has no default output file name extension: instead, it leaves your file name as it is once the original extension has been removed. Thus, the default is for NASM to assemble binprog.asm into a binary file called binprog.

### Analyze the binary file

I usually use [hexdump](http://mylinuxbook.com/hexdump/) to dwelve into binary files.

    hexdump -vC boot_sect.bin 

    00000000  eb 20 48 65 6c 6c 6f 20  77 6f 72 6c 64 21 00 b1  |. Hello world!..|
    00000010  00 b4 0e ac fe c1 cd 10  80 f9 0d 74 02 eb f4 c3  |...........t....|
    00000020  eb fe b8 c0 07 8e d8 be  02 00 e8 e2 ff e8 f0 ff  |................|
    00000030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000060  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000070  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000080  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000090  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    000000a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    000000b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    000000c0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    000000d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    000000e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    000000f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000100  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000120  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000130  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000140  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000150  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000160  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000170  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000180  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00000190  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    000001a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    000001b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    000001c0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    000001d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    000001e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa  |..............U.|
    00000200


So now we will look into each line to understand what's going on.
Since not everyone may be familiar with *hexdump*, I'll give an explanation of what's going
on, while analyzing the first line.

    00000000  eb 20 48 65 6c 6c 6f 20  77 6f 72 6c 64 21 00 b1  |. Hello world!..|

So, starting from the left, we have `00000000`.
This is the starting offset in the file for the next 16 byte that follows.

    eb 20 48 65 6c 6c 6f 20 77 6f  72 6c 64 21 00 b1

`eb 20` correspond to line 5 of *boot_sect.asm*: `jmp .start`, it's called a *Relative Short Jump*.

*eb* is the opcode for a JMP instruction, *20* is destination offset.
So this instruction will move the instruction pointer to the bytes starting at file offset 20,
which correspond to the hexdump line starting 00000020 and to the section *start* of our *boot_sect.asm*.

We can play with JMP instruction by opening *boot_sect.asm* and add some `nop` instruction after line 24.
Recompile again and you will that now the first bytes of the file are `eb 23`, meaning that the position
of the start label is changed.

We are going to store 'Hello world!' string and our string printing code at the top of the file.
We want to run this code only inside our main loop so this is why we perform a jmp to *start*.

The next sequence of bytes is:

    48 65 6c 6c 6f 20 77 6f  72 6c 64 21 00 b1

On the right you can see the sentence 'Hello world!' in the canonical view.
The canonical view is where hexdump try to match the bytes value to the 
[ASCII Table](http://web.cs.mun.ca/~michael/c/ascii-table.html).

Each byte from 48 to 00 correspond to a character in the ASCII table. You can
manually search the ascii table for the correspondence between characters and hex values.
*00* is called a NULL string terminator and it marks the end of the string.

Before going on let's stop for a moment to notice some interesting things.

- comments and empty lines are not translated to machine code
- the machine code file contains instructions in the same order as our assembly file, one after the other, from 
top to bottom.

Back to our machine code.
The next two bytes, `b1 00` corresponds to `mov cl, 0` instruction.
`b0` is the opcode for `mov cl` and 00 is the value we want to put into register *cl*.

You can probably guess which instructions is represented by the two bytes that follows.
Yes, `b4 0e` represent `mov ah, 0x0E`, where `b4` is the opcode for `mov ah` and 0e is the value we 
want to store in the register.

Notice how machine code have no notion of labels. The last 4 bytes we read belong to the *print* label yet we cannot find nothing about them in our machine code. In fact labels are just a facility which make easier for programmer to not worry about memory location. 
Every time the compiler find a reference to a label, it replace the label with its memory location. We already saw this happens. Remember the first two bytes of our machine code? 

    eb 20   ->   jmp start

20 is the memory offset where we can find the code belonging to the start label.
