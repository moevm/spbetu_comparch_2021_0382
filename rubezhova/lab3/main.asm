ASSUME CS:CODE, DS:DATA, SS:AStack

AStack    SEGMENT  STACK
          DW 12 DUP('?')  
AStack    ENDS

DATA      SEGMENT
	  var_a     DW 8
	  var_b     DW 5
	  var_i     DW 1
	  var_k     DW 0
	  var_i1     DW 0
	  var_i2     DW 0
	  var_res     DW 0
DATA      ENDS

CODE      SEGMENT

Main      PROC  FAR
          push  DS       
          sub   AX,AX    
          push  AX
          mov AX,DATA
          mov DS,AX       
          
          mov ax, var_i ;ax=i (need for case1 and case2)
          shl ax,1	; ax=2i (need for case1 and case2)
          mov bx,var_a
          cmp bx, var_b
          jg case1 	; jmp if a>b
case2:	  
	  add ax, var_i ; ax=3i
	  mov bx,12	; bx=12
	  sub bx,ax
	  mov var_i2,bx ; i2=12-3i
	  shl ax,1	; ax=6i
	  sub ax, 10 
	  mov var_i1,ax ; i1=6i-10
	  jmp f3    
case1:    
	  shl ax,1	; ax=4i
	  mov bx,ax	; bx=4i
	  add ax,3h	; ax=4i+3
	  neg ax
	  mov var_i1,ax ; i1=-(4i+3)
	  mov ax,var_i
	  shl ax,1	; ax=2i
	  add ax,bx	; ax=6i
	  add ax,8h	; ax=6i+8
	  neg ax	
	  mov var_i2,ax ; i2=-(6i+8)  
f3:	  
	  cmp var_k,0h
	  je abs_sum	; if k==0 then jmp
	  mov ax, var_i1 ; ax=i1
	  cmp ax, var_i2
	  jng set_min_i1 ; if i1<=i2 then jmp
	  mov ax, var_i2
	  jmp set_res  
abs_sum: 
	 mov ax, var_i1 ; ax=i1
	 add ax, var_i2 ; ax=i1+i2
	 cmp ax,0h
	 jl neg_sum
	 jmp set_res	 
neg_sum: 
	 neg ax
	 jmp set_res	 	 
set_min_i1: 
	 mov ax, var_i1
set_res: 
	 mov var_res, ax   
         ret                       
Main      ENDP
CODE      ENDS
          END Main
