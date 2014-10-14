;
; Write 'Hello' on the screen and loop forever
;

jmp start

message db "Hello world!", 0
messageLen: equ $-message

print:
    mov cl, 0            ; set counter to 0
    mov ah, 0x0E         ; tty

.nextChar:
    lodsb                ; move character from SI to AL
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
    mov ax, 07c0h
    mov ss, ax
    mov sp, 4096
    mov ax, 07c0h
    mov ds, ax

    mov si, message
    call print
    call loopForever

times 510-($-$$) db 0   ; make boot sector fit 512 bytes

dw 0xaa55               ; magic number
