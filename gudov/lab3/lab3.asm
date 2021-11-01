AStack SEGMENT STACK
    DW 2 DUP(?)
AStack ENDS

DATA SEGMENT
    a   DW 1
    b   DW 3
    i   DW 2
    k   DW 0
    i1  DW ?
    i2  DW ?
    res DW ?
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack
    Main PROC FAR
        push DS
        sub ax,ax
        push ax
        mov ax,DATA
        mov DS, ax

        mov ax, i 
        mov bx, i 
        shl ax, 1
        shl ax, 1
        shl ax, 1  ;ax=8i
        shl bx, 1  ;bx=2i
        sub ax, bx ;ax=6i

        mov cx, a 
        cmp cx, b
        jle case_2
        
        mov i1, 4  ;i1=4
        sub i1, ax ;i1=4-6i

        mov ax, i1 ;ax=4-6i
        add ax, bx ;ax=4-4i
        add ax, 1  ;ax=5-4i
        mov i2, ax ;i2=5-4i

        jmp cont

        case_2:

            shr ax, 1  ;ax=3i
            mov i1, ax ;i1=3i
            add i1, 6  ;i1=3i+6

            mov i2, 10  ;i2=10
            sub i2, ax  ;i2=10-3i

        cont:

        mov ax, i1 
        mov bx, 10
        sub bx, i2 ;bx=10-i2

        mov cx, k
        cmp k, 0
        jge case_02

        mov res, ax
        cmp ax, bx
        jge final
        mov res, bx
        jmp final

        case_02:

            sub ax, i2 ;ax=i1-i2
            mov res, ax
            cmp ax, 0
            jge final

            neg ax
            mov res, ax

        final:
        ret
    Main ENDP    
CODE ENDS
END Main

        