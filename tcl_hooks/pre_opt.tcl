# (c) Copyright 2021-2022, Advanced Micro Devices, Inc.
# 
# Permission is hereby granted, free of charge, to any person obtaining a 
# copy of this software and associated documentation files (the "Software"), 
# to deal in the Software without restriction, including without limitation 
# the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom the 
# Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in 
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
# DEALINGS IN THE SOFTWARE.
############################################################

# Since they are by default unconnected, it is necessary for proper functioning
# of the the Vivado tools to again constrain QSFP GT ports to PACKAGE_PIN objects

set_property PACKAGE_PIN G1  [get_ports {qsfp0_4x_gtx_p[0]}]
set_property PACKAGE_PIN F1  [get_ports {qsfp0_4x_gtx_n[0]}]
set_property PACKAGE_PIN D2  [get_ports {qsfp0_4x_grx_p[0]}]
set_property PACKAGE_PIN C2  [get_ports {qsfp0_4x_grx_n[0]}]
set_property PACKAGE_PIN G3  [get_ports {qsfp0_4x_gtx_p[1]}]
set_property PACKAGE_PIN F3  [get_ports {qsfp0_4x_gtx_n[1]}]
set_property PACKAGE_PIN B3  [get_ports {qsfp0_4x_grx_p[1]}]
set_property PACKAGE_PIN A3  [get_ports {qsfp0_4x_grx_n[1]}]
set_property PACKAGE_PIN G5  [get_ports {qsfp0_4x_gtx_p[2]}]
set_property PACKAGE_PIN F5  [get_ports {qsfp0_4x_gtx_n[2]}]
set_property PACKAGE_PIN D4  [get_ports {qsfp0_4x_grx_p[2]}]
set_property PACKAGE_PIN C4  [get_ports {qsfp0_4x_grx_n[2]}]
set_property PACKAGE_PIN E6  [get_ports {qsfp0_4x_gtx_p[3]}]
set_property PACKAGE_PIN D6  [get_ports {qsfp0_4x_gtx_n[3]}]
set_property PACKAGE_PIN B5  [get_ports {qsfp0_4x_grx_p[3]}]
set_property PACKAGE_PIN A5  [get_ports {qsfp0_4x_grx_n[3]}]
set_property PACKAGE_PIN B15 [get_ports {qsfp0_161mhz_clk_p}]
set_property PACKAGE_PIN A15 [get_ports {qsfp0_161mhz_clk_n}]

set_property PACKAGE_PIN E8  [get_ports {qsfp1_4x_gtx_p[0]}]
set_property PACKAGE_PIN D8  [get_ports {qsfp1_4x_gtx_n[0]}]
set_property PACKAGE_PIN B7  [get_ports {qsfp1_4x_grx_p[0]}]
set_property PACKAGE_PIN A7  [get_ports {qsfp1_4x_grx_n[0]}]
set_property PACKAGE_PIN E10 [get_ports {qsfp1_4x_gtx_p[1]}]
set_property PACKAGE_PIN D10 [get_ports {qsfp1_4x_gtx_n[1]}]
set_property PACKAGE_PIN B9  [get_ports {qsfp1_4x_grx_p[1]}]
set_property PACKAGE_PIN A9  [get_ports {qsfp1_4x_grx_n[1]}]
set_property PACKAGE_PIN E12 [get_ports {qsfp1_4x_gtx_p[2]}]
set_property PACKAGE_PIN D12 [get_ports {qsfp1_4x_gtx_n[2]}]
set_property PACKAGE_PIN B11 [get_ports {qsfp1_4x_grx_p[2]}]
set_property PACKAGE_PIN A11 [get_ports {qsfp1_4x_grx_n[2]}]
set_property PACKAGE_PIN E14 [get_ports {qsfp1_4x_gtx_p[3]}]
set_property PACKAGE_PIN D14 [get_ports {qsfp1_4x_gtx_n[3]}]
set_property PACKAGE_PIN B13 [get_ports {qsfp1_4x_grx_p[3]}]
set_property PACKAGE_PIN A13 [get_ports {qsfp1_4x_grx_n[3]}]
set_property PACKAGE_PIN D18 [get_ports {qsfp1_161mhz_clk_p}]
set_property PACKAGE_PIN C18 [get_ports {qsfp1_161mhz_clk_n}]

# CR-1125650 Disable the SLVERR output from the axi_uartlite in response to a read from an empty FIFO (or write to a full FIFO)

set Gnd_Net [get_nets -of [lindex [get_cells -hierarchical GND -filter {NAME =~ "*top_i/blp/*"}] 0]]

set UART_Resp_Pins [get_pins -of [get_nets -of [get_pins top_i/blp/blp_logic/axi_uart_*/s_axi_?resp]] -filter {DIRECTION ==IN}]

if {[llength ${UART_Resp_Pins}] > 0} {

    set_property DONT_TOUCH FALSE [get_nets -of ${UART_Resp_Pins}]
    disconnect_net -objects ${UART_Resp_Pins}
    connect_net -objects ${UART_Resp_Pins} -hier -net ${Gnd_Net}
}

#set ClkWiz_Resp_Pins [get_pins -of [get_nets -of [get_pins top_i/blp/blp_logic/ulp_clocking/s_axi_clk_wiz_?_?resp]] -filter {DIRECTION ==IN}]
#
#if {[llength ${ClkWiz_Resp_Pins}] > 0} {
#
#    set_property DONT_TOUCH FALSE [get_nets -of ${ClkWiz_Resp_Pins}]
#    disconnect_net -objects ${ClkWiz_Resp_Pins}
#    connect_net -objects ${ClkWiz_Resp_Pins} -hier -net ${Gnd_Net}
#}
