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
# of the the Vivado tools to prevent automatic buffer insertion on QSFP GT ports

set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_gtx_p[0]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_gtx_n[0]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_grx_p[0]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_grx_n[0]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_gtx_p[1]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_gtx_n[1]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_grx_p[1]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_grx_n[1]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_gtx_p[2]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_gtx_n[2]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_grx_p[2]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_grx_n[2]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_gtx_p[3]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_gtx_n[3]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_grx_p[3]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_4x_grx_n[3]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_161mhz_clk_p}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp0_161mhz_clk_n}]

set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_gtx_p[0]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_gtx_n[0]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_grx_p[0]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_grx_n[0]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_gtx_p[1]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_gtx_n[1]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_grx_p[1]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_grx_n[1]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_gtx_p[2]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_gtx_n[2]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_grx_p[2]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_grx_n[2]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_gtx_p[3]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_gtx_n[3]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_grx_p[3]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_4x_grx_n[3]}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_161mhz_clk_p}]
set_property IO_BUFFER_TYPE NONE [get_ports {qsfp1_161mhz_clk_n}]

# It is also necessary to re-apply a create_clock constraint to the positive end
# of the differential reference clocks since these pins were loadless at the
# time of initial platform construction, therefore losing original constraints.

create_clock -period 6.206 [get_ports {qsfp0_161mhz_clk_p}]
create_clock -period 6.206 [get_ports {qsfp1_161mhz_clk_p}]
