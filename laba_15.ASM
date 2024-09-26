use16                   ;Генерировать 16-битный код
org 100h                ;Программа начинается с адреса 100h
    jmp start           ;Переход на метку start

;---------------DATA-------------------------------------------------------
arr_1           dw 2 dup(260, 270, 230)
arr_2           dw 2 dup(360, 340)

len_1           db 6
len_2           db 4

svg_arr_1       dw ?
svg_arr_2       dw ?
;----------------------------------------------------------------------

start:
      mov bx, arr_1
      movzx cx, [len_1]
      call calc_svg
      mov [svg_arr_1], ax

      mov bx, arr_2
      movzx cx, [len_2]
      call calc_svg
      mov [svg_arr_2], ax

mov ax,4C00h      ;\
int 21h           ;/ Завершение программы

calc_svg:
     xor si, si
     xor ax, ax
     push cx
     calc_lp:
        add ax, [bx+si]
        add si, 2
     loop calc_lp
     pop cx
     div cl
     ret






