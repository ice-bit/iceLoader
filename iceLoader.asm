;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;             iceLoader               ;
; Developed by Marco 'icebit' Cetica  ;
;              (c) 2019               ;
;        Released under GPLv3         ;
;   https://github.com/ice-bit/iceOS  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Real Mode ;;
section .real_mode
[bits 16] ; BIOS loaded 16 bits mode for us
global real_mode ; to be called by the linker
real_mode:
    ;; Enable A20 line ;;
    mov ax, 0x2401 ; this allow us to use more than 1 MB of RAM
    int 0x15 ; BIOS routine to do that
    ;; Setup VGA text mode ;;
    mov ax, 0x3 ; Set VGA mode 3(80x25 16 color text)
    int 0x10 ; Apply above by calling BIOS interrupt
    ;; Load an offset greater than 512 bytes ;;
    mov [disk], dl
    mov ah, 0x2 ; Read sector
    mov al, 1 ; Sector to read from
    mov ch, 0 ; Cylinder idx
    mov dh, 0 ; Head idx
    mov cl, 2 ; Sector idx
    mov dl, [disk] ; Disk idx
    mov bx, target ; pointer to the target
    int 0x13 ; Read sectors(AH) from target location(DX)
    ;; Load GDT ;;
    cli ; Disable interrupts
    lgdt [gdt_point] ; Load GDT
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    mov ax, GDT_DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    jmp GDT_CODE_SEG:protected_mode ; Long jump to 32 bit mode

;; Label declarations ;;
%include "gdt.asm"
disk: db 0x0

;; Fill bytes and magic number
times 510 - ($-$$) db 0 ; Fill remaining space with zeros
dw 0xaa55 ; Magic number

;; Protected Mode ;;
target:
[bits 32] ; Tell compiler that we're in PM

pm_msg: db "[BOOTLOADER] - Loaded Protected Mode", 0

protected_mode:
    mov esi, pm_msg
    mov ebx, 0xb8000 ; Load VGA memory(framebuffer)
.print_msg:
    lodsb ; Load byte from ds:si to al
    or al, al ; is al == 0
    jz halt ; if yes stop to print
    or eax, 0x0E00 ; otherwise set color(Light blue)
    mov word [ebx], ax ; Print character
    add ebx, 2
    jmp .print_msg ; goto next character
halt:
    mov esp, kernel_stack_top ; Load call to kernel's main into the stack(16KB)
    extern kernel_main
    call kernel_main ; Call C function
    cli ; Disable interrupts
    hlt ; Halt the CPU

section .bss
align 4
kernel_stack_bottom: equ $
    resb 16384 ; Reserve 16 KiB for kernel call function
kernel_stack_top:
