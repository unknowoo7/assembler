                                                              ; laba 12 (??????)
use16
org 100h
;Сдвиньте первый элемент на 2 бит влево,
;второй элемент -- на 2 бита вправо (логическим сдвигом),
;третий элемент -- на 2+1 бита влево и т.д. до конца массива. Используйте циклы.
;N - вариант задания,
;N\2 - целочисленное деление на 2.

jmp start

;-- Данные ------------------------------------------------------------
        arr     dw 9 dup(300)
        len     db 9
        savelen dw 0

        sdv_r_count db 2
        sdv_l_count db 2
;----------------------------------------------------------------------

start:
        mov CL, [len]
        mov SI, 0
        mov DI, 1
        mov BH, [sdv_r_count]
        mov BL, [sdv_l_count]

for:
        mov AX, DI
        mov DL, 2
        div DL
        test AH, 11111111b
        mov [savelen], CX
        jz sdv_right
        jnz sdv_left
      end_loop:
        loop for

exit:
        mov AX, 4C00h
        int 21h

sdv_left:
        mov DX, [arr+SI]
        mov CL, [sdv_l_count]
        shl DX, CL
        inc BL
        mov [sdv_l_count], BL
        jmp step

sdv_right:
        mov DX, [arr+SI]
        mov CL, [sdv_r_count]
        shr DX, CL
        inc BH
        mov [sdv_r_count], BH
        jmp step

step:
        mov [arr+SI], DX
        add SI, 2
        inc DI
        mov CX, [savelen]
        jmp end_loop