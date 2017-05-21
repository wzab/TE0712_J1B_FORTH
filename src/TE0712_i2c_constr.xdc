#Main clock
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_p]
set_property PACKAGE_PIN H4 [get_ports clk_p]
set_property PACKAGE_PIN G4 [get_ports clk_n]
set_property IOSTANDARD LVCMOS33 [get_ports scl*]
set_property IOSTANDARD LVCMOS33 [get_ports sda*]
#Real SCL and SDA on AFCK
#set_property PACKAGE_PIN K19 [get_ports {scl[4]}]
#set_property PACKAGE_PIN G19 [get_ports {sda[4]}]

#SCL and SDA for GCLK1 FM-S14 in FMC2 of AFCK
#set_property PACKAGE_PIN AD27 [get_ports {scl[3]}]
#set_property PACKAGE_PIN AD28 [get_ports {sda[3]}]

#SCL and SDA for GCLK0 FM-S14 in FMC2 of AFCK
#set_property PACKAGE_PIN AE28 [get_ports {scl[2]}]
#set_property PACKAGE_PIN AF28 [get_ports {sda[2]}]

#SCL and SDA for GCLK1 FM-S14 in FMC1 of AFCK
#set_property PACKAGE_PIN E28 [get_ports {scl[1]}]
#set_property PACKAGE_PIN D28 [get_ports {sda[1]}]

#SCL and SDA for GCLK0 FM-S14 in FMC1 of AFCK
set_property PACKAGE_PIN W21 [get_ports {scl[0]}]
set_property PACKAGE_PIN T20 [get_ports {sda[0]}]


# UART connections

set_property PACKAGE_PIN P16 [get_ports uart_txd]
set_property PACKAGE_PIN U18 [get_ports uart_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]


#set_property PULLUP true [get_ports {sda[4]}]
#set_property PULLUP true [get_ports {sda[3]}]
#set_property PULLUP true [get_ports {sda[2]}]
#set_property PULLUP true [get_ports {sda[1]}]
set_property PULLUP true [get_ports {sda[0]}]
#set_property PULLUP true [get_ports {scl[4]}]
#set_property PULLUP true [get_ports {scl[3]}]
#set_property PULLUP true [get_ports {scl[2]}]
#set_property PULLUP true [get_ports {scl[1]}]
set_property PULLUP true [get_ports {scl[0]}]


set_property PACKAGE_PIN K4 [get_ports clk0_p]
set_property PACKAGE_PIN R4 [get_ports clk1]
set_property PACKAGE_PIN F6 [get_ports clk2_p]

# C8 - MGTREFCLK0P_118   should go to LINK23_CLK
# E8 - MGTREFCLK1P_118 - may go to FMC1_GBTCLK0_M2C
# G8 - MGTREFCLK0P_117 - may go to FMC2_GBTCLK0_M2C
# J8 - MGTREFCLK1P_117 - should go to LINK01_CLK

set_property IOSTANDARD DIFF_SSTL15 [get_ports clk0_p]
set_property IOSTANDARD LVCMOS33 [get_ports clk1]



#set_property PACKAGE_PIN AE16 [get_ports clk_updaten]
#set_property PACKAGE_PIN Y20 [get_ports si570_oe]
#set_property IOSTANDARD LVCMOS18 [get_ports clk_updaten]
#set_property IOSTANDARD LVCMOS25 [get_ports si570_oe]
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]


create_clock -period 5.000 -name clk0_p -waveform {0.000 2.500} [get_ports clk0_p]
create_clock -period 5.000 -name clk1 -waveform {0.000 2.500} [get_ports clk1]
create_clock -period 5.000 -name clk2_p -waveform {0.000 2.500} [get_ports clk2_p]
create_clock -period 20.000 -name clk_p -waveform {0.000 10.000} [get_ports clk_p]
set_input_delay -clock [get_clocks clk_p] -min -add_delay 0.000 [get_ports {scl[0]}]
set_input_delay -clock [get_clocks clk_p] -max -add_delay 6.000 [get_ports {scl[0]}]
set_input_delay -clock [get_clocks clk_p] -min -add_delay 0.000 [get_ports {sda[0]}]
set_input_delay -clock [get_clocks clk_p] -max -add_delay 6.000 [get_ports {sda[0]}]
set_input_delay -clock [get_clocks clk_p] -min -add_delay 0.000 [get_ports uart_txd]
set_input_delay -clock [get_clocks clk_p] -max -add_delay 6.000 [get_ports uart_txd]
set_output_delay -clock [get_clocks clk_p] -min -add_delay 0.000 [get_ports {scl[0]}]
set_output_delay -clock [get_clocks clk_p] -max -add_delay 6.000 [get_ports {scl[0]}]
set_output_delay -clock [get_clocks clk_p] -min -add_delay 0.000 [get_ports {sda[0]}]
set_output_delay -clock [get_clocks clk_p] -max -add_delay 6.000 [get_ports {sda[0]}]
set_output_delay -clock [get_clocks clk_p] -min -add_delay 0.000 [get_ports uart_rxd]
set_output_delay -clock [get_clocks clk_p] -max -add_delay 6.000 [get_ports uart_rxd]


set_clock_groups -asynchronous -group [get_clocks clk_p] -group [get_clocks clk0_p]
set_clock_groups -asynchronous -group [get_clocks clk_p] -group [get_clocks clk1]
set_clock_groups -asynchronous -group [get_clocks clk_p] -group [get_clocks clk2_p]
set_clock_groups -asynchronous -group [get_clocks clk0_p] -group [get_clocks clk_p]
set_clock_groups -asynchronous -group [get_clocks clk1] -group [get_clocks clk_p]
set_clock_groups -asynchronous -group [get_clocks clk2_p] -group [get_clocks clk_p]





create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 1 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list j1_env_1/resetq]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_BUFG]
