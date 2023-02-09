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

# Revert GPIO Null Address space back to 4k to allow other kernels to be allocated in address window
# This is a workaround for CR-1112158
set_property range 4K [get_bd_addr_segs {BLP_S_AXI_CTRL_USER_00/SEG_axi_gpio_null_user_Reg}]

# Re-apply all APERTURES in v++ context
# This is a possible partial workaround for CR-1109906
set_property APERTURES {{0x0C1_0000_0000 12G}} [get_bd_intf_ports BLP_M_M00_INI_0]
set_property APERTURES {{0x0C1_0000_0000 12G}} [get_bd_intf_ports BLP_M_M01_INI_0]
set_property APERTURES {{0x0C1_0000_0000 12G}} [get_bd_intf_ports BLP_M_M02_INI_0]
