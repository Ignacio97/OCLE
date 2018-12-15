MODEL small
   .STACK 100h


 INCLUDE procs.inc

       LOCALS

   .DATA
    cad db 30 dup(?)
    no db 13,10,"Mac incorrecta$"
    sii db 13,10,"MAC correcta$"
    ask db 13,10,"Ingrese mac:$"

   .CODE


    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

        mov dx,offset ask
        mov ah,09
        int 21h

        mov dx,offset cad
        call myGets
        call isMaac

        cmp ah,1
        jne noomac
        mov dx,offset sii
        jmp endd
noomac:mov dx,offset no
endd:	  mov ah,09
        int 21h
        mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP



                isMaac PROC
                                  push dx  ;salvar registros
                                  push si
                                  push cx

                                  xor cx,cx
                                  mov si,dx
                                  add dx,2

                                  push si
                  cuenta:         cmp byte ptr[si],0    ;contar longitud
                                  je finCad
                                  inc cx
                                  inc si
                                  jmp cuenta

                   finCad:        pop si
                                  cmp cx,17      ;validar longitud
                                  jne noMac       ;si cad.len != 17 es incorrecto

                                  xor cx,cx ;cx=0

                     checkCad:    cmp byte ptr[si],0
                                  je endCheckCad
                                  inc cx

                                  cmp cx,3
                                  jne checkChar
                                  xor cx,cx ;cx = 0
                                  cmp si,dx
                                  jne contnue
                                  mov al,[si]
                                  cmp al,':'
                                  je next
                                  cmp al,'-'
                                  jne noMac
                                  jmp next
                        contnue:  cmp byte ptr[si],al
                                  jne noMac
                                  jmp next
                      checkChar:  cmp byte ptr[si],'0'
                                  jb noMac
                                  cmp byte ptr[si],'9'
                                  jbe next
                                  cmp byte ptr[si],'A'
                                  jb noMac
                                  cmp byte ptr[si],'F'
                                  jbe next
                                  cmp byte ptr[si],'a'
                                  jb noMac
                                  cmp byte ptr[si],'f'
                                  ja noMac
                      next:       inc si
                                  jmp checkCad
                     endCheckCad:


                isMac:        mov ah,1
                              jmp salida
                noMac:        mov ah,0
                salida:
                              pop cx
                              pop si
                              pop dx

                ret
                ENDP

                ;recibe en dx apuntador a la cadena.
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





         END
