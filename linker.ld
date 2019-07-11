ENTRY(real_mode)
OUTPUT_FORMAT("binary")
SECTIONS {
    . = 0x7c00;
    .text : 
    {
        *(.real_mode)
        *(.text)
    }
    .rodata : 
    {
        *(.rodata)
    }
    .data :
    {
        *(.data)
    }
    .bss :
    {
        *(.bss)
    }
}
