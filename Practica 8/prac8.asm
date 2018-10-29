MODEL small
  .STACK 100h

INCLUDE procs.inc

  LOCALS

  .DATA

  .CODE

  Principal PROC
  mov ax,@data 	;Inicializar DS al la direccion
  mov ds,ax     	; del segmento de datos (.DATA)
  call clrscr

  mov ax,0FFFFh
  mov bx,10
  call printNumBase


  mov ah,04ch	     ; fin de programa
  mov al,0             ;
  int 21h              ;

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

newLine PROC
  push ax

  xor ax,ax
  mov al,13
  call putchar
  mov al,10
  call putchar

  pop ax
  ret
  ENDP

      END
