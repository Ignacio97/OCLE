MODEL small
   .STACK 100h

 INCLUDE procs.inc

       LOCALS

   .DATA

   cad db  30 dup(?)
   msg1 db 'Ingrese un numero:$'

   .CODE


    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax

        mov dx,offset msg1
        mov ah,09
        int 21h

        mov bx,dx
        call myGets

        call atoi
        call fibonacci

        base = 10
        mov bx,base
        call printNumBase

				mov ah,04ch	     ; fin de programa
				mov al,0
				int 21h

                ENDP



  fibonacci PROC
        cmp ax,2
        jb rtax

        push ax
        dec ax

        call fibonacci

        pop bx
        sub bx,2
        push ax
        mov ax,bx

        call fibonacci

        pop bx
        add ax,bx

    rtax:    ret
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
                  call putchar
                  loop print

                  pop dx  ;recuperar registros
                  pop cx
                  pop ax


                  ret
                ENDP

                ;recibe en bx apuntador a la cadena.
                myGets PROC
                    push ax
                    push bx

                    mov bx,dx

                    @@again:  call getchar
                              cmp al,13
                              je @@rtKey    ;si es 13(enter)

                              cmp al,8  ; al == BS ?
                              jne l1     ;no, then almacenalo
                              cmp bx,dx   ;si then hay algo almacenado ya?
                              jne l2   ;si hay algo

                              push ax ;no hay algo
                              mov al,00 ;14 = desplazamiento derecha
                              call putchar
                              pop ax

                              jmp @@again  ;no, then pìde otro caracter

                            l2:
                              push ax       ;si, then borra el caracter anterior.
                              char = 32     ;WS ascii
                              mov ax,char
                              call putchar
                              char = 8      ;BS ascii
                              mov ax,char
                              call putchar
                              dec bx        ;decrementa indice
                              pop ax

                              jmp @@again   ;empieza de nuevo


                        l1:   mov [bx],al
                              inc bx
                              jmp @@again
                @@rtKey:
                              mov byte ptr[bx],0

                              pop bx
                              pop ax
                ret
                ENDP

                ;Recibe en bx, apuntador a la cadena
                ;regresa en ax la representacion decimal de la cadena
                atoi PROC
                    push bx
                    push cx
                    push dx

                    xor ax,ax       ;poner registros en 0.
                    xor cx,cx
                    xor dx,dx

                      base=10
                      mov cx,base

                wh:   cmp byte ptr[bx],0  ;cadena vacia?
                      je fin              ;si then fin.

                      mov dl,[bx]           ;no then trae caracter de cad[bx]
                      sub dl,'0'            ;convertir a decimal

                      add ax,dx             ;sumarlo a ax


                      cmp byte ptr[bx+1],0  ;cad[bx+1]  = 0 ?
                      je fin                ;si then termina proc
                                            ;no then multiplica ax por 10
                      mul cx
                      inc bx                ;incrementa indice


                      jmp wh                 ;repite proceso

                fin:    pop dx      ;recupera registros.
                      pop cx
                      pop bx

                ret               ;termina proc
                ENDP


END
