\ Forth procedures for configuration of internal chips on the TE0712 board
\ Written by Wojciech M. Zabolotny
\ ( wzab01<at>gmail.com or wzab<at>ise.pw.edu.pl )
\ It is available as PUBLIC DOMAIN or under Creative Commons CC0 License
\

decimal
\ Frequency counters 
$0100 constant FRQ0_CNT
$0101 constant FRQ1_CNT
$0102 constant FRQ2_CNT

\ Output registers
$0180 constant OUT0_REG
$0181 constant OUT1_REG
$0182 constant OUT2_REG
$0183 constant OUT3_REG

\ Input pins
$0190 constant INP0_REG
$0191 constant INP1_REG
$0192 constant INP2_REG
$0193 constant INP3_REG
$0201 constant I2C_BUS_SEL 


\ Procedures for selecting the bus handled by the J1B I2C controller
\ At the moment there is only one bus, but we are prepared for switching
\ busses
: bus_sel ( n_bus )
    I2C_BUS_SEL io!
;

\ Indexed access (to Si5338)
create I2C_2buf 2 c, 0 c, 0 c, \ Buffer of length 2
: I2C_ind_rd ( reg_nr addr -- val )
    dup ( reg_nr addr addr )
    -rot ( addr reg_nr addr )
    i2c_wr1
    i2c_rd1
;    

: I2C_ind_wr ( reg_nr val addr )
    -rot
    I2C_2buf 1+ ( addr reg_nr val I2C_2buf+1 )
    swap ( addr reg_nr I2C_2buf+1 val )
    over 1+ ( addr reg_nr I2C_2buf+1 val I2C_2buf+2 )
    c! c! ( addr )
    I2C_2buf swap i2c_wr    
;

\ Si5338 routines
$70 constant Si5338

: Si5338_wr ( addr val -- )
    Si5338 I2C_ind_wr
;

: Si5338_rd ( addr -- val )
    Si5338 I2C_ind_rd
;

\ Read the MS values
: Si5338_read_MS ( nr -- )
   dup ." MS" . CR
   11 * 55 + ( base+2 )
   dup Si5338_rd 3 and 256 * ( base+2 val_tmp )
   swap 1- dup Si5338_rd ( val_tmp base+1 val[1] )
   rot + 256 * ( base+1 val_tmp )
   swap 1- dup Si5338_rd ( val base val[0] )
   rot + ( base val_tmp )
   ." P1 " . CR
   5 + ( base+5 )
   dup Si5338_rd 256 * ( base+5 val_tmp )
   swap 1- dup Si5338_rd ( val_tmp base+4 val[2] )
   rot + 256 * ( base+4 val_tmp )
   swap 1- dup Si5338_rd ( val_tmp base+3 val[1] )
   rot + 64 * ( base+3 val_tmp )
   swap 1- dup Si5338_rd 4 / ( val_tmp base+2 val[0] )
   rot + ( base+2 val_tmp )
   ." P2 " . CR
   7 + ( base+9 )
   dup Si5338_rd $3f and 256 * ( base+9 val_tmp )
   swap 1- dup Si5338_rd ( val_tmp base+8 val[2] )
   rot + 256 * ( base+8 val_tmp )
   swap 1- dup Si5338_rd ( val_tmp base+7 val[1] )
   rot + 256 * ( base+7 val_tmp )
   swap 1- dup Si5338_rd ( val_tmp base+6 val[0] )
   rot + ( base+6 val_tmp )
   ." P3 " . CR
   drop
;


