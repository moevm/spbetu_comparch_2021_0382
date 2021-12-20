.MODEL FLAT, C
.CODE


PUBLIC C count_hits_in_interval
count_hits_in_interval PROC C  numbers: dword, n: dword, borders: dword, N_int: dword,  counters: dword
	;remember changable registers
	push esi
	push edi
	push eax
	push ebx
	push ecx

	mov esi, numbers ; esi ~ for moving in 'numbers' array
	mov ecx, n       ; ecx ~ for loop-cycle in 'numbers' array
	mov edi, borders ; edi ~ for moving in 'borders' array
	mov eax, 0       ; eax ~ index for moving inside 'numbers' array
iter_numbers:
	mov ebx, 0	     ; ebx ~ index of interval for moving inside 'borders' array

	check_interval:
		cmp ebx, N_int				; check if it's last "extra" interval [a,a] and Lgr=borders[N_int]("extra" x_max)
		je update_counter
		push eax					; remember eax ~ index of element from 'numbers'
		mov eax, [esi + 4 * eax]    ; put into eax an element from 'numbers'
		cmp eax, [edi + 4 * ebx]    ; cmp element from 'numbers' with Lgr from 'borders'
		pop eax						; restore eax ~ index of element from 'numbers'
		jl update_counter		    ; update counter if element enter in previous interval
		inc ebx						; increment an index of interval 
		jmp check_interval			; go to check the next interval

	update_counter:
		dec ebx						; return to the index of previous interval
		mov edi, counters		    ; load to edi 'counters' array's offset
		push eax					; remember eax ~ index of element from 'numbers'
		mov eax, [edi + 4 * ebx]    ; put into eax current counter for this interval
		inc eax						; counter++
		mov [edi + 4 * ebx], eax	; update the counter for this interval
		pop eax						; restore eax ~ index of element from 'numbers'
		mov edi, borders			; return edi before next iteration 
		inc eax						; increment an index of element from 'numbers'
	
	loop iter_numbers				; go to count hits for the next element from 'numbers'

	;restore saved registers
	pop ecx
	pop ebx
	pop eax
	pop edi
	pop esi
ret
count_hits_in_interval ENDP
END 