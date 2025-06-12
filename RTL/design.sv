//RAM 16x8
`define addr_width 4
`define depth 16
`define data_width 8
module ram (clk,
            rst,
            wr_enb,
            wr_addr,
            wr_data,
            rd_enb,
            rd_addr,
            rd_data);

//port direction
  input clk, rst;

 //write signals
  input                   wr_enb;
  input [`addr_width-1:0] wr_addr;
  input [`data_width-1:0] wr_data;

 //read signals
  input                        rd_enb;
  input      [`addr_width-1:0] rd_addr;
  output reg [`data_width-1:0] rd_data;

  //internal memory
  reg [`data_width-1:0] ram [0:`depth-1];
  reg [`addr_width:0] i;

  //implementation3
  always@(posedge clk)
    if (rst) begin
      rd_data <= `data_width'd0;
      //memory initialisation
      for (i=0;i<`depth;i=i+1)
        ram[i] <= `data_width'd0;
    end else begin
      //write logic
      if (wr_enb)
        ram[wr_addr] <= wr_data;
      //read logic
      if (rd_enb)
        rd_data <= ram[rd_addr];
    end
endmodule
