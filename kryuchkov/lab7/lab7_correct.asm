AStack  SEGMENT STACK
    DB 1024 DUP(?)
AStack  ENDS

DATA    SEGMENT
    A dd 12345678d	;делимое
	Result dd 0	; результат деления
	Remainder dw 0	;остаток
	res_str db 12 dup (0)
    
    hr	dw	0
    lr	dw	0
DATA    ENDS


CODE    SEGMENT
    ASSUME CS:CODE, DS:data, SS:AStack

start PROC NEAR
	; иницализвция ds
	mov ax, data
	mov ds,ax

	mov ax, word ptr [A+2]
    
	mov dx, word ptr [A]
    

    call numb_to_string ; То что в Result переводит в строку res_str
    ; cx - length
    push cx
    push si
    call print
    
	
    call str_to_num
    pop si
    pop cx
    
    mov si, offset res_str

    call numb_to_string ; То что в Result переводит в строку res_str
    mov si, offset res_str
    call print2
    

    mov ax, 4c00h	; выход в DOS
	int 21h
start endp 

numb_to_string proc NEAR

    lea si, res_str
	mov cx,0

	mov word ptr [Result+2], ax
	mov word ptr [Result], dx
	; делитель
	mov bx,10

    again:
	; делим старшее слово
	xor dx,dx	
	mov ax, word ptr [Result+2]
	div bx		

	mov word ptr [Result+2], ax	; сохраняем результат от деления старшего слова
				; в dx остаток от деления

	; делим младшее слово
	mov ax,word ptr [Result]
	div bx 
	
	mov word ptr [Result], ax	; сохраняем результат от деления младшего слова
	mov word ptr [Remainder], dx	; сохраняем остаток от деления

	; переводим цифру в символ и сохраняем 	
	and dx, 0FFh	
	add dx, '0'
	mov [si],dl
	inc si		; смещение следующего символа в строке
	inc cx		; счетчик символов

	
	; если частное от деления не равно 0, то повторяем операцию
	mov ax, word ptr [Result]
	cmp ax,0
	jnz again
	mov ax, word ptr [Result+2]
	cmp ax,0
	jnz again

    ret 
	; печать строки в обратном порядке
	; в cx - длина строки		
numb_to_string ENDP

str_to_num PROC NEAR
; hr lr
; ax - цифра
; hr = hr * 10
; lr = lr * 10, dx
; lr = lr + ax
; hr = hr + dx
	lea si, res_str	
	mov bx,10
	xor dx,dx
again_r:
	xor ah,ah
	mov al, [si]
	cmp al,0
	jz exit


	sub ax, '0'	; ax - цифра
	
	; hr = hr * 10		                                           
	push ax
	push dx
	mov ax,hr
	mov dx,0
	mul bx
	mov hr,ax
	pop dx
	pop ax

	; lr = lr * 10, dx
	push ax
	mov ax,lr
	mov dx,0
	mul bx
	mov lr,ax
	pop ax

	; lr = lr + ax
	add ax, lr
	mov lr,ax
	

	; hr = hr + dx
	mov ax,hr
	add ax,dx
	mov hr,ax


	inc si
	jmp again_r	
    exit:
        mov ax, hr
        mov dx, lr
        mov word ptr [A+2], ax
        mov word ptr [A], dx
        ret
       

	; печать строки в обратном порядке
	; в cx - длина строки	
str_to_num endp

print proc NEAR
print_s:
	mov dl,[si-1]
	mov ah,02h
	int 21h
	dec si
	loop print_s
    ret
print endp

print2 proc NEAR
print_s2:
	mov dl,[si]
	mov ah,02h
	int 21h
	inc si
	loop print_s2
    ret
print2 endp
	
CODE ENDS
     END start 