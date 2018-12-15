MODEL small
   .STACK 100h

 INCLUDE procs.inc

      LOCALS
    printSpace MACRO
        push dx
        push ax
        mov ah,02
        mov dl,' '
        int 21h
        pop ax
        pop dx
    ENDM

   .DATA
    str1 db "se espera numero entre 1-255$"

   .CODE


    Principal  	PROC
				mov ax,@data
				mov ds,ax


          call cargaNumero
          cmp al,0
          je aqui
          call numeroTriangulares
          jmp fin
  aqui:   mov dx,offset str1
          mov ah,09
          int 21h


  fin:  mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP


;carga en al el numero(1-255) dado por parametro
;si el numero no es correcto regresa al=0.
cargaNumero PROC
                push es
                push cx
                push bx


                xor cx,cx
                xor ax,ax

                mov ah,62h  ;carga en bx dir de seg.
                int 21h
                mov es,bx
                mov si,80h

                mov cl,es:[si]
                dec cl         ;del blackspace

                cmp cl,1      ;cl>=1 && cl<=3 ?
                jb notNum
                cmp cl,3
                ja notNum

                add si,2
                mov bh,1
                mov bl,10

          wh2:  cmp bh,cl   ;while bh<=cl
                ja ewh2
                add al,es:[si]
                sub al,30h
                cmp bh,cl    ;if bh!=cl then mul
                je next
                mul bl

        next:   inc si
                dec cl
                jmp wh2

          ewh2: jmp isNum
        notNum: mov al,0

        isNum:
                pop bx
                pop cx
                pop es
ret
ENDP



;recibe en al la cantidad de numeros triangulares a imprimir
numeroTriangulares PROC
            push ax
            push bx
            push cx
            push dx

            xor dx,dx
            xor bx,bx ;bx = 0
            mov bl,al  ;bx = ax
            xor ax,ax ;ax = 0
            mov dx,1
            mov cx,2

    wh1:    cmp dx,bx  ;while dx <= bx
            ja Ewh1
            mov ax,dx
            inc ax       ;n+1
            push dx
            mul dx        ;n(n+1)
            xor dx,dx  ;dx=0
            div cx    ;n(n+1) /2
            pop dx
            push bx
            base = 10
            mov bx,base
            call printNumBase
            printSpace
            pop bx
            inc dx
            jmp wh1

    Ewh1:   pop dx
            pop cx
            pop bx
            pop ax

ret
ENDP

;Imprime un numero dado en ax en la base solicitada dada en bx.
;ax = numero
;bx = base
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
  jbe @@l1      ;no then push
  add dx,7h   ;si, then add 7
@@l1:   push dx
  inc cx
  xor dx,dx ;dx=0
  cmp ax,0  ;cociente != 0 ?
  jne doo


print:  pop ax
  mov dx,ax
  mov ah,2  ;imprime caracter
  int 21h
  loop print

  pop dx  ;recuperar registros
  pop cx
  pop ax


  ret
ENDP



         END
