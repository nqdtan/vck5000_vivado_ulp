
################################################################
# This is a generated script based on design: ulp
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2021.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source ulp_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set kernel [lindex $argv 0]

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project -force project_1 myproj_${kernel} -part xcvc1902-vsvd1760-2MP-e-S
   set_property BOARD_PART xilinx.com:vck5000:part0:1.0 [current_project]
}

source setup_ip_repos.tcl

# CHANGE DESIGN NAME HERE
variable design_name
set design_name ulp

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:ai_engine:2.0\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_noc:1.0\
xilinx.com:ip:emb_mem_gen:1.0\
xilinx.com:ip:shell_utils_frequency_counter:1.0\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:ii_level0_wire:1.0\
xilinx.com:RTLKernel:${kernel}:1.0\
xilinx.com:ip:pipeline_reg:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:gt_bridge_ip:1.1\
xilinx.com:ip:gt_quad_base:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: gt_null1
proc create_hier_cell_gt_null1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_gt_null1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 GT_Serial


  # Create pins
  create_bd_pin -dir I -type clk gt_refclk

  # Create instance: gt_bridge_ip, and set properties
  set gt_bridge_ip [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_bridge_ip:1.1 gt_bridge_ip ]
  set_property -dict [ list \
   CONFIG.IP_NO_OF_LANES {1} \
 ] $gt_bridge_ip

  # Create instance: gt_quad_base, and set properties
  set gt_quad_base [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base:1.1 gt_quad_base ]
  set_property -dict [ list \
   CONFIG.PORTS_INFO_DICT {\
     LANE_SEL_DICT {PROT0 {RX0 TX0} unconnected {RX1 RX2 RX3 TX1 TX2 TX3}}\
     GT_TYPE {GTY}\
     REG_CONF_INTF {APB3_INTF}\
     BOARD_PARAMETER {}\
   } \
   CONFIG.PROT0_GT_DIRECTION {DUPLEX} \
   CONFIG.PROT0_NO_OF_LANES {1} \
   CONFIG.PROT0_PRESET {None} \
   CONFIG.PROT0_RX_MASTERCLK_SRC {RX0} \
   CONFIG.PROT0_TX_MASTERCLK_SRC {TX0} \
   CONFIG.PROT_OUTCLK_VALUES {\
CH0_RXOUTCLK 322.266 CH0_TXOUTCLK 322.266 CH1_RXOUTCLK 390.625 CH1_TXOUTCLK\
390.625 CH2_RXOUTCLK 390.625 CH2_TXOUTCLK 390.625 CH3_RXOUTCLK 390.625\
CH3_TXOUTCLK 390.625} \
   CONFIG.REFCLK_STRING {HSCLK0_LCPLLGTREFCLK0 refclk_PROT0_R0_156.25_MHz_unique1} \
 ] $gt_quad_base

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins GT_Serial] [get_bd_intf_pins gt_quad_base/GT_Serial]
  connect_bd_intf_net -intf_net gt_bridge_ip_GT_RX0 [get_bd_intf_pins gt_bridge_ip/GT_RX0] [get_bd_intf_pins gt_quad_base/RX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net gt_bridge_ip_GT_TX0 [get_bd_intf_pins gt_bridge_ip/GT_TX0] [get_bd_intf_pins gt_quad_base/TX0_GT_IP_Interface]

  # Create port connections
  connect_bd_net -net GT_REFCLK0_1_1 [get_bd_pins gt_refclk] [get_bd_pins gt_quad_base/GT_REFCLK0]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins gt_bridge_ip/apb3clk] [get_bd_pins gt_bridge_ip/gt_rxusrclk] [get_bd_pins gt_bridge_ip/gt_txusrclk] [get_bd_pins gt_bridge_ip/gtreset_in] [get_bd_pins gt_quad_base/apb3clk] [get_bd_pins gt_quad_base/ch0_iloreset] [get_bd_pins gt_quad_base/ch0_rxusrclk] [get_bd_pins gt_quad_base/ch0_txusrclk] [get_bd_pins gt_quad_base/hsclk0_lcpllreset] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: gt_null0
proc create_hier_cell_gt_null0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_gt_null0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 GT_Serial


  # Create pins
  create_bd_pin -dir I -type clk gt_refclk

  # Create instance: gt_bridge_ip, and set properties
  set gt_bridge_ip [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_bridge_ip:1.1 gt_bridge_ip ]
  set_property -dict [ list \
   CONFIG.IP_NO_OF_LANES {1} \
 ] $gt_bridge_ip

  # Create instance: gt_quad_base, and set properties
  set gt_quad_base [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base:1.1 gt_quad_base ]
  set_property -dict [ list \
   CONFIG.PORTS_INFO_DICT {\
     LANE_SEL_DICT {PROT0 {RX0 TX0} unconnected {RX1 RX2 RX3 TX1 TX2 TX3}}\
     GT_TYPE {GTY}\
     REG_CONF_INTF {APB3_INTF}\
     BOARD_PARAMETER {}\
   } \
   CONFIG.PROT0_GT_DIRECTION {DUPLEX} \
   CONFIG.PROT0_NO_OF_LANES {1} \
   CONFIG.PROT0_PRESET {None} \
   CONFIG.PROT0_RX_MASTERCLK_SRC {RX0} \
   CONFIG.PROT0_TX_MASTERCLK_SRC {TX0} \
   CONFIG.PROT_OUTCLK_VALUES {\
CH0_RXOUTCLK 322.266 CH0_TXOUTCLK 322.266 CH1_RXOUTCLK 390.625 CH1_TXOUTCLK\
390.625 CH2_RXOUTCLK 390.625 CH2_TXOUTCLK 390.625 CH3_RXOUTCLK 390.625\
CH3_TXOUTCLK 390.625} \
   CONFIG.REFCLK_STRING {HSCLK0_LCPLLGTREFCLK0 refclk_PROT0_R0_156.25_MHz_unique1} \
 ] $gt_quad_base

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins GT_Serial] [get_bd_intf_pins gt_quad_base/GT_Serial]
  connect_bd_intf_net -intf_net gt_bridge_ip_GT_RX0 [get_bd_intf_pins gt_bridge_ip/GT_RX0] [get_bd_intf_pins gt_quad_base/RX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net gt_bridge_ip_GT_TX0 [get_bd_intf_pins gt_bridge_ip/GT_TX0] [get_bd_intf_pins gt_quad_base/TX0_GT_IP_Interface]

  # Create port connections
  connect_bd_net -net GT_REFCLK0_0_1 [get_bd_pins gt_refclk] [get_bd_pins gt_quad_base/GT_REFCLK0]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins gt_bridge_ip/apb3clk] [get_bd_pins gt_bridge_ip/gt_rxusrclk] [get_bd_pins gt_bridge_ip/gt_txusrclk] [get_bd_pins gt_bridge_ip/gtreset_in] [get_bd_pins gt_quad_base/apb3clk] [get_bd_pins gt_quad_base/ch0_iloreset] [get_bd_pins gt_quad_base/ch0_rxusrclk] [get_bd_pins gt_quad_base/ch0_txusrclk] [get_bd_pins gt_quad_base/hsclk0_lcpllreset] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell kernel } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set BLP_M_AXI_DATA_C2H_00 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 BLP_M_AXI_DATA_C2H_00 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {44} \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.FREQ_HZ {249997498} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {16} \
   CONFIG.NUM_WRITE_OUTSTANDING {16} \
   CONFIG.PHASE {0} \
   CONFIG.PROTOCOL {AXI4} \
   ] $BLP_M_AXI_DATA_C2H_00

  set BLP_M_INI_MC_00 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 BLP_M_INI_MC_00 ]
  set_property -dict [ list \
   CONFIG.COMPUTED_STRATEGY {load} \
   CONFIG.INI_STRATEGY {load} \
   ] $BLP_M_INI_MC_00

  set BLP_M_INI_MC_01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 BLP_M_INI_MC_01 ]
  set_property -dict [ list \
   CONFIG.COMPUTED_STRATEGY {load} \
   CONFIG.INI_STRATEGY {load} \
   ] $BLP_M_INI_MC_01

  set BLP_S_AXI_CTRL_MGMT_00 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 BLP_S_AXI_CTRL_MGMT_00 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {25} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {99999001} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {1} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PHASE {0} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $BLP_S_AXI_CTRL_MGMT_00

  set BLP_S_AXI_CTRL_USER_00 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 BLP_S_AXI_CTRL_USER_00 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {25} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {99999001} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {1} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PHASE {0} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $BLP_S_AXI_CTRL_USER_00

  set BLP_S_AXI_DATA_H2C_00 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 BLP_S_AXI_DATA_H2C_00 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {44} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.FREQ_HZ {249997498} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {2} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {16} \
   CONFIG.NUM_READ_THREADS {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {16} \
   CONFIG.NUM_WRITE_THREADS {2} \
   CONFIG.PHASE {0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $BLP_S_AXI_DATA_H2C_00

  set BLP_S_INI_AIE_00 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 BLP_S_INI_AIE_00 ]
  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   ] $BLP_S_INI_AIE_00

  set gt0_refclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt0_refclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {161132812} \
   ] $gt0_refclk

  set gt0_serial [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 gt0_serial ]

  set gt1_refclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt1_refclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {161132812} \
   ] $gt1_refclk

  set gt1_serial [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 gt1_serial ]


  # Create ports
  set blp_m_irq_kernel_00 [ create_bd_port -dir O -from 127 -to 0 -type intr blp_m_irq_kernel_00 ]
  set blp_s_aclk_ctrl_00 [ create_bd_port -dir I -type clk -freq_hz 99999001 blp_s_aclk_ctrl_00 ]
  set_property -dict [ list \
   CONFIG.CLK_DOMAIN {level0_cips_0_pl0_ref_clk} \
   CONFIG.PHASE {0} \
 ] $blp_s_aclk_ctrl_00
  set blp_s_aclk_kernel_00 [ create_bd_port -dir I -type clk -freq_hz 199998000 blp_s_aclk_kernel_00 ]
  set_property -dict [ list \
   CONFIG.CLK_DOMAIN {level0_clkwiz_kernel0_0_clk_out1} \
   CONFIG.PHASE {0} \
 ] $blp_s_aclk_kernel_00
  set blp_s_aclk_kernel_01 [ create_bd_port -dir I -type clk -freq_hz 299996999 blp_s_aclk_kernel_01 ]
  set_property -dict [ list \
   CONFIG.CLK_DOMAIN {level0_clkwiz_kernel1_0_clk_out1} \
   CONFIG.PHASE {0} \
 ] $blp_s_aclk_kernel_01
  set blp_s_aclk_pcie_00 [ create_bd_port -dir I -type clk -freq_hz 249997498 blp_s_aclk_pcie_00 ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {BLP_M_AXI_DATA_C2H_00:BLP_S_AXI_DATA_H2C_00} \
   CONFIG.CLK_DOMAIN {level0_cips_0_pl2_ref_clk} \
   CONFIG.PHASE {0} \
 ] $blp_s_aclk_pcie_00
  set blp_s_aresetn_pcie_reset_00 [ create_bd_port -dir I -from 0 -to 0 -type rst blp_s_aresetn_pcie_reset_00 ]
  set blp_s_aresetn_pr_reset_00 [ create_bd_port -dir I -from 0 -to 0 -type rst blp_s_aresetn_pr_reset_00 ]

  # Create instance: ai_engine_0, and set properties
  set ai_engine_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ai_engine:2.0 ai_engine_0 ]
  set_property -dict [ list \
   CONFIG.AIE_CORE_REF_CTRL_FREQMHZ {1250} \
   CONFIG.NUM_CLKS {1} \
   CONFIG.NUM_MI_AXI {16} \
 ] $ai_engine_0

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M00_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M01_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M02_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M03_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M04_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M05_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M06_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M07_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M08_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M09_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M10_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M11_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M12_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M13_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M14_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M15_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {} \
 ] [get_bd_pins /ai_engine_0/aclk0]

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
 ] $axi_bram_ctrl_0

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]

  # Create instance: axi_noc_0, and set properties
  set axi_noc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {0} \
   CONFIG.NUM_NMI {2} \
   CONFIG.NUM_SI {1} \
 ] $axi_noc_0

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /axi_noc_0/M00_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /axi_noc_0/M01_INI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M00_INI { read_bw {5} write_bw {5}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk0]

  # Create instance: axi_noc_1, and set properties
  set axi_noc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_1 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {18} \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_NSI {1} \
   CONFIG.NUM_SI {17} \
 ] $axi_noc_1

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/M00_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.APERTURES {{0x201_0000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_1/M01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S00_AXI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
 ] [get_bd_intf_pins /axi_noc_1/S00_INI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S02_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S03_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S04_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S05_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S06_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S07_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S08_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S09_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S10_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S11_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S12_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S13_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S14_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x40} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_1/S15_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M00_AXI { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M00_AXI:0x240} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_1/S16_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M01_AXI:S16_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk3]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S02_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk4]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S03_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk5]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S04_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk6]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S05_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk7]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S06_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk8]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S07_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk9]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S08_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk10]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S09_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk11]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S10_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk12]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S11_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk13]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S12_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk14]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S13_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk15]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S14_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk16]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S15_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk17]

  # Create instance: emb_mem_gen_0, and set properties
  set emb_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_mem_gen:1.0 emb_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.MEMORY_TYPE {True_Dual_Port_RAM} \
 ] $emb_mem_gen_0

  # Create instance: freq_counter0, and set properties
  set freq_counter0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:shell_utils_frequency_counter:1.0 freq_counter0 ]
  set_property -dict [ list \
   CONFIG.REF_CLK_FREQ_HZ {100000} \
 ] $freq_counter0

  # Create instance: freq_counter1, and set properties
  set freq_counter1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:shell_utils_frequency_counter:1.0 freq_counter1 ]
  set_property -dict [ list \
   CONFIG.REF_CLK_FREQ_HZ {100000} \
 ] $freq_counter1

  # Create instance: gt0_refclk_buf, and set properties
  set gt0_refclk_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 gt0_refclk_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
 ] $gt0_refclk_buf

  # Create instance: gt1_refclk_buf, and set properties
  set gt1_refclk_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 gt1_refclk_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
 ] $gt1_refclk_buf

  # Create instance: gt_null0
  create_hier_cell_gt_null0 [current_bd_instance .] gt_null0

  # Create instance: gt_null1
  create_hier_cell_gt_null1 [current_bd_instance .] gt_null1

  # Create instance: ii_level0_wire_0, and set properties
  set ii_level0_wire_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ii_level0_wire:1.0 ii_level0_wire_0 ]

  # Create instance: ${kernel}_0, and set properties
  set kernel_0 [ create_bd_cell -type ip -vlnv xilinx.com:RTLKernel:${kernel}:1.0 ${kernel}_0 ]

  # Create instance: pipeline_reg_0, and set properties
  set pipeline_reg_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:pipeline_reg:1.0 pipeline_reg_0 ]

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_1

  # Create instance: smartconnect_2, and set properties
  set smartconnect_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_2 ]

  # Create instance: smartconnect_3, and set properties
  set smartconnect_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_3 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_3

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {128} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $xlconstant_1

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_3

  # Create interface connections
  connect_bd_intf_net -intf_net BLP_S_AXI_CTRL_MGMT_00_0_1 [get_bd_intf_ports BLP_S_AXI_CTRL_MGMT_00] [get_bd_intf_pins ii_level0_wire_0/BLP_S_AXI_CTRL_MGMT_00]
  connect_bd_intf_net -intf_net BLP_S_AXI_CTRL_USER_00_0_1 [get_bd_intf_ports BLP_S_AXI_CTRL_USER_00] [get_bd_intf_pins ii_level0_wire_0/BLP_S_AXI_CTRL_USER_00]
  connect_bd_intf_net -intf_net BLP_S_AXI_DATA_H2C_00_0_1 [get_bd_intf_ports BLP_S_AXI_DATA_H2C_00] [get_bd_intf_pins ii_level0_wire_0/BLP_S_AXI_DATA_H2C_00]
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports gt0_refclk] [get_bd_intf_pins gt0_refclk_buf/CLK_IN_D]
  connect_bd_intf_net -intf_net CLK_IN_D_1_1 [get_bd_intf_ports gt1_refclk] [get_bd_intf_pins gt1_refclk_buf/CLK_IN_D]
  connect_bd_intf_net -intf_net S00_INI_0_1 [get_bd_intf_ports BLP_S_INI_AIE_00] [get_bd_intf_pins axi_noc_1/S00_INI]
  connect_bd_intf_net -intf_net ai_engine_0_M00_AXI [get_bd_intf_pins ai_engine_0/M00_AXI] [get_bd_intf_pins axi_noc_1/S00_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M01_AXI [get_bd_intf_pins ai_engine_0/M01_AXI] [get_bd_intf_pins axi_noc_1/S01_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M02_AXI [get_bd_intf_pins ai_engine_0/M02_AXI] [get_bd_intf_pins axi_noc_1/S02_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M03_AXI [get_bd_intf_pins ai_engine_0/M03_AXI] [get_bd_intf_pins axi_noc_1/S03_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M04_AXI [get_bd_intf_pins ai_engine_0/M04_AXI] [get_bd_intf_pins axi_noc_1/S04_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M05_AXI [get_bd_intf_pins ai_engine_0/M05_AXI] [get_bd_intf_pins axi_noc_1/S05_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M06_AXI [get_bd_intf_pins ai_engine_0/M06_AXI] [get_bd_intf_pins axi_noc_1/S06_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M07_AXI [get_bd_intf_pins ai_engine_0/M07_AXI] [get_bd_intf_pins axi_noc_1/S07_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M08_AXI [get_bd_intf_pins ai_engine_0/M08_AXI] [get_bd_intf_pins axi_noc_1/S08_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M09_AXI [get_bd_intf_pins ai_engine_0/M09_AXI] [get_bd_intf_pins axi_noc_1/S09_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M10_AXI [get_bd_intf_pins ai_engine_0/M10_AXI] [get_bd_intf_pins axi_noc_1/S10_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M11_AXI [get_bd_intf_pins ai_engine_0/M11_AXI] [get_bd_intf_pins axi_noc_1/S11_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M12_AXI [get_bd_intf_pins ai_engine_0/M12_AXI] [get_bd_intf_pins axi_noc_1/S12_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M13_AXI [get_bd_intf_pins ai_engine_0/M13_AXI] [get_bd_intf_pins axi_noc_1/S13_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M14_AXI [get_bd_intf_pins ai_engine_0/M14_AXI] [get_bd_intf_pins axi_noc_1/S14_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M15_AXI [get_bd_intf_pins ai_engine_0/M15_AXI] [get_bd_intf_pins axi_noc_1/S15_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins emb_mem_gen_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB] [get_bd_intf_pins emb_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_noc_0_M00_INI [get_bd_intf_ports BLP_M_INI_MC_00] [get_bd_intf_pins axi_noc_0/M00_INI]
  connect_bd_intf_net -intf_net axi_noc_0_M01_INI [get_bd_intf_ports BLP_M_INI_MC_01] [get_bd_intf_pins axi_noc_0/M01_INI]
  connect_bd_intf_net -intf_net axi_noc_1_M00_AXI [get_bd_intf_pins ai_engine_0/S00_AXI] [get_bd_intf_pins axi_noc_1/M00_AXI]
  connect_bd_intf_net -intf_net axi_noc_1_M01_AXI [get_bd_intf_pins axi_noc_1/M01_AXI] [get_bd_intf_pins smartconnect_2/S01_AXI]
  connect_bd_intf_net -intf_net gt_null0_GT_Serial_0 [get_bd_intf_ports gt0_serial] [get_bd_intf_pins gt_null0/GT_Serial]
  connect_bd_intf_net -intf_net gt_null1_GT_Serial_1 [get_bd_intf_ports gt1_serial] [get_bd_intf_pins gt_null1/GT_Serial]
  connect_bd_intf_net -intf_net ii_level0_wire_0_BLP_M_AXI_DATA_C2H_00 [get_bd_intf_ports BLP_M_AXI_DATA_C2H_00] [get_bd_intf_pins ii_level0_wire_0/BLP_M_AXI_DATA_C2H_00]
  connect_bd_intf_net -intf_net ii_level0_wire_0_ULP_M_AXI_CTRL_MGMT_00 [get_bd_intf_pins ii_level0_wire_0/ULP_M_AXI_CTRL_MGMT_00] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net ii_level0_wire_0_ULP_M_AXI_CTRL_USER_00 [get_bd_intf_pins ii_level0_wire_0/ULP_M_AXI_CTRL_USER_00] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net ${kernel}_0_m_axi_data_int [get_bd_intf_pins ${kernel}_0/m_axi_data_int] [get_bd_intf_pins smartconnect_3/S00_AXI]
  connect_bd_intf_net -intf_net ${kernel}_0_m_axi_data_out [get_bd_intf_pins axi_noc_0/S00_AXI] [get_bd_intf_pins ${kernel}_0/m_axi_data_ext]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins ${kernel}_0/s_axi_control] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins freq_counter0/S_AXI] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M01_AXI [get_bd_intf_pins freq_counter1/S_AXI] [get_bd_intf_pins smartconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M02_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins smartconnect_1/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_2_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins smartconnect_2/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_3_M00_AXI [get_bd_intf_pins smartconnect_2/S00_AXI] [get_bd_intf_pins smartconnect_3/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_3_M01_AXI [get_bd_intf_pins axi_noc_1/S16_AXI] [get_bd_intf_pins smartconnect_3/M01_AXI]

  # Create port connections
  connect_bd_net -net Net [get_bd_ports blp_s_aclk_kernel_00] [get_bd_pins ai_engine_0/aclk0] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_noc_0/aclk0] [get_bd_pins axi_noc_1/aclk1] [get_bd_pins ii_level0_wire_0/blp_s_aclk_kernel_00] [get_bd_pins ${kernel}_0/ap_clk] [get_bd_pins smartconnect_0/aclk1] [get_bd_pins smartconnect_2/aclk] [get_bd_pins smartconnect_3/aclk]
  connect_bd_net -net ai_engine_0_m00_axi_aclk [get_bd_pins ai_engine_0/m00_axi_aclk] [get_bd_pins axi_noc_1/aclk2]
  connect_bd_net -net ai_engine_0_m01_axi_aclk [get_bd_pins ai_engine_0/m01_axi_aclk] [get_bd_pins axi_noc_1/aclk3]
  connect_bd_net -net ai_engine_0_m02_axi_aclk [get_bd_pins ai_engine_0/m02_axi_aclk] [get_bd_pins axi_noc_1/aclk4]
  connect_bd_net -net ai_engine_0_m03_axi_aclk [get_bd_pins ai_engine_0/m03_axi_aclk] [get_bd_pins axi_noc_1/aclk5]
  connect_bd_net -net ai_engine_0_m04_axi_aclk [get_bd_pins ai_engine_0/m04_axi_aclk] [get_bd_pins axi_noc_1/aclk6]
  connect_bd_net -net ai_engine_0_m05_axi_aclk [get_bd_pins ai_engine_0/m05_axi_aclk] [get_bd_pins axi_noc_1/aclk7]
  connect_bd_net -net ai_engine_0_m06_axi_aclk [get_bd_pins ai_engine_0/m06_axi_aclk] [get_bd_pins axi_noc_1/aclk8]
  connect_bd_net -net ai_engine_0_m07_axi_aclk [get_bd_pins ai_engine_0/m07_axi_aclk] [get_bd_pins axi_noc_1/aclk9]
  connect_bd_net -net ai_engine_0_m08_axi_aclk [get_bd_pins ai_engine_0/m08_axi_aclk] [get_bd_pins axi_noc_1/aclk10]
  connect_bd_net -net ai_engine_0_m09_axi_aclk [get_bd_pins ai_engine_0/m09_axi_aclk] [get_bd_pins axi_noc_1/aclk11]
  connect_bd_net -net ai_engine_0_m10_axi_aclk [get_bd_pins ai_engine_0/m10_axi_aclk] [get_bd_pins axi_noc_1/aclk12]
  connect_bd_net -net ai_engine_0_m11_axi_aclk [get_bd_pins ai_engine_0/m11_axi_aclk] [get_bd_pins axi_noc_1/aclk13]
  connect_bd_net -net ai_engine_0_m12_axi_aclk [get_bd_pins ai_engine_0/m12_axi_aclk] [get_bd_pins axi_noc_1/aclk14]
  connect_bd_net -net ai_engine_0_m13_axi_aclk [get_bd_pins ai_engine_0/m13_axi_aclk] [get_bd_pins axi_noc_1/aclk15]
  connect_bd_net -net ai_engine_0_m14_axi_aclk [get_bd_pins ai_engine_0/m14_axi_aclk] [get_bd_pins axi_noc_1/aclk16]
  connect_bd_net -net ai_engine_0_m15_axi_aclk [get_bd_pins ai_engine_0/m15_axi_aclk] [get_bd_pins axi_noc_1/aclk17]
  connect_bd_net -net ai_engine_0_s00_axi_aclk [get_bd_pins ai_engine_0/s00_axi_aclk] [get_bd_pins axi_noc_1/aclk0]
  connect_bd_net -net blp_s_aclk_ctrl_00_0_1 [get_bd_ports blp_s_aclk_ctrl_00] [get_bd_pins ii_level0_wire_0/blp_s_aclk_ctrl_00]
  connect_bd_net -net blp_s_aclk_kernel_01_0_1 [get_bd_ports blp_s_aclk_kernel_01] [get_bd_pins ii_level0_wire_0/blp_s_aclk_kernel_01]
  connect_bd_net -net blp_s_aclk_pcie_00_0_1 [get_bd_ports blp_s_aclk_pcie_00] [get_bd_pins ii_level0_wire_0/blp_s_aclk_pcie_00]
  connect_bd_net -net blp_s_aresetn_pcie_reset_00_0_1 [get_bd_ports blp_s_aresetn_pcie_reset_00] [get_bd_pins ii_level0_wire_0/blp_s_aresetn_pcie_reset_00]
  connect_bd_net -net blp_s_aresetn_pr_reset_00_0_1 [get_bd_ports blp_s_aresetn_pr_reset_00] [get_bd_pins ii_level0_wire_0/blp_s_aresetn_pr_reset_00]
  connect_bd_net -net gt0_refclk_buf_IBUF_OUT [get_bd_pins gt0_refclk_buf/IBUF_OUT] [get_bd_pins gt_null0/gt_refclk]
  connect_bd_net -net gt1_refclk_buf_IBUF_OUT [get_bd_pins gt1_refclk_buf/IBUF_OUT] [get_bd_pins gt_null1/gt_refclk]
  connect_bd_net -net ii_level0_wire_0_blp_m_irq_kernel_00 [get_bd_ports blp_m_irq_kernel_00] [get_bd_pins ii_level0_wire_0/blp_m_irq_kernel_00]
  connect_bd_net -net ii_level0_wire_0_ulp_m_aclk_ctrl_00 [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins freq_counter0/s_axi_aclk] [get_bd_pins freq_counter1/s_axi_aclk] [get_bd_pins ii_level0_wire_0/ulp_m_aclk_ctrl_00] [get_bd_pins pipeline_reg_0/clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk]
  connect_bd_net -net ii_level0_wire_0_ulp_m_aclk_kernel_00 [get_bd_pins freq_counter0/test_clk0] [get_bd_pins ii_level0_wire_0/ulp_m_aclk_kernel_00] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net ii_level0_wire_0_ulp_m_aclk_kernel_01 [get_bd_pins freq_counter1/test_clk0] [get_bd_pins ii_level0_wire_0/ulp_m_aclk_kernel_01]
  connect_bd_net -net ii_level0_wire_0_ulp_m_aresetn_pr_reset_00 [get_bd_pins ii_level0_wire_0/ulp_m_aresetn_pr_reset_00] [get_bd_pins pipeline_reg_0/d] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net pipeline_reg_0_q [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins freq_counter0/s_axi_aresetn] [get_bd_pins freq_counter1/s_axi_aresetn] [get_bd_pins pipeline_reg_0/q] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_1/aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins ${kernel}_0/ap_rst_n] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins smartconnect_2/aresetn] [get_bd_pins smartconnect_3/aresetn]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins ii_level0_wire_0/ulp_s_irq_kernel_00] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins pipeline_reg_0/resetn] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins emb_mem_gen_0/regcea] [get_bd_pins emb_mem_gen_0/regceb] [get_bd_pins xlconstant_3/dout]

  # Create address segments
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M00_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M01_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M02_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M03_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M04_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M05_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M06_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M07_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M08_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M09_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M10_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M11_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M12_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M13_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M14_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ai_engine_0/M15_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x008000000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ii_level0_wire_0/blp_m_axi_data_c2h_00] [get_bd_addr_segs BLP_M_AXI_DATA_C2H_00/Reg] -force
  assign_bd_address -offset 0x00EFF000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ii_level0_wire_0/ulp_m_axi_ctrl_mgmt_00] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x00F00000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ii_level0_wire_0/ulp_m_axi_ctrl_mgmt_00] [get_bd_addr_segs freq_counter0/S_AXI/reg0] -force
  assign_bd_address -offset 0x00F01000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ii_level0_wire_0/ulp_m_axi_ctrl_mgmt_00] [get_bd_addr_segs freq_counter1/S_AXI/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ii_level0_wire_0/ulp_m_axi_ctrl_user_00] [get_bd_addr_segs ${kernel}_0/s_axi_control/reg0] -force
  assign_bd_address -offset 0x00C0000000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces ${kernel}_0/m_axi_data_ext] [get_bd_addr_segs BLP_M_INI_MC_00/Reg] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ${kernel}_0/m_axi_data_int] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces ${kernel}_0/m_axi_data_int] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces BLP_S_INI_AIE_00] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x00000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces BLP_S_AXI_CTRL_MGMT_00] [get_bd_addr_segs ii_level0_wire_0/blp_s_axi_ctrl_mgmt_00/CTRL_MGMT_00] -force
  assign_bd_address -offset 0x00000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces BLP_S_AXI_CTRL_USER_00] [get_bd_addr_segs ii_level0_wire_0/blp_s_axi_ctrl_user_00/CTRL_USER_00] -force
  assign_bd_address -offset 0x020204000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces BLP_S_AXI_DATA_H2C_00] [get_bd_addr_segs ii_level0_wire_0/blp_s_axi_data_h2c_00/UNKNOWN_SEGMENTS_00] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design "" $kernel


