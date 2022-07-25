DATA SEGMENT
    old_seg dw 0
    old_ip dw 0
    out_msg DB 'A very informative message...$'
DATA ENDS

AStack SEGMENT STACK
    DW 512 DUP(?)
AStack ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack
; ds:dx must contain message adress ends with '$'
; cx must contain number of prints
; bx must contain time (in cpu ticks)
; data segment must contain 'end_msg' string
CUSTOM_INT PROC FAR
    jmp int_start
    saved_ss dw 0
    saved_sp dw 0
    time db ?, ?, ':', ?, ?, ':', ?, ?, '$'
    int_stack dw 32 dup(?)
int_start:
    mov saved_ss, ss
    mov saved_sp, sp
    mov ax, seg int_stack
    mov ss, ax
    mov sp, offset int_start

    ;storing registers
    push ax
    push bx
    push cx
    push dx

    ;print cx times
    mov ah, 9h
print_loop:
    int 21h
    loop print_loop

    ;pause
    mov ah, 0
    int 1Ah
    add bx, dx
pause:
    mov ah, 0
    int 1Ah
    cmp bx, dx
    jg pause

    ;printing end message
    mov ah, 02h
    int 1ah
    mov bl, cl
    mov cl, 4

    mov ah, 0
    mov al, ch
    ror ax, cl
    shr ah, cl
    or ax, '00'
    mov time, ax

    mov ah, 0
    mov al, bl
    ror ax, cl
    shr ah, cl
    or ax, '00'
    mov time + 3, ax   

    mov ah, 0
    mov al, dh
    ror ax, cl
    shr ah, cl
    or ax, '00'
    mov time + 6, ax      

    mov ah, 09h
    mov bx, seg time
    mov ds, bx
    mov dx, offset time
    int 21h

    ;restoring registers
    pop dx
    pop cx
    pop bx
    pop ax
    mov ss, saved_ss
    mov sp, saved_sp
    
    ;return   
    mov al, 20h
    out 20h, al 
    iret
CUSTOM_INT ENDP

Main PROC FAR
    push DS
    sub ax, ax
    push ax
    mov ax, DATA
    mov ds, ax

    ;storing old int
    mov ax, 3560h
    int 21h
    mov old_seg, es
    mov old_ip, bx

    ;setting custom int
    push ds
    mov dx, offset CUSTOM_INT
    mov ax, seg CUSTOM_INT
    mov ds, ax
    mov ax, 2560h
    int 21h
    pop ds

    ;setting registers according to custom int manual
    mov dx, offset out_msg 
    mov cx, 10h
    mov bx, 36h
    int 60h

    ;restoring old int
    CLI
    push ds
    mov dx, old_ip
    mov ax, old_seg
    mov ds, ax
    mov ax, 251ch
    int 21h
    pop ds
    STI
    
    ret
Main ENDP

CODE ENDS
     END Main

