MODEL small
   .STACK 100h

   ;----- Insert INCLUDE "filename" directives here
   ;----- Insert EQU and = equates here

 INCLUDE procs.inc

       LOCALS
       printNewLine  MACRO

        push ax
        mov al,13
        call putchar
        mov al,10
        call putchar
        pop ax

         ENDM
   .DATA


   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

				call clrscr

        xor ax,ax
        xor cx,cx

        base = 2
        numero = 080h


        mov bx,base

        mov cx,1
        mov al,numero
			  call setBit
        call printNumBase
        printNewLine


        mov cx,7
        mov al,numero
			  call clearBit
        call printNumBase
        printNewLine

        bit = 0
        mov cx,bit
        mov al,numero
			  call notBit
        call printNumBase
        printNewLine


        mov cx,7
        mov al,numero
			  call getBit
        call printNumBase
        printNewLine


				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP

; incluir procedimientos
; ejemplo:
; funcionX PROC ; < -- Indica a TASM el inicio del un procedimiento
;               ;
;               ; < --- contenido del procedimiento
;           ret
;           ENDP; < -- Indica a TASM el fin del procedimiento


setBit PROC
    push dx

    mov dl,1
    sal dl,cl
    or al,dl

    pop dx
  ret
ENDP


clearBit PROC
    push dx

    mov dl,0feh
    rol dl,cl
    and al,dl

    pop dx
  ret
ENDP

notBit PROC
    push dx

    mov dl,1
    rol dl,cl
    xor al,dl

    pop dx
  ret
ENDP

getBit PROC
  push cx
  inc cl
  ror al,cl
  jnc @@nohaycarry
  mov al,1
  jmp @@fiiin
  @@nohaycarry: mov al,0
  @@fiiin:
  pop cx
  ret
ENDP

printNumBase PROC
    push ax ;salvar registros
    push cx
    push dx

    xor dx,dx ;dx=0
    contador = 0
    mov cx,contador

doo:
    div bx      ;ax=ax/bx
    add dx,30h  ;dx=ax%bx + 30h
    cmp dx,39h  ;residuo mayor a 9?
    jbe l1      ;no then push
    add dx,7h   ;si, then add 7
l1:   push dx
    inc cx
    xor dx,dx ;dx=0
    cmp ax,0  ;cociente != 0 ?
    jne doo


print:  pop ax
    call putchar
    loop print

    pop dx  ;recuperar registros
    pop cx
    pop ax


    ret
ENDP






         END
