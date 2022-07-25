    .intel_syntax noprefix
    .text
    .globl func2
    .type func2,@function

func2:
    push rbp
    mov rbp,rsp

    mov QWORD PTR -8[rbp], rdi #res_1
    mov QWORD PTR -16[rbp], rsi #intervals
    mov QWORD PTR -24[rbp], rdx #res_2
    mov DWORD PTR -28[rbp], ecx #right_border
    mov DWORD PTR -32[rbp], r8d #len
    mov DWORD PTR -36[rbp], r9d #min
 
    mov rdi,-24[rbp] #res_2
    mov rsi,-8[rbp] #res_1
    sub rsi,4
    mov rbx, -16[rbp] #intervals
    mov ecx, -32[rbp] #intervals len
    dec ecx
    mov edx, -36[rbp] #min
    dec edx
    

skip:
    inc edx
    add rsi,4 
    cmp DWORD PTR [rsi],0
    je skip


    cmp edx,DWORD PTR [rbx]
    jge next
    mov edx,[rbx]
next:
    
    cmp ecx,0
    je end

    
start:
    add rbx,4
    mov eax,[rbx]

sum:
    cmp edx,eax
    jge continue
    mov r8d,[rsi]
    add [rdi],r8d
    inc edx
    add rsi,4
    jmp sum

continue:
    add rdi,4
    loop start


end:
    mov eax,-28[rbp]
last_sum:
    cmp edx,eax
    jg return
    mov r8d,[rsi]
    add [rdi],r8d
    inc edx
    add rsi,4
    jmp last_sum

return:
pop rbp
ret
