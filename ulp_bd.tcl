
################################################################
# This is a generated script based on design: ulp_inst_0
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
set scripts_vivado_version 2022.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

#set_param board.repoPaths /tools/C/tan.nqd/vck5000_board_files

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source ulp_inst_0_script.tcl

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
set design_name ulp_inst_0

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

   create_bd_design -bdsource Vitis $design_name

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
xilinx.com:ip:axi_firewall:1.2\
xilinx.com:ip:axi_dbg_hub:2.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:axi_noc:1.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:util_ff:1.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:emb_mem_gen:1.0\
xilinx.com:RTLKernel:vecadd:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
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


# Hierarchical cell: reset_controllers
proc create_hier_cell_reset_controllers { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_reset_controllers() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -type clk clk_kernel0
  create_bd_pin -dir I -type clk clk_kernel1
  create_bd_pin -dir I -type clk clk_pcie
  create_bd_pin -dir I -type clk clk_pl_axi
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst resetn_kernel0_ic
  create_bd_pin -dir O -from 0 -to 0 -type rst resetn_kernel1_ic
  create_bd_pin -dir I -type rst resetn_pcie
  create_bd_pin -dir O -from 0 -to 0 -type rst resetn_pcie_axi
  create_bd_pin -dir O -from 0 -to 0 -type rst resetn_pl_axi
  create_bd_pin -dir I -type rst resetn_ulp

  # Create instance: pipereg_kernel0, and set properties
  set pipereg_kernel0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ff:1.0 pipereg_kernel0 ]

  # Create instance: pipereg_kernel1, and set properties
  set pipereg_kernel1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ff:1.0 pipereg_kernel1 ]

  # Create instance: pipereg_pcie0, and set properties
  set pipereg_pcie0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ff:1.0 pipereg_pcie0 ]

  # Create instance: pipereg_pl_axi0, and set properties
  set pipereg_pl_axi0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ff:1.0 pipereg_pl_axi0 ]

  # Create instance: reset_sync_fixed, and set properties
  set reset_sync_fixed [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_sync_fixed ]
  set_property -dict [list \
    CONFIG.C_AUX_RESET_HIGH {0} \
    CONFIG.C_AUX_RST_WIDTH {1} \
    CONFIG.C_EXT_RST_WIDTH {1} \
  ] $reset_sync_fixed


  # Create instance: reset_sync_kernel0, and set properties
  set reset_sync_kernel0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_sync_kernel0 ]
  set_property -dict [list \
    CONFIG.C_AUX_RESET_HIGH {0} \
    CONFIG.C_AUX_RST_WIDTH {1} \
    CONFIG.C_EXT_RST_WIDTH {1} \
  ] $reset_sync_kernel0


  # Create instance: reset_sync_kernel1, and set properties
  set reset_sync_kernel1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_sync_kernel1 ]
  set_property -dict [list \
    CONFIG.C_AUX_RESET_HIGH {0} \
    CONFIG.C_AUX_RST_WIDTH {1} \
    CONFIG.C_EXT_RST_WIDTH {1} \
  ] $reset_sync_kernel1


  # Create instance: rstn_const, and set properties
  set rstn_const [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 rstn_const ]
  set_property -dict [list \
    CONFIG.CONST_VAL {1} \
    CONFIG.CONST_WIDTH {1} \
  ] $rstn_const


  # Create port connections
  connect_bd_net -net clk_kernel0_1 [get_bd_pins clk_kernel0] [get_bd_pins pipereg_kernel0/clk] [get_bd_pins reset_sync_kernel0/slowest_sync_clk]
  connect_bd_net -net clk_kernel1_1 [get_bd_pins clk_kernel1] [get_bd_pins pipereg_kernel1/clk] [get_bd_pins reset_sync_kernel1/slowest_sync_clk]
  connect_bd_net -net clk_pcie_1 [get_bd_pins clk_pcie] [get_bd_pins pipereg_pcie0/clk]
  connect_bd_net -net clk_pl_axi_1 [get_bd_pins clk_pl_axi] [get_bd_pins pipereg_pl_axi0/clk] [get_bd_pins reset_sync_fixed/slowest_sync_clk]
  connect_bd_net -net pipereg_kernel0_q [get_bd_pins resetn_kernel0_ic] [get_bd_pins pipereg_kernel0/Q]
  connect_bd_net -net pipereg_kernel1_q [get_bd_pins resetn_kernel1_ic] [get_bd_pins pipereg_kernel1/Q]
  connect_bd_net -net pipereg_pcie0_q [get_bd_pins resetn_pcie_axi] [get_bd_pins pipereg_pcie0/Q]
  connect_bd_net -net pipereg_pl_axi0_q [get_bd_pins resetn_pl_axi] [get_bd_pins pipereg_pl_axi0/Q]
  connect_bd_net -net reset_sync_kernel0_interconnect_aresetn [get_bd_pins pipereg_kernel0/D] [get_bd_pins reset_sync_kernel0/interconnect_aresetn]
  connect_bd_net -net reset_sync_kernel0_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins reset_sync_kernel0/peripheral_aresetn]
  connect_bd_net -net reset_sync_kernel1_interconnect_aresetn [get_bd_pins pipereg_kernel1/D] [get_bd_pins reset_sync_kernel1/interconnect_aresetn]
  connect_bd_net -net resetn_pcie_1 [get_bd_pins resetn_pcie] [get_bd_pins pipereg_pcie0/D]
  connect_bd_net -net resetn_ulp_1 [get_bd_pins resetn_ulp] [get_bd_pins pipereg_pl_axi0/D] [get_bd_pins reset_sync_fixed/ext_reset_in] [get_bd_pins reset_sync_kernel0/ext_reset_in] [get_bd_pins reset_sync_kernel1/ext_reset_in]
  connect_bd_net -net rstn_const_dout [get_bd_pins pipereg_kernel0/reset] [get_bd_pins pipereg_kernel1/reset] [get_bd_pins pipereg_pcie0/reset] [get_bd_pins pipereg_pl_axi0/reset] [get_bd_pins rstn_const/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: kernel_interrupt
proc create_hier_cell_kernel_interrupt { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_kernel_interrupt() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 In0
  create_bd_pin -dir O -from 127 -to 0 xlconcat_interrupt_dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property CONFIG.IN0_WIDTH {32} $xlconcat_0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {96} \
  ] $xlconstant_0


  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_interrupt_dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

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
  set BLP_M_M00_INI_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 BLP_M_M00_INI_0 ]
  set_property APERTURES {{0xC1_0000_0000 12G}} [get_bd_intf_ports BLP_M_M00_INI_0]

  set BLP_M_M01_INI_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 BLP_M_M01_INI_0 ]
  set_property APERTURES {{0xC1_0000_0000 12G}} [get_bd_intf_ports BLP_M_M01_INI_0]

  set BLP_M_M02_INI_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 BLP_M_M02_INI_0 ]
  set_property APERTURES {{0xC1_0000_0000 12G}} [get_bd_intf_ports BLP_M_M02_INI_0]

  set BLP_S_AXI_CTRL_USER_00 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name BLP_S_AXI_CTRL_USER_00_araddr direction I left 63 right 0 } \
   ARPROT { physical_name BLP_S_AXI_CTRL_USER_00_arprot direction I left 2 right 0 } \
   ARREADY { physical_name BLP_S_AXI_CTRL_USER_00_arready direction O } \
   ARVALID { physical_name BLP_S_AXI_CTRL_USER_00_arvalid direction I } \
   AWADDR { physical_name BLP_S_AXI_CTRL_USER_00_awaddr direction I left 63 right 0 } \
   AWPROT { physical_name BLP_S_AXI_CTRL_USER_00_awprot direction I left 2 right 0 } \
   AWREADY { physical_name BLP_S_AXI_CTRL_USER_00_awready direction O } \
   AWVALID { physical_name BLP_S_AXI_CTRL_USER_00_awvalid direction I } \
   BREADY { physical_name BLP_S_AXI_CTRL_USER_00_bready direction I } \
   BRESP { physical_name BLP_S_AXI_CTRL_USER_00_bresp direction O left 1 right 0 } \
   BVALID { physical_name BLP_S_AXI_CTRL_USER_00_bvalid direction O } \
   RDATA { physical_name BLP_S_AXI_CTRL_USER_00_rdata direction O left 31 right 0 } \
   RREADY { physical_name BLP_S_AXI_CTRL_USER_00_rready direction I } \
   RRESP { physical_name BLP_S_AXI_CTRL_USER_00_rresp direction O left 1 right 0 } \
   RVALID { physical_name BLP_S_AXI_CTRL_USER_00_rvalid direction O } \
   WDATA { physical_name BLP_S_AXI_CTRL_USER_00_wdata direction I left 31 right 0 } \
   WREADY { physical_name BLP_S_AXI_CTRL_USER_00_wready direction O } \
   WSTRB { physical_name BLP_S_AXI_CTRL_USER_00_wstrb direction I left 3 right 0 } \
   WVALID { physical_name BLP_S_AXI_CTRL_USER_00_wvalid direction I } \
   } \
  BLP_S_AXI_CTRL_USER_00 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
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
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {1} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $BLP_S_AXI_CTRL_USER_00
  set_property APERTURES {{0x202_0000_0000 32M}} [get_bd_intf_ports BLP_S_AXI_CTRL_USER_00]
  set_property HDL_ATTRIBUTE.LOCKED {true} [get_bd_intf_ports BLP_S_AXI_CTRL_USER_00]

  set BLP_S_INI_AIE_00 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 BLP_S_INI_AIE_00 ]

  set BLP_S_INI_DBG_00 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 BLP_S_INI_DBG_00 ]

  set BLP_S_INI_PLRAM_00 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 BLP_S_INI_PLRAM_00 ]

  set qsfp0_161mhz [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 -board_intf qsfp0_161mhz qsfp0_161mhz ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   CONFIG.FREQ_HZ {161132812} \
   ] $qsfp0_161mhz
  set_property HDL_ATTRIBUTE.BOARD_INTERFACE {qsfp0_161mhz} [get_bd_intf_ports qsfp0_161mhz]
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports qsfp0_161mhz]

  set qsfp0_4x [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 -board_intf qsfp0_4x qsfp0_4x ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   ] $qsfp0_4x
  set_property HDL_ATTRIBUTE.BOARD_INTERFACE {qsfp0_4x} [get_bd_intf_ports qsfp0_4x]
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports qsfp0_4x]

  set qsfp1_161mhz [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 -board_intf qsfp1_161mhz qsfp1_161mhz ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   CONFIG.FREQ_HZ {161132812} \
   ] $qsfp1_161mhz
  set_property HDL_ATTRIBUTE.BOARD_INTERFACE {qsfp1_161mhz} [get_bd_intf_ports qsfp1_161mhz]
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports qsfp1_161mhz]

  set qsfp1_4x [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 -board_intf qsfp1_4x qsfp1_4x ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   ] $qsfp1_4x
  set_property HDL_ATTRIBUTE.BOARD_INTERFACE {qsfp1_4x} [get_bd_intf_ports qsfp1_4x]
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports qsfp1_4x]


  # Create ports
  set blp_m_dbg_hub_fw_00 [ create_bd_port -dir O -from 0 -to 0 -type intr blp_m_dbg_hub_fw_00 ]
  set blp_m_ext_tog_ctrl_kernel_00_enable [ create_bd_port -dir O -from 0 -to 0 blp_m_ext_tog_ctrl_kernel_00_enable ]
  set blp_m_ext_tog_ctrl_kernel_00_in [ create_bd_port -dir O -from 0 -to 0 blp_m_ext_tog_ctrl_kernel_00_in ]
  set blp_m_ext_tog_ctrl_kernel_01_enable [ create_bd_port -dir O -from 0 -to 0 blp_m_ext_tog_ctrl_kernel_01_enable ]
  set blp_m_ext_tog_ctrl_kernel_01_in [ create_bd_port -dir O -from 0 -to 0 blp_m_ext_tog_ctrl_kernel_01_in ]
  set blp_m_irq_kernel_00 [ create_bd_port -dir O -from 127 -to 0 -type intr blp_m_irq_kernel_00 ]
  set blp_s_aclk_ctrl_00 [ create_bd_port -dir I -type clk blp_s_aclk_ctrl_00 ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {BLP_S_AXI_CTRL_USER_00} \
   CONFIG.CLK_DOMAIN {bd_4885_pspmc_0_0_pl0_ref_clk} \
   CONFIG.FREQ_HZ {99999992} \
   CONFIG.FREQ_TOLERANCE_HZ {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
 ] $blp_s_aclk_ctrl_00
  set_property CONFIG.ASSOCIATED_BUSIF.VALUE_SRC STRONG $blp_s_aclk_ctrl_00
  set_property CONFIG.CLK_DOMAIN.VALUE_SRC STRONG $blp_s_aclk_ctrl_00
  set_property CONFIG.FREQ_HZ.VALUE_SRC STRONG $blp_s_aclk_ctrl_00
  set_property CONFIG.FREQ_TOLERANCE_HZ.VALUE_SRC STRONG $blp_s_aclk_ctrl_00
  set_property CONFIG.INSERT_VIP.VALUE_SRC STRONG $blp_s_aclk_ctrl_00
  set_property CONFIG.PHASE.VALUE_SRC STRONG $blp_s_aclk_ctrl_00

  set blp_s_aclk_ext_tog_kernel_00 [ create_bd_port -dir I -type clk blp_s_aclk_ext_tog_kernel_00 ]
  set_property -dict [ list \
   CONFIG.CLK_DOMAIN {cd_aclk_ext_tog_kernel_00} \
   CONFIG.FREQ_HZ {299996999} \
   CONFIG.FREQ_TOLERANCE_HZ {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
 ] $blp_s_aclk_ext_tog_kernel_00
  set_property CONFIG.CLK_DOMAIN.VALUE_SRC STRONG $blp_s_aclk_ext_tog_kernel_00
  set_property CONFIG.FREQ_HZ.VALUE_SRC STRONG $blp_s_aclk_ext_tog_kernel_00
  set_property CONFIG.FREQ_TOLERANCE_HZ.VALUE_SRC STRONG $blp_s_aclk_ext_tog_kernel_00
  set_property CONFIG.INSERT_VIP.VALUE_SRC STRONG $blp_s_aclk_ext_tog_kernel_00
  set_property CONFIG.PHASE.VALUE_SRC STRONG $blp_s_aclk_ext_tog_kernel_00

  set blp_s_aclk_ext_tog_kernel_01 [ create_bd_port -dir I -type clk blp_s_aclk_ext_tog_kernel_01 ]
  set_property -dict [ list \
   CONFIG.CLK_DOMAIN {cd_aclk_ext_tog_kernel_01} \
   CONFIG.FREQ_HZ {499994999} \
   CONFIG.FREQ_TOLERANCE_HZ {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
 ] $blp_s_aclk_ext_tog_kernel_01
  set_property CONFIG.CLK_DOMAIN.VALUE_SRC STRONG $blp_s_aclk_ext_tog_kernel_01
  set_property CONFIG.FREQ_HZ.VALUE_SRC STRONG $blp_s_aclk_ext_tog_kernel_01
  set_property CONFIG.FREQ_TOLERANCE_HZ.VALUE_SRC STRONG $blp_s_aclk_ext_tog_kernel_01
  set_property CONFIG.INSERT_VIP.VALUE_SRC STRONG $blp_s_aclk_ext_tog_kernel_01
  set_property CONFIG.PHASE.VALUE_SRC STRONG $blp_s_aclk_ext_tog_kernel_01

  set blp_s_aclk_kernel_00 [ create_bd_port -dir I -type clk blp_s_aclk_kernel_00 ]
  set_property -dict [ list \
   CONFIG.CLK_DOMAIN {cd_aclk_kernel_00} \
   CONFIG.FREQ_HZ {299996999} \
   CONFIG.FREQ_TOLERANCE_HZ {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
 ] $blp_s_aclk_kernel_00
  set_property CONFIG.CLK_DOMAIN.VALUE_SRC STRONG $blp_s_aclk_kernel_00
  set_property CONFIG.FREQ_HZ.VALUE_SRC STRONG $blp_s_aclk_kernel_00
  set_property CONFIG.FREQ_TOLERANCE_HZ.VALUE_SRC STRONG $blp_s_aclk_kernel_00
  set_property CONFIG.INSERT_VIP.VALUE_SRC STRONG $blp_s_aclk_kernel_00
  set_property CONFIG.PHASE.VALUE_SRC STRONG $blp_s_aclk_kernel_00

  set blp_s_aclk_kernel_01 [ create_bd_port -dir I -type clk blp_s_aclk_kernel_01 ]
  set_property -dict [ list \
   CONFIG.CLK_DOMAIN {cd_aclk_kernel_01} \
   CONFIG.FREQ_HZ {499994999} \
   CONFIG.FREQ_TOLERANCE_HZ {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
 ] $blp_s_aclk_kernel_01
  set_property CONFIG.CLK_DOMAIN.VALUE_SRC STRONG $blp_s_aclk_kernel_01
  set_property CONFIG.FREQ_HZ.VALUE_SRC STRONG $blp_s_aclk_kernel_01
  set_property CONFIG.FREQ_TOLERANCE_HZ.VALUE_SRC STRONG $blp_s_aclk_kernel_01
  set_property CONFIG.INSERT_VIP.VALUE_SRC STRONG $blp_s_aclk_kernel_01
  set_property CONFIG.PHASE.VALUE_SRC STRONG $blp_s_aclk_kernel_01

  set blp_s_aclk_pcie_00 [ create_bd_port -dir I -type clk blp_s_aclk_pcie_00 ]
  set_property -dict [ list \
   CONFIG.CLK_DOMAIN {bd_4885_pspmc_0_0_pl2_ref_clk} \
   CONFIG.FREQ_HZ {249999985} \
   CONFIG.FREQ_TOLERANCE_HZ {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
 ] $blp_s_aclk_pcie_00
  set_property CONFIG.CLK_DOMAIN.VALUE_SRC STRONG $blp_s_aclk_pcie_00
  set_property CONFIG.FREQ_HZ.VALUE_SRC STRONG $blp_s_aclk_pcie_00
  set_property CONFIG.FREQ_TOLERANCE_HZ.VALUE_SRC STRONG $blp_s_aclk_pcie_00
  set_property CONFIG.INSERT_VIP.VALUE_SRC STRONG $blp_s_aclk_pcie_00
  set_property CONFIG.PHASE.VALUE_SRC STRONG $blp_s_aclk_pcie_00

  set blp_s_aresetn_pcie_reset_00 [ create_bd_port -dir I -from 0 -to 0 -type rst blp_s_aresetn_pcie_reset_00 ]
  set_property -dict [ list \
   CONFIG.INSERT_VIP {0} \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $blp_s_aresetn_pcie_reset_00
  set_property CONFIG.INSERT_VIP.VALUE_SRC STRONG $blp_s_aresetn_pcie_reset_00
  set_property CONFIG.POLARITY.VALUE_SRC STRONG $blp_s_aresetn_pcie_reset_00

  set blp_s_aresetn_pr_reset_00 [ create_bd_port -dir I -from 0 -to 0 -type rst blp_s_aresetn_pr_reset_00 ]
  set_property -dict [ list \
   CONFIG.INSERT_VIP {0} \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $blp_s_aresetn_pr_reset_00
  set_property CONFIG.INSERT_VIP.VALUE_SRC STRONG $blp_s_aresetn_pr_reset_00
  set_property CONFIG.POLARITY.VALUE_SRC STRONG $blp_s_aresetn_pr_reset_00

  set blp_s_ext_tog_ctrl_kernel_00_out [ create_bd_port -dir I blp_s_ext_tog_ctrl_kernel_00_out ]
  set blp_s_ext_tog_ctrl_kernel_01_out [ create_bd_port -dir I blp_s_ext_tog_ctrl_kernel_01_out ]

  # Create instance: ai_engine_0, and set properties
  set ai_engine_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ai_engine:2.0 ai_engine_0 ]
  set_property -dict [list \
    CONFIG.AIE_CORE_REF_CTRL_FREQMHZ {1250} \
    CONFIG.CLK_NAMES {} \
    CONFIG.NAME_MI_AXI {} \
    CONFIG.NAME_MI_AXIS {} \
    CONFIG.NAME_SI_AXIS {} \
    CONFIG.NUM_CLKS {0} \
    CONFIG.NUM_MI_AXI {0} \
    CONFIG.NUM_MI_AXIS {0} \
    CONFIG.NUM_SI_AXIS {0} \
  ] $ai_engine_0


  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/S00_AXI]

  # Create instance: axi_dbg_fw, and set properties
  set axi_dbg_fw [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_firewall:1.2 axi_dbg_fw ]
  set_property CONFIG.MASK_ERR_RESP {1} $axi_dbg_fw


  # Create instance: axi_dbg_hub, and set properties
  set axi_dbg_hub [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dbg_hub:2.0 axi_dbg_hub ]
  set_property -dict [list \
    CONFIG.C_AXI_DATA_WIDTH {128} \
    CONFIG.C_NUM_DEBUG_CORES {0} \
  ] $axi_dbg_hub


  # Create instance: axi_gpio_null_user, and set properties
  set axi_gpio_null_user [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_null_user ]
  set_property CONFIG.C_GPIO_WIDTH {1} $axi_gpio_null_user


  # Create instance: axi_ic_user, and set properties
  set axi_ic_user [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_ic_user ]
  set_property -dict [list \
    CONFIG.ADVANCED_PROPERTIES {__experimental_features__ {__enable_axi4lite_64_mi__ 1}} \
    CONFIG.NUM_CLKS {2} \
    CONFIG.NUM_MI {2} \
    CONFIG.NUM_SI {1} \
  ] $axi_ic_user

  set_property HDL_ATTRIBUTE.DPA_AXILITE_MASTER {primary} [get_bd_cells axi_ic_user]

  # Create instance: axi_ic_user_extend, and set properties
  set axi_ic_user_extend [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_ic_user_extend ]
  set_property -dict [list \
    CONFIG.ADVANCED_PROPERTIES {__experimental_features__ {__enable_axi4lite_64_mi__ 1}} \
    CONFIG.NUM_CLKS {1} \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $axi_ic_user_extend


  # Create instance: axi_noc_aie_prog, and set properties
  set axi_noc_aie_prog [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_aie_prog ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {1} \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_NSI {1} \
    CONFIG.NUM_SI {0} \
  ] $axi_noc_aie_prog


  set_property -dict [ list \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /axi_noc_aie_prog/M00_AXI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M00_AXI { read_bw {5} write_bw {5} read_avg_burst {64} write_avg_burst {64}} } \
 ] [get_bd_intf_pins /axi_noc_aie_prog/S00_INI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI} \
 ] [get_bd_pins /axi_noc_aie_prog/aclk0]

  # Create instance: axi_noc_h2c, and set properties
  set axi_noc_h2c [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_h2c ]
  set_property -dict [list \
    CONFIG.NUM_MI {2} \
    CONFIG.NUM_NMI {0} \
    CONFIG.NUM_NSI {2} \
    CONFIG.NUM_SI {0} \
  ] $axi_noc_h2c


  set_property -dict [ list \
   CONFIG.APERTURES {{0x202_0580_0000 2M}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_h2c/M00_AXI]

  set_property -dict [ list \
   CONFIG.APERTURES {{0x202_0400_0000 16M}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_h2c/M01_AXI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M00_AXI { read_bw {1720} write_bw {1720} read_avg_burst {64} write_avg_burst {64}} } \
 ] [get_bd_intf_pins /axi_noc_h2c/S00_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {1720} write_bw {1720} read_avg_burst {64} write_avg_burst {64}} } \
 ] [get_bd_intf_pins /axi_noc_h2c/S01_INI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI:M01_AXI} \
 ] [get_bd_pins /axi_noc_h2c/aclk0]

  # Create instance: axi_noc_kernel0, and set properties
  set axi_noc_kernel0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_kernel0 ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {1} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_NMI {3} \
    CONFIG.NUM_NSI {0} \
    CONFIG.NUM_SI {3} \
  ] $axi_noc_kernel0

  set_property HDL_ATTRIBUTE.DPA_TRACE_SLAVE {true} [get_bd_cells axi_noc_kernel0]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /axi_noc_kernel0/M00_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /axi_noc_kernel0/M01_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /axi_noc_kernel0/M02_INI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M00_INI {read_bw {778} write_bw {389} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_kernel0/S00_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M01_INI {read_bw {778} write_bw {389} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_kernel0/S01_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M02_INI {read_bw {778} write_bw {389} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_kernel0/S02_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI:S01_AXI:S02_AXI} \
 ] [get_bd_pins /axi_noc_kernel0/aclk0]

  # Create instance: axi_sc_plram, and set properties
  set axi_sc_plram [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_sc_plram ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {2} \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $axi_sc_plram


  # Create instance: const_1, and set properties
  set const_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_1 ]

  # Create instance: gate_dbgfw_or, and set properties
  set gate_dbgfw_or [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 gate_dbgfw_or ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {1} \
  ] $gate_dbgfw_or


  # Create instance: ip_gnd_ext_tog_kernel_00_null, and set properties
  set ip_gnd_ext_tog_kernel_00_null [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ip_gnd_ext_tog_kernel_00_null ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {1} \
  ] $ip_gnd_ext_tog_kernel_00_null


  # Create instance: ip_gnd_ext_tog_kernel_01_null, and set properties
  set ip_gnd_ext_tog_kernel_01_null [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ip_gnd_ext_tog_kernel_01_null ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {1} \
  ] $ip_gnd_ext_tog_kernel_01_null


  # Create instance: ip_pipe_dbg_hub_fw_00, and set properties
  set ip_pipe_dbg_hub_fw_00 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ff:1.0 ip_pipe_dbg_hub_fw_00 ]
  set_property CONFIG.C_R_INVERTED {0} $ip_pipe_dbg_hub_fw_00


  # Create instance: ip_pipe_ext_tog_kernel_00_null, and set properties
  set ip_pipe_ext_tog_kernel_00_null [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ff:1.0 ip_pipe_ext_tog_kernel_00_null ]
  set_property CONFIG.C_R_INVERTED {0} $ip_pipe_ext_tog_kernel_00_null


  # Create instance: ip_pipe_ext_tog_kernel_01_null, and set properties
  set ip_pipe_ext_tog_kernel_01_null [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ff:1.0 ip_pipe_ext_tog_kernel_01_null ]
  set_property CONFIG.C_R_INVERTED {0} $ip_pipe_ext_tog_kernel_01_null


  # Create instance: irq_const_tieoff, and set properties
  set irq_const_tieoff [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 irq_const_tieoff ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {1} \
  ] $irq_const_tieoff


  # Create instance: kernel_interrupt
  create_hier_cell_kernel_interrupt [current_bd_instance .] kernel_interrupt

  # Create instance: kernel_interrupt_xlconcat_0_In0_1_interrupt_concat, and set properties
  set kernel_interrupt_xlconcat_0_In0_1_interrupt_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 kernel_interrupt_xlconcat_0_In0_1_interrupt_concat ]
  set_property CONFIG.NUM_PORTS {32} $kernel_interrupt_xlconcat_0_In0_1_interrupt_concat


  # Create instance: plram_ctrl, and set properties
  set plram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 plram_ctrl ]
  set_property -dict [list \
    CONFIG.DATA_WIDTH {512} \
    CONFIG.SINGLE_PORT_BRAM {1} \
  ] $plram_ctrl


  # Create instance: plram_ctrl_bram, and set properties
  set plram_ctrl_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_mem_gen:1.0 plram_ctrl_bram ]

  # Create instance: reset_controllers
  create_hier_cell_reset_controllers [current_bd_instance .] reset_controllers

  # Create instance: vecadd, and set properties
  set vecadd [ create_bd_cell -type ip -vlnv xilinx.com:RTLKernel:vecadd:1.0 vecadd ]

  # Create interface connections
  connect_bd_intf_net -intf_net BLP_S_AXI_CTRL_USER_00_1 [get_bd_intf_ports BLP_S_AXI_CTRL_USER_00] [get_bd_intf_pins axi_ic_user/S00_AXI]
  connect_bd_intf_net -intf_net BLP_S_INI_AIE_00_1 [get_bd_intf_ports BLP_S_INI_AIE_00] [get_bd_intf_pins axi_noc_aie_prog/S00_INI]
  connect_bd_intf_net -intf_net M00_INI_0 [get_bd_intf_ports BLP_M_M00_INI_0] [get_bd_intf_pins axi_noc_kernel0/M00_INI]
  connect_bd_intf_net -intf_net M01_INI_0 [get_bd_intf_ports BLP_M_M01_INI_0] [get_bd_intf_pins axi_noc_kernel0/M01_INI]
  connect_bd_intf_net -intf_net M02_INI_0 [get_bd_intf_ports BLP_M_M02_INI_0] [get_bd_intf_pins axi_noc_kernel0/M02_INI]
  connect_bd_intf_net -intf_net axi_ic_user_M00_AXI [get_bd_intf_pins axi_ic_user/M00_AXI] [get_bd_intf_pins axi_ic_user_extend/S00_AXI]
  connect_bd_intf_net -intf_net axi_ic_user_M01_AXI [get_bd_intf_pins axi_ic_user/M01_AXI] [get_bd_intf_pins vecadd/s_axi_control]
  connect_bd_intf_net -intf_net axi_ic_user_extend_M00_AXI [get_bd_intf_pins axi_gpio_null_user/S_AXI] [get_bd_intf_pins axi_ic_user_extend/M00_AXI]
  connect_bd_intf_net -intf_net axi_noc_aie_prog_M00_AXI [get_bd_intf_pins ai_engine_0/S00_AXI] [get_bd_intf_pins axi_noc_aie_prog/M00_AXI]
  connect_bd_intf_net -intf_net axi_noc_h2c_M00_AXI [get_bd_intf_pins axi_dbg_fw/S_AXI] [get_bd_intf_pins axi_noc_h2c/M00_AXI]
  connect_bd_intf_net -intf_net axi_noc_h2c_M00_AXI_fw [get_bd_intf_pins axi_dbg_fw/M_AXI] [get_bd_intf_pins axi_dbg_hub/S_AXI]
  connect_bd_intf_net -intf_net axi_noc_h2c_M01_AXI [get_bd_intf_pins axi_noc_h2c/M01_AXI] [get_bd_intf_pins axi_sc_plram/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_h2c_S00_INI [get_bd_intf_ports BLP_S_INI_DBG_00] [get_bd_intf_pins axi_noc_h2c/S00_INI]
  connect_bd_intf_net -intf_net axi_noc_h2c_S01_INI [get_bd_intf_ports BLP_S_INI_PLRAM_00] [get_bd_intf_pins axi_noc_h2c/S01_INI]
  connect_bd_intf_net -intf_net axi_sc_plram_M00_AXI [get_bd_intf_pins axi_sc_plram/M00_AXI] [get_bd_intf_pins plram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net plram_ctrl_BRAM_PORTA [get_bd_intf_pins plram_ctrl/BRAM_PORTA] [get_bd_intf_pins plram_ctrl_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net vecadd_m_axi_a [get_bd_intf_pins axi_noc_kernel0/S00_AXI] [get_bd_intf_pins vecadd/m_axi_a]
  connect_bd_intf_net -intf_net vecadd_m_axi_b [get_bd_intf_pins axi_noc_kernel0/S01_AXI] [get_bd_intf_pins vecadd/m_axi_b]
  connect_bd_intf_net -intf_net vecadd_m_axi_c [get_bd_intf_pins axi_noc_kernel0/S02_AXI] [get_bd_intf_pins vecadd/m_axi_c]

  # Create port connections
  connect_bd_net -net ai_engine_0_s00_axi_aclk [get_bd_pins ai_engine_0/s00_axi_aclk] [get_bd_pins axi_noc_aie_prog/aclk0]
  connect_bd_net -net axi_dbg_fw_mi_r_error [get_bd_pins axi_dbg_fw/mi_r_error] [get_bd_pins gate_dbgfw_or/Op2]
  connect_bd_net -net axi_dbg_fw_mi_w_error [get_bd_pins axi_dbg_fw/mi_w_error] [get_bd_pins gate_dbgfw_or/Op1]
  connect_bd_net -net blp_m_ext_tog_ctrl_kernel_00_enable_net [get_bd_ports blp_m_ext_tog_ctrl_kernel_00_enable] [get_bd_pins ip_gnd_ext_tog_kernel_00_null/dout]
  connect_bd_net -net blp_m_ext_tog_ctrl_kernel_01_enable_net [get_bd_ports blp_m_ext_tog_ctrl_kernel_01_enable] [get_bd_pins ip_gnd_ext_tog_kernel_01_null/dout]
  connect_bd_net -net blp_s_aclk_ctrl_00_1 [get_bd_ports blp_s_aclk_ctrl_00] [get_bd_pins axi_gpio_null_user/s_axi_aclk] [get_bd_pins axi_ic_user/aclk] [get_bd_pins axi_ic_user_extend/aclk] [get_bd_pins reset_controllers/clk_pl_axi]
  connect_bd_net -net blp_s_aclk_ext_tog_kernel_00_net [get_bd_ports blp_s_aclk_ext_tog_kernel_00] [get_bd_pins ip_pipe_ext_tog_kernel_00_null/clk]
  connect_bd_net -net blp_s_aclk_ext_tog_kernel_01_net [get_bd_ports blp_s_aclk_ext_tog_kernel_01] [get_bd_pins ip_pipe_ext_tog_kernel_01_null/clk]
  connect_bd_net -net blp_s_aclk_kernel_00_1 [get_bd_ports blp_s_aclk_kernel_00] [get_bd_pins axi_ic_user/aclk1] [get_bd_pins axi_noc_kernel0/aclk0] [get_bd_pins axi_sc_plram/aclk1] [get_bd_pins plram_ctrl/s_axi_aclk] [get_bd_pins reset_controllers/clk_kernel0] [get_bd_pins vecadd/ap_clk]
  connect_bd_net -net blp_s_aclk_kernel_01_1 [get_bd_ports blp_s_aclk_kernel_01] [get_bd_pins reset_controllers/clk_kernel1]
  connect_bd_net -net blp_s_aclk_pcie_00_1 [get_bd_ports blp_s_aclk_pcie_00] [get_bd_pins axi_dbg_fw/aclk] [get_bd_pins axi_dbg_hub/aclk] [get_bd_pins axi_noc_h2c/aclk0] [get_bd_pins axi_sc_plram/aclk] [get_bd_pins ip_pipe_dbg_hub_fw_00/clk] [get_bd_pins reset_controllers/clk_pcie]
  connect_bd_net -net blp_s_aresetn_pcie_reset_00_1 [get_bd_ports blp_s_aresetn_pcie_reset_00] [get_bd_pins reset_controllers/resetn_pcie]
  connect_bd_net -net blp_s_aresetn_pr_reset_00_1 [get_bd_ports blp_s_aresetn_pr_reset_00] [get_bd_pins reset_controllers/resetn_ulp]
  connect_bd_net -net blp_s_ext_tog_ctrl_kernel_00_out_net [get_bd_ports blp_s_ext_tog_ctrl_kernel_00_out] [get_bd_pins ip_pipe_ext_tog_kernel_00_null/D]
  connect_bd_net -net blp_s_ext_tog_ctrl_kernel_01_out_net [get_bd_ports blp_s_ext_tog_ctrl_kernel_01_out] [get_bd_pins ip_pipe_ext_tog_kernel_01_null/D]
  connect_bd_net -net const_1_dout [get_bd_pins axi_dbg_fw/aresetn] [get_bd_pins const_1/dout]
  connect_bd_net -net gate_dbgfw_or_Res [get_bd_pins gate_dbgfw_or/Res] [get_bd_pins ip_pipe_dbg_hub_fw_00/D]
  connect_bd_net -net ip_pipe_dbg_hub_fw_00 [get_bd_ports blp_m_dbg_hub_fw_00] [get_bd_pins ip_pipe_dbg_hub_fw_00/Q]
  connect_bd_net -net ip_pipe_ext_tog_kernel_00_null_q [get_bd_ports blp_m_ext_tog_ctrl_kernel_00_in] [get_bd_pins ip_pipe_ext_tog_kernel_00_null/Q]
  connect_bd_net -net ip_pipe_ext_tog_kernel_01_null_q [get_bd_ports blp_m_ext_tog_ctrl_kernel_01_in] [get_bd_pins ip_pipe_ext_tog_kernel_01_null/Q]
  connect_bd_net -net irq_const_tieoff_dout [get_bd_pins irq_const_tieoff/dout] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In0] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In2] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In3] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In4] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In5] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In6] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In7] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In8] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In9] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In10] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In11] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In12] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In13] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In14] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In15] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In16] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In17] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In18] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In19] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In20] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In21] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In22] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In23] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In24] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In25] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In26] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In27] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In28] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In29] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In30] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In31]
  connect_bd_net -net kernel_interrupt_xlconcat_0_In0_1_interrupt_concat_dout [get_bd_pins kernel_interrupt/In0] [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/dout]
  connect_bd_net -net kernel_interrupt_xlconcat_interrupt_dout [get_bd_ports blp_m_irq_kernel_00] [get_bd_pins kernel_interrupt/xlconcat_interrupt_dout]
  connect_bd_net -net reset_controllers_peripheral_aresetn [get_bd_pins reset_controllers/peripheral_aresetn] [get_bd_pins vecadd/ap_rst_n]
  connect_bd_net -net reset_controllers_resetn_kernel0_ic [get_bd_pins axi_sc_plram/aresetn] [get_bd_pins plram_ctrl/s_axi_aresetn] [get_bd_pins reset_controllers/resetn_kernel0_ic]
  connect_bd_net -net resetn_pcie_axi_net [get_bd_pins axi_dbg_hub/aresetn] [get_bd_pins reset_controllers/resetn_pcie_axi]
  connect_bd_net -net resetn_pl_axi_net [get_bd_pins axi_gpio_null_user/s_axi_aresetn] [get_bd_pins axi_ic_user/aresetn] [get_bd_pins axi_ic_user_extend/aresetn] [get_bd_pins reset_controllers/resetn_pl_axi]
  connect_bd_net -net vecadd_interrupt [get_bd_pins kernel_interrupt_xlconcat_0_In0_1_interrupt_concat/In1] [get_bd_pins vecadd/interrupt]

  # Create address segments
  assign_bd_address -offset 0x00C100000000 -range 0x000300000000 -target_address_space [get_bd_addr_spaces vecadd/m_axi_a] [get_bd_addr_segs BLP_M_M00_INI_0/Reg] -force
  assign_bd_address -offset 0x00C100000000 -range 0x000300000000 -target_address_space [get_bd_addr_spaces vecadd/m_axi_b] [get_bd_addr_segs BLP_M_M01_INI_0/Reg] -force
  assign_bd_address -offset 0x00C100000000 -range 0x000300000000 -target_address_space [get_bd_addr_spaces vecadd/m_axi_c] [get_bd_addr_segs BLP_M_M02_INI_0/Reg] -force
  assign_bd_address -offset 0x020200000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces BLP_S_AXI_CTRL_USER_00] [get_bd_addr_segs axi_gpio_null_user/S_AXI/Reg] -force
  assign_bd_address -offset 0x020200001000 -range 0x00001000 -target_address_space [get_bd_addr_spaces BLP_S_AXI_CTRL_USER_00] [get_bd_addr_segs vecadd/s_axi_control/reg0] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces BLP_S_INI_AIE_00] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020205800000 -range 0x00200000 -target_address_space [get_bd_addr_spaces BLP_S_INI_DBG_00] [get_bd_addr_segs axi_dbg_hub/S_AXI_DBG_HUB/Mem0] -force
  assign_bd_address -offset 0x020204000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces BLP_S_INI_PLRAM_00] [get_bd_addr_segs plram_ctrl/S_AXI/Mem0] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  # Create PFM attributes
  set_property PFM_NAME {xilinx:vck5000:gen4x8_qdma_2:202220.1} [get_files [current_bd_design].bd]
  set_property PFM.CLOCK {  clk_100m {id "2" is_default "false" proc_sys_reset "reset_controllers/reset_sync_fixed" status "fixed" freq_hz "100000000"} } [get_bd_ports /blp_s_aclk_ctrl_00]
  set_property PFM.CLOCK {  clk_out0 {id "0" is_default "true" proc_sys_reset "reset_controllers/reset_sync_kernel0"}  } [get_bd_ports /blp_s_aclk_kernel_00]
  set_property PFM.CLOCK {  clk_out1 {id "1" is_default "false" proc_sys_reset "reset_controllers/reset_sync_kernel1"}  } [get_bd_ports /blp_s_aclk_kernel_01]
  set_property PFM.AXI_PORT {M02_AXI { memport "M_AXI_GP" } M03_AXI { memport "M_AXI_GP" } M04_AXI { memport "M_AXI_GP" } M05_AXI { memport "M_AXI_GP" } M06_AXI { memport "M_AXI_GP" } M07_AXI { memport "M_AXI_GP" } M08_AXI { memport "M_AXI_GP" } M09_AXI { memport "M_AXI_GP" } M10_AXI { memport "M_AXI_GP" } M11_AXI { memport "M_AXI_GP" } M12_AXI { memport "M_AXI_GP" } M13_AXI { memport "M_AXI_GP" } M14_AXI { memport "M_AXI_GP" } M15_AXI { memport "M_AXI_GP" } } [get_bd_cells /axi_ic_user]
  set_property PFM.AXI_PORT {M01_AXI {memport "M_AXI_GP"} M02_AXI {memport "M_AXI_GP"} M03_AXI {memport "M_AXI_GP"} M04_AXI {memport "M_AXI_GP"} M05_AXI {memport "M_AXI_GP"} M06_AXI {memport "M_AXI_GP"} M07_AXI {memport "M_AXI_GP"} M08_AXI {memport "M_AXI_GP"} M09_AXI {memport "M_AXI_GP"} M10_AXI {memport "M_AXI_GP"} M11_AXI {memport "M_AXI_GP"} M12_AXI {memport "M_AXI_GP"} M13_AXI {memport "M_AXI_GP"} M14_AXI {memport "M_AXI_GP"} M15_AXI {memport "M_AXI_GP"}} [get_bd_cells /axi_ic_user_extend]
  set_property PFM.AXI_PORT {S03_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S04_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S05_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S06_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S07_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S08_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S09_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S10_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S11_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S12_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S13_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S14_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S15_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S16_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S17_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S18_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S19_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S20_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S21_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S22_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S23_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S24_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } S25_AXI { memport "S_AXI_NOC" sptag "MC_NOC0" } } [get_bd_cells /axi_noc_kernel0]
  set_property PFM.AXI_PORT {S01_AXI {memport "S_AXI_HP" sptag "BRAM" memory "plram_ctrl Mem0" auto "false"} S02_AXI {memport "S_AXI_HP" sptag "BRAM" memory "plram_ctrl Mem0" auto "false"} S03_AXI {memport "S_AXI_HP" sptag "BRAM" memory "plram_ctrl Mem0" auto "false"} S04_AXI {memport "S_AXI_HP" sptag "BRAM" memory "plram_ctrl Mem0" auto "false"} S05_AXI {memport "S_AXI_HP" sptag "BRAM" memory "plram_ctrl Mem0" auto "false"} S06_AXI {memport "S_AXI_HP" sptag "BRAM" memory "plram_ctrl Mem0" auto "false"} S07_AXI {memport "S_AXI_HP" sptag "BRAM" memory "plram_ctrl Mem0" auto "false"} S08_AXI {memport "S_AXI_HP" sptag "BRAM" memory "plram_ctrl Mem0" auto "false"} S09_AXI {memport "S_AXI_HP" sptag "BRAM" memory "plram_ctrl Mem0" auto "false"} S10_AXI {memport "S_AXI_HP" sptag "BRAM" memory "plram_ctrl Mem0" auto "false"} S11_AXI {memport "S_AXI_HP" sptag "BRAM" memory "plram_ctrl Mem0" auto "false"} S12_AXI {memport "S_AXI_HP" sptag "BRAM" memory "plram_ctrl Mem0" auto "false"} S13_AXI {memport "S_AXI_HP" sptag "BRAM" memory "plram_ctrl Mem0" auto "false"} S14_AXI {memport "S_AXI_HP" sptag "BRAM" memory "plram_ctrl Mem0" auto "false"} S15_AXI {memport "S_AXI_HP" sptag "BRAM" memory "plram_ctrl Mem0" auto "false"}} [get_bd_cells /axi_sc_plram]


  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


