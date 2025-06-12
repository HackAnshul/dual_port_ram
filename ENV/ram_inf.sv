////////////////////////////////////////////////////////////////////////
//   File Name      : ram_inf.sv                                      //
//   Author         : Anshul_Pandya                                   //
//   Project Name   : Dual_Port_Ram                                   //
//   Description    : Define all the signals of dut and give          //
//                    direction to the signals of dut and testbench   //
////////////////////////////////////////////////////////////////////////

//Gaurd Statment to avoid multiple compilation of a file
`ifndef RAM_INF_SV
`define RAM_INF_SV
//typedef RAM_INF_SV

interface ram_inf(input clk);

  logic rst;

  ////// Write Signals //////
  logic wr_enb;
  logic [(`ADDR_WIDTH-1):0] wr_addr;
  logic [(`DATA_WIDTH-1):0] wr_data;

  ////// Read Signals //////
  logic rd_enb;
  logic [(`ADDR_WIDTH-1):0] rd_addr;
  logic [(`DATA_WIDTH-1):0] rd_data;

  //// driver's clocking block ////
  clocking drv_cb @(posedge clk);
    default input #1 output #1;
    input rst;
    output wr_enb, wr_addr, wr_data;
    output rd_enb, rd_addr;
  endclocking

  //// monitor's clocking block ////
  clocking mon_cb @(posedge clk);
    default input #1 output #1;
    input rst;
    input wr_enb, wr_addr, wr_data;
    input rd_enb, rd_addr,rd_data;
  endclocking

  modport DRV_MP (clocking drv_cb,input clk);
  modport MON_MP (clocking mon_cb, input clk);


endinterface

`endif
