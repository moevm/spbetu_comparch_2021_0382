ASSUME CS:CODE, DS:DATA, SS:STACK

STACK SEGMENT STACK
	DW 1024 DUP(?)
STACK ENDS

DATA SEGMENT
	KEEP_CS DW 0
    KEEP_IP DW 0

DATA ENDS

CODE SEGMENT
	inter PROC FAR
        push ax
		push cx
        
		mov al, 10110110b
		out 43h, al
		
		mov ax, bx
		out 42h, al
		mov al, ah
		out 42h, al
		
		in al, 61h
		mov ah, al
		or al, 3
		out 61h, al
		
		sub cx, cx
		l: loop l
			
		mov al, ah
		out 61h, al
		
        pop ax
		pop cx
        mov al, 20h
        out 20h, al
        iret
	inter  ENDP
	main PROC FAR		
		mov ah, 35h
		mov al, 60h
		int 21h
		mov KEEP_IP, bx
		mov KEEP_CS, es
		
		mov bx, 4500
		
		push ds
		mov dx, offset inter 
		mov ax, seg inter
		mov ds, ax
		mov ah, 25h
		mov al, 60h
		int 21h
		pop ds
		
		jmp readKey
		incFrec:
			cmp bx, 100
			jle readKey
			sub bx, 100
			int 60h
			jmp readKey
		decFrec:
			cmp bx, 10000
			jge readKey
			add bx, 100
			int 60h
		readKey:
			mov ah, 0h
			int 16h
			cmp al, 'a'
			je decFrec
			cmp al, 's'
			je incFrec
		
		cli
		push ds
		mov dx, KEEP_IP
		mov ax, KEEP_CS
		mov ds, ax
		mov ah, 25h
		mov al, 60h
		int 21h
		pop	ds
		sti
		
		mov ah, 4ch
		int 21h
	main ENDP
CODE ENDS
END main