ASSUME CS:CODE, DS:DATA, SS:STACK

STACK SEGMENT STACK
	DW 512 DUP(?)
STACK ENDS

DATA SEGMENT
	KEEP_CS DW 0
    KEEP_IP DW 0

DATA ENDS

CODE SEGMENT
	MY_SUBR_INT PROC FAR
        push AX
		push CX
	input:
		mov AL, 10110110b
		out 43h, AL
		mov AX, BX
		out 42h, AL
		mov AL, AH
		out 42h, AL
		in AL, 61h
		mov AH, AL
		or AL, 3
		out 61h, AL
		sub CX, CX
		forloop: loop forloop
		mov AL, AH
		out 61h, AL
        mov AL, 20h
        out 20h, AL
		mov AH, 0h
		int 16h
		cmp AL, 'H'
		je higher_sound
		cmp AL, 'L'
		je low_sound
		jmp exit
		low_sound:
			cmp BX, 10000
			jge input
			add BX, 1000
			jmp input
		higher_sound:
			cmp BX, 1000
			jle input
			sub BX, 1000
			jmp input
		exit:
			pop AX
			pop CX
			iret
	MY_SUBR_INT  ENDP
	
	MAIN PROC FAR		
		mov AX, 3560h
		int 21h
		mov KEEP_IP, BX
		mov KEEP_CS, ES
		mov BX, 5000
		
		push DS
		mov dx, offset MY_SUBR_INT 
		mov AX, seg MY_SUBR_INT
		mov DS, AX
		mov AX, 2560h
		int 21h
		pop DS
		int 60h
			cli
			push DS
			mov DX, KEEP_IP
			mov AX, KEEP_CS
			mov DS, AX
			mov AH, 25h
			mov AL, 60h
			int 21h
			pop	DS
			sti
			mov AH, 4ch
			int 21h
	MAIN ENDP
CODE ENDS
END MAIN 