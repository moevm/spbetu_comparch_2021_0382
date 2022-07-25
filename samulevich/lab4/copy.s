    .text
    .globl copy 
    .type  copy, @function
    .type  transform, @function


copy:
    .intel_syntax noprefix
    push rbp
    mov rbp,rsp
start:
    mov ax,0
    lodsb
    cmp al,0
    je end
    cmp al,0x41
    jb continue
    cmp al,0x5A
    jbe edit
    cmp al,0x61
    jb continue
    cmp al,0x7A
    ja continue
    sub al,0x20
edit:
    sub al,0x40
    mov dh,0xA
    idiv dh
    cmp al,0
    je units
    call transform
units:
    mov al,ah 
    call transform
    jmp start 
continue:
    stosb
    jmp start
end:
    stosb
stop:
    pop rbp
    ret     

transform:
    add al,0x30
    stosb
    ret



