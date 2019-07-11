;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;             iceLoader               ;
; Developed by Marco 'icebit' Cetica  ;
;              (c) 2019               ;
;        Released under GPLv3         ;
;   https://github.com/ice-bit/iceOS  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

gdt_start:
    dq 0x0
gdt_code:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0
gdt_data:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:
gdt_point:
    dw gdt_end - gdt_start
    dd gdt_start

GDT_CODE_SEG equ gdt_code - gdt_start
GDT_DATA_SEG equ gdt_data - gdt_start

