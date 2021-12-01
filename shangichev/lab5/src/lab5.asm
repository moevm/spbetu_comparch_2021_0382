messnumber EQU 5


DATA SEGMENT
	keep_cs dw 0
	keep_ip dw 0
	message DB 'Hello $'
DATA ENDS

AStack SEGMENT STACK
	DW 512 DUP(?)
AStack ENDS


CODE SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:AStack

SUBR_PRINT PROC FAR
	; store registers
	push dx
	push cx
	push bx
	push ax
	push ax

	mov al, 0

	print_message:
		mov ah, 9
		mov dx, offset message
		int 21h

	set_delay:
		pop cx
		dec cl
		jz complete
		push cx

		cmp al, 0
		je first

		shl al, 1
		jmp start

	first:
		add al, 1

	start:
		mov bl, al
		mov  ah, 2ch
		int  21h 
		mov bh, dh		

	delaying:   
		nop
		mov  ah, 2ch
		int  21h 
		cmp dh, bh
		je delaying

		mov  bh, dh      
		dec  bl   
		jnz  delaying  
		jmp print_message


	complete:
		; restore registers
		pop ax
		pop bx
		pop cx
		pop dx

		mov al, 20h
		out 20h, al
	iret

SUBR_PRINT ENDP


Main PROC FAR
    push DS
    sub ax, ax
    push ax
    mov ax, DATA
    mov ds, ax

    mov ax, 3523h
    int 21h
    mov keep_cs, es
    mov keep_ip, bx

    push ds
    mov dx, offset SUBR_PRINT
    mov ax, seg SUBR_PRINT
    mov ds, ax
    mov ax, 2523h
    int 21h
    pop ds
 

	begin:
		mov ah,0
		int 16h
		cmp al, 'q'
		je quit
		cmp al,3
		jnz begin

		mov al, messnumber ; set number of messages			
		int 23h	
		jmp begin

	quit:




    cli
    push ds
    mov dx, keep_ip
    mov ax, keep_cs
    mov ds, ax
    mov ax, 2523h
    int 21h
    pop ds
    sti
    
    ret
Main ENDP

CODE ENDS
     END Main



