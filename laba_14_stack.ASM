use16                 ;������������ 16-������ ���
org 100h              ;��������� ���������� � ������ 100h
    jmp start         ;������� � ����� start

;----------------------------------------------------------------------
; ������
string  db '$!olleH'
len     db 7           ;���������� ��������
;----------------------------------------------------------------------

start:
    movzx cx,[len]     ;������� �����
    xor si, si         ;SI = �������� �������� �� ������ �����

lp_push:
    mov al, [string+si]
    push ax
    inc si
loop lp_push


    movzx cx,[len]     ;������� �����

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
    int 21h           ;/ ���������� ���������