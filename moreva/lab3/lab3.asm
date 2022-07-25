.MODEL MEDIUM

.STACK 200h

.data
a db 4
b db 3
k db 2
i db 1

.CODE
mov ax,@data
mov ds, ax
xor ax, ax

mov cl, a
mov al, i  ; al=i
mov bl, i  ; bl=i

cmp cl, b 
JG  L1
	;f2
	add bl, 2   ; bl=i+2
	mov cl, bl
	add bl, bl  ; bl=2*(i+2)
	add bl, cl  ; bl=3*(i+2)
	;f1
	mov al, bl  ; al = bl
	shl al, 1   ; al = 6*(i+2)
	sub al, 22  ; al = 6*i-10
jmp endL1

L1:
	sal al, 1 ; al=2*i
	sal al, 1 ; al=4*i
	add al, 3 ; al=4*i+3
	neg al    ; al= -(4*i+3)
	
	mov bl, al 
	sub bl, i
	sub bl, i
	add bl, 7
	
endL1:

getabsI1:
	neg al
js getabsI1	   ; al=|i1|

cmp k, 0
jge L2
	getabsI2:
		neg bl
	js getabsI2	   ; bl=|i2|
	
	add al,bl
	jmp endL2
L2:
	cmp al, 6
	jg max
	mov al, 6
	max:
endL2:

	mov dl, al
	mov ah, 02         
    int 21h 
	
	mov ah, 4ch
	int 21h
ret	
end