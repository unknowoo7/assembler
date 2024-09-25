use16
org 100h

;Длина строки должна быть больше 8 символов и храниться в байте без знака
;Напишите цикл для шифрования строки по алгоритму:
;первый символ циклически сдвигается -- на N\4 бит влево,
;второй элемент -- на N\4 бита вправо,
;третий элемент -- на N\4+1 бита влево и т.д. до конца массива.
;Выведите полученную строку.
;Затем напишите цикл для расшифровки строки и выведите её на экран.

jmp start

;-- Данные ------------------------------------------------------------

string  db 'matrix99',13,10,'$'
clone   rb 9
len     db 9
savelen dw 0

N       db 1
i       db 0
icl      db 0
icr      db 0
;----------------------------------------------------------------------


start:
        mov AH, 09h
        mov DX, string
        int 21h

main:
        mov CL, [len]
        mov BH, 1
        add BH, [icr]
        mov BL, 1
        add BL, [icl]
        mov DI, 1

lp:
        mov AX, DI
        mov DL, 2
        div DL
        test AH, 11111111b
        mov [savelen], CX

        jz ro_right
        jnz ro_left
   end_loop:
     loop lp

        mov AH, 09h
        mov DX, string
        int 21h

        mov ah,01h
        int 21h
        cmp al,0Dh
        je exit

exit:
       mov AX, 4C00h
       int 21h

ro_left:
        mov DL, [string+DI]
        mov CL, [icl]
        add CL, BL
        rol DL, CL
        inc BL
        mov [icl], BL
        jmp step

ro_right:
        mov DL, [string+DI]
        mov CL, [icr]
        add CL, BH
        ror DL, CL
        inc BH
        mov [icr], BH
        jmp step

step:
        mov [string+DI], DL
        ;add SI, 2
        inc DI
        mov CX, [savelen]
        jmp end_loop











