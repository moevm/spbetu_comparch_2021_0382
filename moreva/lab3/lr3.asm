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
mov bl, i  ; al=i

cmp cl, b 
JG  L1
	sal al, 1  ; al=2*i
	add al, i  ; al=3*i
	sal al, 1  ; al=6*i
	sub al, 10 ; al=6*i-10
	
	add bl, 2   ; bl=i+2
	mov cl, bl
	add bl, bl  ; bl=2*(i+2)
	add bl, cl  ; bl=3*(i+2)
jmp endL1

L1:
	sal al, 1 ; al=2*i
	sal al, 1 ; al=4*i
	add al, 3 ; al=4*i+3
	neg al    ; al=-(4*i+3)
	
	sal bl, 1  ; bl=2*i
	add bl, i  ; bl=3*i
	sal bl, 1  ; bl=6*i
	sub bl, 4  ; bl=6*i-4
	neg bl     ; bl=-(6*i-4)
endL1:

getabsI1:
	neg al
js getabsI1	   ; al=|i1|

getabsI2:
	neg bl
js getabsI2	   ; bl=|i2|
	

cmp k, 0
jge L2
	add al,bl
	jmp endL2
L2:
	cmp al, 6
	jg max
	mov al, 6
	max:
endL2:

	mov ah, 4ch
	int 21h
ret	
end