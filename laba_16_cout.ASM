use16
org 100h

    jmp start


;----------------------DATA--------------------------------------------
arr     dw -90,-88,-120
string  db 14

len     db 3
;----------------------------------------------------------------------

start:
    mov di, string
    mov cl, [len]
    xor si, si
lp:
    mov ax, [arr+si]
    call byte_to_sdec_str
    mov byte[di], ','
    inc di
    add si, 2
   loop lp
    ;inc di
    mov byte[di], '$'
    jmp print_str


print_str:
    push ax
    mov ah,9                ;Функция DOS 09h - вывод строки
    mov dx, string
    int 21h                 ;Обращение к функции DOS
    xchg dx,di              ;Обмен значениями DX и DI
    pop ax
    mov ah,01h              ;Функция DOS 01h - ввод символа
    int 21h                 ;Введённый символ помещается в AL
    ret

mov ax, 4C00h
int 21


word_to_udec_str:
    push ax
    push cx
    push dx
    push bx
    xor cx,cx               ;Обнуление CX
    mov bx,10               ;В BX делитель (10 для десятичной системы)

wtuds_lp1:                  ;Цикл получения остатков от деления
    xor dx,dx               ;Обнуление старшей части двойного слова
    div bx                  ;Деление AX=(DX:AX)/BX, остаток в DX
    add dl,'0'              ;Преобразование остатка в код символа
    push dx                 ;Сохранение в стеке
    inc cx                  ;Увеличение счетчика символов
    test ax,ax              ;Проверка AX
    jnz wtuds_lp1           ;Переход к началу цикла, если частное не 0.
 
wtuds_lp2:                  ;Цикл извлечения символов из стека
    pop dx                  ;Восстановление символа из стека
    mov [di],dl             ;Сохранение символа в буфере
    inc di                  ;Инкремент адреса буфера
    loop wtuds_lp2          ;Команда цикла
 
    pop bx
    pop dx
    pop cx
    pop ax
    ret

;Процедура преобразования слова в строку в десятичном виде (со знаком)
; AX - слово
; DI - буфер для строки (6 символов). Значение регистра не сохраняется.
word_to_sdec_str:
    push ax
    test ax,ax              ;Проверка знака AX
    jns wtsds_no_sign       ;Если >= 0, преобразуем как беззнаковое
    mov byte[di],'-'        ;Добавление знака в начало строки
    inc di                  ;Инкремент DI
    neg ax                  ;Изменение знака значения AX
wtsds_no_sign:
    call word_to_udec_str   ;Преобразование беззнакового значения
    pop ax
    ret

;Процедура преобразования байту в строку в десятичном виде (со знаком)
; AL - байт.
; DI - буфер для строки (4 символа). Значение регистра не сохраняется.
byte_to_sdec_str:
    push ax
    movsx ax,al             ;Преобразование байту в слово (со знаком)
    call word_to_sdec_str   ;Вызов процедуры для слова со знаком
    pop ax
    ret