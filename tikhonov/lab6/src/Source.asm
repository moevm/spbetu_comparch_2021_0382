.586
.MODEL FLAT, C 
.CODE
FUNC PROC C array:dword, array_size:dword, left_boarders:dword, intervals_size:dword, result_array:dword
push ecx
push esi
push edi
push eax
push ebx;  

mov ecx, array_size
mov esi, array
mov edi, left_boarders
mov eax, 0;   
l1:                    
	mov ebx, 0    
	boarders:      
 		cmp ebx, intervals_size ;     
		jge boarders_exit
		push eax
		mov eax, [esi+4*eax]
		cmp eax, [edi+4*ebx]
		pop eax
		jl boarders_exit
		inc ebx
		jmp boarders
	boarders_exit:
	dec ebx        ;     ,    

	cmp ebx, -1    ;   -1,        
	je skip
	mov edi, result_array
	push eax
	mov eax, [edi+4*ebx]
	inc eax
	mov [edi+4*ebx], eax
	pop eax
	mov edi, left_boarders
	skip:
	inc eax       ;    
loop l1

pop ebx ;  
pop eax
pop edi
pop esi
pop ecx
ret
FUNC ENDP
END