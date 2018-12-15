dosseg
.model small
.code
    public _myputs

    _myputs PROC
                push bp ;salva registros
                push si
                push dx


                mov bp,sp
                mov si,[bp+8]
                mov dx,si       ;apuntador a inicio de cadena

          aqui: cmp byte ptr[si],0
                je finCad
                inc si
                jmp aqui

    finCad:     mov byte ptr[si],'$';cambiar 0 por $

                mov ah,9   ;servio 9 imprime cad terminada en $
                int 21h

                mov byte ptr[si],0 ;devolver cadena a estado anterior

                pop dx
                pop si
                pop bp
                ret
    _myputs ENDP
    END
