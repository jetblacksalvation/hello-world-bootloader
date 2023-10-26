OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH(i386)

ENTRY(k_main)
SECTIONS {
    . = 10000h;  /* Adjust the starting address as needed */
    .text ALIGN(4K) : { *(.text) }
    .data ALIGN(4K) : { *(.data) }
    .bss  ALIGN(4K) : { *(.bss)  }
}
