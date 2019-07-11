#include <stdint.h>
#include <stddef.h>

size_t strlen(uint8_t *buf) {
    uint32_t i = 0;
    while(buf[i] != 0)
        i++;
    return i;
}

void kernel_main() {
    const uint16_t color = 0x0F00;
    uint8_t *str = (uint8_t*)"Hello World from Kernel!";
    uint16_t *vga = (uint16_t*)0xb8000;
    for(uint32_t i = 0; i < strlen(str); i++)
        vga[i+80] = color | str[i];
}
