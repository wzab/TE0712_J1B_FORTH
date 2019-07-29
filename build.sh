#!/bin/bash
set -e
(
  cd original/j1b/verilator
  ./localtest_te0712_gen_prog
)
(
  cd src/j1b
  ./ram_init.py mem_dump.hex
)
vivado -mode batch -source eprj_create.tcl
vivado -mode batch -source eprj_build.tcl

