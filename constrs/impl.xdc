# (c) Copyright 2022, Advanced Micro Devices, Inc.
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

# Floorplanning
# ------------------------------------------------------------------------------

# Dynamic region SLR0 pblock
set pblock_dynamic_SLR0 [create_pblock pblock_dynamic_SLR0]

resize_pblock ${pblock_dynamic_SLR0} -add {SLICE_X20Y140:SLICE_X359Y327 SLICE_X0Y265:SLICE_X19Y327 SLICE_X40Y0:SLICE_X359Y139 DSP58_CPLX_X0Y0:DSP58_CPLX_X5Y163 DSP_X0Y0:DSP_X11Y163}
resize_pblock ${pblock_dynamic_SLR0} -add {RAMB18_X0Y72:RAMB18_X11Y167 RAMB18_X1Y0:RAMB18_X11Y71 RAMB36_X0Y36:RAMB36_X11Y83 RAMB36_X1Y0:RAMB36_X11Y35 URAM288_X0Y36:URAM288_X5Y83 URAM288_X1Y0:URAM288_X5Y35}
resize_pblock ${pblock_dynamic_SLR0} -add {NOC_NMU512_X0Y0:NOC_NMU512_X0Y4 NOC_NSU512_X0Y0:NOC_NSU512_X0Y1 NOC_NMU512_X1Y0:NOC_NMU512_X3Y6 NOC_NSU512_X1Y0:NOC_NSU512_X3Y6  NOC_NMU128_X1Y10:NOC_NMU128_X16Y10 NOC_NSU128_X1Y6:NOC_NSU128_X16Y6}
resize_pblock ${pblock_dynamic_SLR0} -add {AIE_ARRAYSWITCH_X0Y0:AIE_ARRAYSWITCH_X49Y7 AIE_CORE_X0Y0:AIE_CORE_X49Y7 AIE_FIFO_X0Y0:AIE_FIFO_X99Y8 AIE_MEMGRP_X0Y0:AIE_MEMGRP_X49Y7 AIE_NOC_X0Y0:AIE_NOC_X23Y0 AIE_PL_X0Y0:AIE_PL_X48Y0 AIE_PLL_X0Y0:AIE_PLL_X0Y0 AIE_SHIMSWITCH_X0Y0:AIE_SHIMSWITCH_X49Y0 AIE_SHIMTRACE_X0Y0:AIE_SHIMTRACE_X49Y0 AIE_TILECTRL_X0Y0:AIE_TILECTRL_X49Y8}
resize_pblock ${pblock_dynamic_SLR0} -add {BUFG_GT_X1Y24:BUFG_GT_X1Y71 BUFG_GT_SYNC_X1Y41:BUFG_GT_SYNC_X1Y122 GCLK_TAPS_DECODE_GT_X1Y1:GCLK_TAPS_DECODE_GT_X1Y2 GTY_QUAD_X1Y2:GTY_QUAD_X1Y5 GTY_REFCLK_X1Y4:GTY_REFCLK_X1Y11}
resize_pblock ${pblock_dynamic_SLR0} -add {BUFGCE_X4Y0:BUFGCE_X11Y23 BUFGCE_DIV_X4Y0:BUFGCE_DIV_X11Y3 BUFGCTRL_X4Y0:BUFGCTRL_X11Y7 MMCM_X4Y0:MMCM_X11Y0}
resize_pblock ${pblock_dynamic_SLR0} -add {MRMAC_X0Y0:MRMAC_X0Y3}

set_property SNAPPING_MODE ON [get_pblocks pblock_dynamic_SLR0]
set_property PARENT [get_pblocks pblock_dynamic_region] [get_pblocks pblock_dynamic_SLR0]


# Timing
# ------------------------------------------------------------------------------

# JUSTIFICIATION:  Kernel interrupts are level triggered but may be driven by a flop on an arbitrary clock source within the kernel.
# The set_false_path suppresses false timing failures that would otherwise be reported.
set_false_path -to [get_pins {top_i/blp/dfx_decoupling/ip_irq_kernel_00/inst/FDRE.FDRElp[*].FDRE_inst/D}]
