; IntelX86 Processor Addressing Modes Study Program

EOL EQU '$'
ind EQU 2
n1 EQU 500
n2 EQU -50

; Program stack
AStack SEGMENT STACK
    DW 12 DUP(?)
AStack ENDS

; Program data
DATA SEGMENT

; Data description directives
mem1 DW 0
mem2 DW 0
mem3 DW 0
vec1 DB 38,37,36,35,31,32,33,34
vec2 DB 70,80,-70,-80,50,60,-50,-60
matr DB -2,-1,5,6,-8,-7,3,4,-4,-3,7,8,-6,-5,1,2
DATA ENDS


; Program code
CODE SEGMENT
 ASSUME CS:CODE, DS:DATA, SS:AStack


; Head procedure
Main PROC FAR
    push DS
    sub AX,AX
    push AX
    mov AX,DATA
    mov DS,AX

; CHECKING THE ADDRESSING MODES AT THE OFFSET LEVEL
; Register addressing
    mov ax,n1
    mov cx,ax
    mov bl,EOL
    mov bh,n2

; Direct addressing
    mov mem2,n2
    mov bx,OFFSET vec1
    mov mem1,ax

; Indirect addressing
    mov al,[bx]
;    mov mem3,[bx] 

; Based addressing
    mov al,[bx]+3
    mov cx,3[bx]

; Indexed addressing
    mov di,ind
    mov al,vec2[di] 
;    mov cx,vec2[di] 

; Basing and Indexing Addressing
    mov bx,3
    mov al,matr[bx][di]
;    mov cx,matr[bx][di]
;    mov ax,matr[bx*4][di]

; VERIFICATION OF ADDRESSING MODES TAKING INTO ACCOUNT SEGMENTS
; Segment redefinition
; ------ variant 1
    mov ax, SEG vec2
    mov es, ax
    mov ax, es:[bx]
    mov ax, 0

; ------ variant 2
    mov es, ax
    push ds
    pop es
    mov cx, es:[bx-1]
    xchg cx,ax

; ------ variant 3
    mov di,ind
    mov es:[bx+di],ax

; ------ variant 4
    mov bp,sp
;    mov ax,matr[bp+bx] 
;    mov ax,matr[bp+di+si] 

; Using a stack segment
    push mem1 
    push mem2
    mov bp,sp
    mov dx,[bp]+2
    ret 2
Main ENDP
CODE ENDS
 END Main




