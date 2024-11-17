create_clock -period 20 -name clk_i [get_ports sys_clk]

set_property PACKAGE_PIN N18 [get_ports sys_clk]
set_property PACKAGE_PIN J16 [get_ports {led_out[1]}]
set_property PACKAGE_PIN K16 [get_ports {led_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports {led_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_out[0]}]

set_property PACKAGE_PIN G19 [get_ports sys_rst_n]

set_property PACKAGE_PIN K14 [get_ports {led_out[2]}]
set_property PACKAGE_PIN J14 [get_ports {led_out[3]}]
