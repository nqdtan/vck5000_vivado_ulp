
# Kernel clock overridden by user
# kernel0_freq = (33.33 MHz / _divide_factor) * _multiply_factor
# 500 MHz
create_generated_clock -name clkout1_primitive -divide_by 10 -multiply_by 151 -source level0_i/blp/blp_logic/base_clocking/clkwiz_kernel0/inst/clock_primitive_inst/MMCME5_inst/CLKIN1 level0_i/blp/blp_logic/base_clocking/clkwiz_kernel0/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0
# 400 MHz
#create_generated_clock -name clkout1_primitive -divide_by 10 -multiply_by 120 -source level0_i/blp/blp_logic/base_clocking/clkwiz_kernel0/inst/clock_primitive_inst/MMCME5_inst/CLKIN1 level0_i/blp/blp_logic/base_clocking/clkwiz_kernel0/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0
# 300 MHz
#create_generated_clock -name clkout1_primitive -divide_by 10 -multiply_by 90 -source level0_i/blp/blp_logic/base_clocking/clkwiz_kernel0/inst/clock_primitive_inst/MMCME5_inst/CLKIN1 level0_i/blp/blp_logic/base_clocking/clkwiz_kernel0/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0
# 200 MHz
#create_generated_clock -name clkout1_primitive -divide_by 10 -multiply_by 60 -source level0_i/blp/blp_logic/base_clocking/clkwiz_kernel0/inst/clock_primitive_inst/MMCME5_inst/CLKIN1 level0_i/blp/blp_logic/base_clocking/clkwiz_kernel0/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0
