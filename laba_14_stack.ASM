use16                 ;Генерировать 16-битный код
org 100h              ;Программа начинается с адреса 100h
    jmp start         ;Переход к метке start

;----------------------------------------------------------------------
; Данные
string  db '$!olleH'
len     db 7           ;Количество символов
;----------------------------------------------------------------------

start:
    movzx cx,[len]     ;Счётчик строк
    xor si, si         ;SI = смещение элемента от начала строк

lp_push:
    mov al, [string+si]
    push ax
    inc si
loop lp_push


    movzx cx,[len]     ;Счётчик строк

lp_pop:
    pop ax
    mov [string+di], al
    inc di
loop lp_pop

    mov ah, 09h
    mov dx, string
    int 21h

    mov ah,01h
    int 21h
    cmp al,0Dh

    mov ax,4C00h      ;\
    int 21h           ;/ Завершение программы