OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH(i386)

ENTRY(k_main)

SECTIONS
{
    . = 0x3000;

    .text : AT(ADDR(.text) - 0x3000)
    {
        *(.text)
    }

    .data : AT(ADDR(.data) - 0x3000)
    {
        *(.data)
        *(.rodata*)
    }

    .bss : AT(ADDR(.bss) - 0x3000)
    {
        _bss = .;
        *(COMMON)
        *(.bss)
        _ebss = .;
    }
}