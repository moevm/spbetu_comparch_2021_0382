ASSUME CS:CODE, DS:DATA, SS:STACK

STACK SEGMENT STACK
        DW 1024 DUP(?)
STACK ENDS

DATA SEGMENT
    KEEP_CS DW 0
    KEEP_IP DW 0
    string db 0dh,0ah,'int end',0dh,0ah,'$'
DATA ENDS

CODE SEGMENT
    Interruption PROC FAR
        jmp int_start
        SAVE_SS dw 0
        SAVE_SP dw 0
        int_stack dw 32 dup(0)

    int_start:
        mov SAVE_SS, SS
        mov SAVE_SP, SP 
        mov ax, seg int_stack
        mov SS, SP
        mov SP, offset int_start
        push ax
        push dx

	push bx
	push ds
	push cx

	mov cx, 0
    input:

	mov ah,01h
        int 21h
	inc cx
	cmp cx, 5
	jne input	

    prnt:
	mov bx, DATA
	mov ds, bx

        mov ah, 09h
        mov dx, offset string
        int 21h

        pop ax
        pop dx
	
	pop bx
	pop ds
	pop cx

        pop cx
        mov SS, SAVE_SS
        mov SP, SAVE_SP
        mov AL, 20h
        out 20h, AL

    IRET
    Interruption ENDP
    
    Main PROC FAR
        mov ah, 35h
        mov al, 23h
        int 21h
        mov KEEP_IP, bx
        mov KEEP_CS, es

        push ds
        mov dx, offset Interruption
        mov ax, seg Interruption
        mov ds, ax
        mov ah, 25h
        mov al, 23h
        int 21h
        pop ds
        
        begin:
			mov ah,0
			int 16h
			cmp al, 'q'
			je quit
			cmp al,3
			jnz begin
			
			int 23h	
			jmp begin
			
		quit:
        
        CLI
        push ds
        mov  dx, KEEP_IP
        mov  ax, KEEP_CS
        mov  ds, ax
        mov  ah, 25h
        mov  al, 23h
        int 21h
        pop ds
        STI

        mov ah, 4ch
		int 21h    

    Main ENDP
CODE ENDS
END Main