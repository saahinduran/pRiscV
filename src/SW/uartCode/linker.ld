
/* Entry Point */
ENTRY(_start)


/* Memories definition */
MEMORY
{
  FLASH    (xrw)    : ORIGIN = 0x204,   LENGTH = 1024
  RAM 		(rw) 	: ORIGIN = 0x00000000,   LENGTH = 64
}

/* Sections */
SECTIONS
{


  
  .text :
  {
        _start_text = .;
		. = ORIGIN(FLASH);
        KEEP(*(.init))
        
        _start_vector = .;
        KEEP(*(.isr_vector))
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
        _end_text = .;
  } > FLASH
  
  _stored_data = .;

    .data :
    {
        _start_data = .;
        *(.data*)
        _global_pointer = . + 0x10;
        *(.sdata*)
        . = ALIGN(4);
        _end_data = .;
    } > RAM AT> FLASH

    .bss :
    {
        _start_bss = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _end_bss = .;
        _end = .;
    } > RAM


PROVIDE(_start_heap = _end);
PROVIDE(_end_stack  = ORIGIN(RAM) + (LENGTH(RAM)) );

}


