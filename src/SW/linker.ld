
/* Entry Point */
ENTRY(_start)


/* Memories definition */
MEMORY
{
  FLASH    (xrw)    : ORIGIN = 0x00000004,   LENGTH = 1024
  RAM 		(rw) 	: ORIGIN = 0x00000000,   LENGTH = 32
}

/* Sections */
SECTIONS
{


  
  .text :
  {
	*(*.text)
  } >FLASH AT>FLASH



}
