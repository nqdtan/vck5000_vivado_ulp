
# Kernel clock overridden by user
# kernel0_freq = (33.33 MHz / _divide_factor) * _multiply_factor
# 500 MHz
create_generated_clock -name clkwiz_aclk_kernel_00_clk_out1 -divide_by 10 -multiply_by 150 -source top_i/blp/blp_logic/ulp_clocking/clkwiz_aclk_kernel_00/inst/clock_primitive_inst/MMCME5_inst/CLKIN1 top_i/blp/blp_logic/ulp_clocking/clkwiz_aclk_kernel_00/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0
# 400 MHz
#create_generated_clock -name clkwiz_aclk_kernel_00_clk_out1 -divide_by 10 -multiply_by 120 -source top_i/blp/blp_logic/ulp_clocking/clkwiz_aclk_kernel_00/inst/clock_primitive_inst/MMCME5_inst/CLKIN1 top_i/blp/blp_logic/ulp_clocking/clkwiz_aclk_kernel_00/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0
# 300 MHz
#create_generated_clock -name clkwiz_aclk_kernel_00_clk_out1 -divide_by 10 -multiply_by 90 -source top_i/blp/blp_logic/ulp_clocking/clkwiz_aclk_kernel_00/inst/clock_primitive_inst/MMCME5_inst/CLKIN1 top_i/blp/blp_logic/ulp_clocking/clkwiz_aclk_kernel_00/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0
# 200 MHz
#create_generated_clock -name clkwiz_aclk_kernel_00_clk_out1 -divide_by 10 -multiply_by 60 -source top_i/blp/blp_logic/ulp_clocking/clkwiz_aclk_kernel_00/inst/clock_primitive_inst/MMCME5_inst/CLKIN1 top_i/blp/blp_logic/ulp_clocking/clkwiz_aclk_kernel_00/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0
