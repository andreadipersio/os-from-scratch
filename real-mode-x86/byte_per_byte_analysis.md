### Generate the binary file
Using nasm, you can generate the binary file for your hello world operating system
using the following command

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
    00000020  eb fe b8 c0 07 8e d0 bc  00 10 b8 c0 07 8e d8 be  |................|
    00000030  02 00 e8 da ff e8 e8 ff  00 00 00 00 00 00 00 00  |................|
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

Where *eb* is the opcode for a JMP instruction and *20* is the starting offset.
20 is an hex number and it correspond to the hexdump line starting with 00000020.

--- TODO: explain why the Jump

If you want to make a nifty experiment, open *boot_sect.asm* and add some `nop` instruction after line 24.
Recompile again and you will that now the first bytes of the file are `eb 23`, meaning that the position
of the start label is changed.

What come after `eb 20` is 

    48 65 6c 6c 6f 20 77 6f  72 6c 64 21 00 b1

This is a 13 byte sequence, which correspond to the string 'Hello world!'. While we see
only 12 characters, internally we need a string terminator, which on our case is '00', adding effectively one byte 
to our string..
In hexdump canonical view '00' is always interpreted as '.'

But what does it mean when I say *correspond to the string 'Hello world!*?

*hexdump* assume that character are encoded using ASCII. Since an ASCII character is 1 byte,
we can take the hex value of this byte (or octal, binary, decimal) and search for it in an 
[ASCII Table](http://web.cs.mun.ca/~michael/c/ascii-table.html).
We will see that each byte (space included) correspond to an ASCII character in order to 
create the words 'Hello' 'World'.

--- TODO: eb 00 = mov cl, 0

[work in progress]
