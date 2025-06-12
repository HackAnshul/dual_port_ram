///// HEADER
// when you use one variable in more than one verification component class then
// better you declare it in transaction class
// when you use one variable in one verification component class
//(within the class) only then
// better you declare it in that class itself (local)

//Gaurd Statment to avoid multiple compilation of a file
`ifndef RAM_TRANS_SV
`define RAM_TRANS_SV
typedef enum bit [1:0] {IDLE, READ, WRITE, SIM_RW} trans_kind;

`include "ram_defines.svh"

class ram_trans extends sv_sequence_item;
  bit rst;
  static int wr_cnt, rd_cnt;
  
  
  static int que[$];
  // write
  //bit wr_enb;
  rand bit [(`ADDR_WIDTH-1):0] wr_addr;
  rand bit [(`DATA_WIDTH-1):0]wr_data;

  // read
  //bit rd_enb;
  rand bit [(`ADDR_WIDTH-1):0] rd_addr;
  bit [(`DATA_WIDTH-1):0] rd_data;

  // to randomize testcases

  rand trans_kind kind_e;

  //declare atributtes rand or non-rand type

  //enum to set the transaction kind (direction)
  //kind_e value
  //WRITE  : write transaction
  //READ   : read transaction
  //SIM_RW : simulteous read write transaction


  //write default constraint if needed

  //add static variables to record no. of write and read transaction

  //override print/display method to print transaction attributes
  constraint wr_data_c {
    que.size != 0 -> (rd_addr inside {que});
  }
  
  function void post_randomize();
    que.push_back(wr_addr);
    if (kind_e == READ || kind_e == SIM_RW)
      rd_cnt++;
    if (kind_e == WRITE || kind_e == SIM_RW)
      wr_cnt++;
  endfunction

  function void print(sv_sequence_item rhs, string block);
    ram_trans lhs;
    $cast(lhs,rhs);
    $display("====================== %10s ====================== \@%0t ",block,$time);
    $display("| Kind_e | rst | wr_addr | wr_data | rd_addr | rd_data |");
    $display("| %6s | %3d | %7d | %7d | %7d | %7d |", lhs.kind_e.name, lhs.rst, lhs.wr_addr, lhs.wr_data, lhs.rd_addr, lhs.rd_data);
    /*$display(" Var        | Type     | Size | Value");
    $display("---------------------------------------");
    $display(" rst        | Integral |   1  | %0d", lhs.rst);
    $display(" wr_addr    | Integral |   4  | %0d", lhs.wr_addr);
    $display(" wr_data    | Integral |   8  | %0d", lhs.wr_data);
    $display(" rd_addr    | Integral |   4  | %0d", lhs.rd_addr);
    $display(" rd_data    | Integral |   8  | %0d", rd_data);
    $display(" operation  | Enum     |   4  | %0s", lhs.kind_e.name);*/
    $display("objections:%0d",ram_pkg::objection_count);
    $display("");
  endfunction

endclass

`endif
