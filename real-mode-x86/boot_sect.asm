;
; Write 'Hello' on the screen and loop forever
;

jmp start ; jump straight to the main loop

message db "Hello world!", 0 ; our string, 0 is the NULL terminator. 
                             ; 'message' is an address

messageLen: equ $-message    ; get string length by subtracting the current offset ($) with
                             ; message string offset
                             ; message string is 13 bytes long and start after a jmp instruction
                             ; jmp instruction take 2 bytes + 13 bytes, so the current
                             ; offset is 18 minus message string offset, which is 5
                             ; the message length is 13
                             ; 'messageLen' is a constant value

print:                   
    mov cl, 0            ; set counter to 0
    mov ah, 0x0E         ; tty

.nextChar:
    lodsb                ; move character from source register (si) to AL
    inc cl               ; increment counter

    int 0x10             ; print the character to the screen

    cmp cl, messageLen   ; if cl == messageLen
    jz .ret              ; then we are done printing and we return
    jmp .nextChar        ; else we print another character
.ret:
   ret

loopForever:
    jmp $                

start:
    mov ax, 07c0h        ; BIOS takes 1984 bytes 
    mov ds, ax           ; set the data segment (where we store our initialized variables) accordingly

    mov si, message      ; set the source register (si) to point to message string address
    call print           ; call print procedure
    call loopForever     ; loop forever

times 510-($-$$) db 0   ; make boot sector fit 512 bytes
                        ; since we still need to add the 2 byte magic number
                        ; we start our subtraction with 510 then subtract the current offset
                        ; which equal to the size of the file at this point.
                        ; $$ represent the section offset (since we don't have any section is 0)

dw 0xaa55               ; magic number / boot signature
                        ; most BIOSes validate a MBR by checking that the two bytes at 
                        ; offset 1FE (510) correspond to the boot signature
