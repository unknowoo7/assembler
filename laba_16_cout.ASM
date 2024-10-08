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
    mov ah,9                ;������� DOS 09h - ����� ������
    mov dx, string
    int 21h                 ;��������� � ������� DOS
    xchg dx,di              ;����� ���������� DX � DI
    pop ax
    mov ah,01h              ;������� DOS 01h - ���� �������
    int 21h                 ;�������� ������ ���������� � AL
    ret

mov ax, 4C00h
int 21


word_to_udec_str:
    push ax
    push cx
    push dx
    push bx
    xor cx,cx               ;��������� CX
    mov bx,10               ;� BX �������� (10 ��� ���������� �������)

wtuds_lp1:                  ;���� ��������� �������� �� �������
    xor dx,dx               ;��������� ������� ����� �������� �����
    div bx                  ;������� AX=(DX:AX)/BX, ������� � DX
    add dl,'0'              ;�������������� ������� � ��� �������
    push dx                 ;���������� � �����
    inc cx                  ;���������� �������� ��������
    test ax,ax              ;�������� AX
    jnz wtuds_lp1           ;������� � ������ �����, ���� ������� �� 0.
 
wtuds_lp2:                  ;���� ���������� �������� �� �����
    pop dx                  ;�������������� ������� �� �����
    mov [di],dl             ;���������� ������� � ������
    inc di                  ;��������� ������ ������
    loop wtuds_lp2          ;������� �����
 
    pop bx
    pop dx
    pop cx
    pop ax
    ret

;��������� �������������� ����� � ������ � ���������� ���� (�� ������)
; AX - �����
; DI - ����� ��� ������ (6 ��������). �������� �������� �� �����������.
word_to_sdec_str:
    push ax
    test ax,ax              ;�������� ����� AX
    jns wtsds_no_sign       ;���� >= 0, ����������� ��� �����������
    mov byte[di],'-'        ;���������� ����� � ������ ������
    inc di                  ;��������� DI
    neg ax                  ;��������� ����� �������� AX
wtsds_no_sign:
    call word_to_udec_str   ;�������������� ������������ ��������
    pop ax
    ret

;��������� �������������� ����� � ������ � ���������� ���� (�� ������)
; AL - ����.
; DI - ����� ��� ������ (4 �������). �������� �������� �� �����������.
byte_to_sdec_str:
    push ax
    movsx ax,al             ;�������������� ����� � ����� (�� ������)
    call word_to_sdec_str   ;����� ��������� ��� ����� �� ������
    pop ax
    ret