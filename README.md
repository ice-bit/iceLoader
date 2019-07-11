# iceLoader

iceLoader is a x86 bootloader written in Assembly(Intel)

## Installation

Be sure to have a [cross compiler](https://wiki.osdev.org/GCC_Cross-Compiler) installed on your computer,NASM and the latest version of QEMu, then type `make all`.

# How does it works
`iceLoader.asm` load a _Global Descriptor Table_, then loads Protected Mode and finally it
calls kernel's main function; at this point the `kernel_main`'s function have full control
over the hardware.  Please, note that the bootsector load the kernel's main function in the stack using an offset of 16384 Byte(16 KiB).  
