    .intel_syntax noprefix
    .text
    .globl func1
    .type func1,@function

func1:
    push rbp
    mov  rbp,rsp
    mov QWORD PTR -8[rbp], rdi 
    mov DWORD PTR -12[rbp], esi 
    mov QWORD PTR -24[rbp], rdx 
    mov DWORD PTR -16[rbp], ecx 

    mov ecx,-12[rbp] #len
    mov rsi, -8[rbp] #input
    mov rdi, -24[rbp] #result
    mov rax,0
start:
    mov eax,[rsi]
    sub eax,-16[rbp]
    imul eax,4
    inc DWORD PTR [rdi+rax]
    add rsi,4
    loop start
    pop rbp
ret    
