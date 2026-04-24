set_property -dict {PACKAGE_PIN G7 IOSTANDARD LVCMOS33 } [get_ports {clk}];
create_clock -period 8.000 -name pll_clk1 [get_nets clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN G7 [get_ports clk]

set_property IOSTANDARD LVCMOS33 [get_ports sys_rst]
set_property PACKAGE_PIN E12 [get_ports sys_rst]

set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property PACKAGE_PIN E14  [get_ports rx]

set_property IOSTANDARD LVCMOS33 [get_ports tx]
set_property PACKAGE_PIN E13  [get_ports tx]





