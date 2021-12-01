ASSUME CS:CODE, DS:DATA, SS:STACK
.186
STACK SEGMENT STACK
	DW 1024 DUP(?)
STACK ENDS

DATA SEGMENT
	KEEP_CS DW 0
    KEEP_IP DW 0
DATA ENDS

CODE SEGMENT
	print_cmos proc near
        out        70h,al               ; послать AL в индексный порт CMOS
        in         al,71h               ; прочитать данные
        push       ax
        shr        al, 4                 ; выделить старшие четыре бита
        add        al,'0'               ; добавить ASCII-код цифры 0
        int        29h                  ; вывести на экран
        pop        ax
        and        al,0Fh               ; выделить младшие четыре бита
        add        al,30h               ; добавить ASCII-код цифры 0
        int        29h                  ; вывести на экран
        ret
	print_cmos endp

	inter PROC FAR
        push    ax
		push    bx
		push    cx
		push    dx
		push    ds
		
		mov        al,0Bh               ; CMOS OBh - управляющий регистр В
        out        70h,al               ; порт 70h - индекс CMOS
        in         al,71h               ; порт 71h - данные CMOS
        and        al,11111011b         ; обнулить бит 2 (форма чисел - BCD)
        out        71h,al               ; и записать обратно
        mov        al,4h                 ; CMOS 04h - час
        call       print_cmos
        mov        al,':'               ; двоеточие
        int        29h
        mov        al,2h                 ; CMOS 02h - минута
        call       print_cmos
        mov        al,':'               ; двоеточие
        int        29h
        mov        al,0h                ; CMOS 00h - секунда
        call       print_cmos
		mov        al, 10               
        int        29h
		mov        al, 13               
        int        29h
		
		pop ax
        pop bx
        pop cx
        pop dx
        pop ds
        mov al, 20h
        out 20h, al
        iret
	inter  ENDP
	
	main PROC FAR	
	
		mov ah, 35h
		mov al, 23h
		int 21h
		mov KEEP_IP, bx
		mov KEEP_CS, es
	
		push ds
		mov dx, offset inter 
		mov ax, seg inter
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
		
		cli
		push ds
		mov dx, KEEP_IP
		mov ax, KEEP_CS
		mov ds, ax
		mov ah, 25h
		mov al, 23h
		int 21h
		pop	ds
		sti
		
		mov ah, 4ch
		int 21h
	main ENDP
CODE ENDS
END main 