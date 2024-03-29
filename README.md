# TE0712_J1B_FORTH - Forth based system for TE0712 board initialization and diagnostics
This repository contains HDL and forth sources for the Forth based system for TE0712 board ( https://shop.trenz-electronic.de/en/Products/Trenz-Electronic/TE07XX-Artix-7/TE0712-Artix-7/ ) initialization and diagnostics. 
The significant part of this project is "swapforth" and J1B Forth CPU developed by James Bowman (https://github.com/jamesbowman/swapforth)

I have ported J1B to VHDL (in https://github.com/wzab/swapforth ) and added the functionality to dump the program/data memory
after compilation of additional commands (words).

The project uses also the I2C controller available from OpenCores ( http://opencores.org/project,i2c ).

The project defines the small Forth CPU with program/data memory and some basic peripherials (UART for communication with 
the operator, I2C controller connected via very simplified Wishbone controller, 4 output and 4 input ports for communication
with the surrounding logic). The controller may be easily reused in other projects and extented. It should be trivial
to adapt it for other I2C or SPI configurable FPGA based boards.
It can be used to interactively control the TE0712 board but also to define own procedures (words) performing complex configuration or diagnostic procedures.

# Basic usage examples


# Quick start

After you clone the repository, you can build the firmware by running the build.sh script in the main directory.
The project uses the VEXTPROJ environment ( https://github.com/wzab/vextproj ) to create the Vivado project and
to build it (of course Vivado must be installed and available in path ).

After successful compilation, you can upload the bistream to the FPGA and connect to it.
If the USB/UART converter connected to the FPGA UART port in the AFCK board is visible as /dev/ttyUSB0, you
can simply start the localtest_afck script in the forth directory.

The firmware compiled from the cloned repository contains already the swapforth words, so the script loads
only files defining additional words related to the configuration of the AFCK board.

You can use defined words, and create new ones. If something goes wrong, you can reconfigure FPGA to start from the begining.

If you want the FPGA to have all AFCK related words and your own words defined immediately after configuration, read the next section.

# Modifying the initial contents of the memory

The initial contents of the memory is defined by the _src/j1b/prog.vhd_ file. It is created by the _src/j1b/ram\_init.py_ script.
The downloaded version of the script is created from the _src/j1b/nuc\_swapforth.hex_ file. But of course you can use another one.

## How to create the hex file with new words?

The standard nuc.hex file is created by the crossassembler run by gforth. Unfortunately the source files for that crossassembler differ from the files that can by loaded by the sscript like localtest_afck (e.g. they must heve defined 
special headers for each word.)
Therefore I have used another approach. James Bowman has provided his J1B with a wonderful Verilator based testbench.
It runs many times faster then simulation of my VHDL port in ghdl.
This testbench may be used to load the definitions of the new words. *( In fact I often use this testbench to quickly
develop new words without using the real AFCK. It works as long as you do not use the specific hardware )* .
In the original/j1b/verilator directory I have created the _localtest2_ and _localtest3_ files that load the _swapforth_ itself or _swapforth_ and AFCK related words. 
They can be a good starting point for development of own words. You can put your words to the existing files or to the new one
(and add it to the appropriate script).

After your desired words are written and tested, you may want to create the hex file with their definitions. It can be done using the _localtest\_afck\_gen\_prog_ script. This script uses the feature that I have added to the James testbench - after reading from the io port 0x2345, the testbench dumps the memory contents to the mem_dump.hex file. This file is also available via a symlink from the _src/j1b_ directory, so you can easily use it to create the new _prog.vhd_ file for synthesis.

## How to make my procedure to be executed immediately after the FPGA is configured

You can make your procedure to be executed right after FPGA is configured or J1B exits the reset state. To achieve that,
you should simply define your procedure as the "cold" word.
When the execution of your procedure is finished, swapforth enters normal interactive mode, so it is possible to provide
both - initial configuration of the board and interactive debugging.

Below is an example of the startup procedure:

    : cold
      i2c_init
    ;   

If the OUT2 port is not set to $a500, after reasonable time it means that the "cold" word has failed. The value of the status allows to find which procedure has failed.

## Possible modifications

You may want to modify behavior of the swapforth. This may require changing the original files. For example you may
want to use other communication channel. As long as you can imitate the original ( UART data in IO port 0x1000, and UART status in IO port 0x2000 with TX empty at bit 0 and RX full at bit 1) no changes are needed. Otherwise, you may need to modify
the original files e.g. _original/j1b/nuc.fs (UART addresses are defined at the begining of that file), you may even reimplement "key", "key?" and "emit" words. Of course after that, you should rebuild the swapforth and recreate your memory images.

Another thing, that you may want to modify is the "throw" word. E.g. you may want to transfer the value passed to the _throw_ word to one of _out_ ports.

# Known problems

Sometimes the I2C bus is in the "strange state" and after selection of the new bus it is impossible to communicate with I2C slaves. The problem usually disappears after a few attempts to read different slaves connected to different buses.
This is however a real problem in case of the _cold_ word, which may get interrupted due to the I2C problem.
We need a robust procedure for I2C buses initialization...
