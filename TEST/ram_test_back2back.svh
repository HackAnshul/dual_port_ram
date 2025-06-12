`ifndef BACK2BACK_TEST_SV
`define BACK2BACK_TEST_SV

class back2back extends ram_gen;
  local bit[`DATA_WIDTH-1:0] rand_no;
  task run();
    ram_pkg::raise_objection();
    repeat(no_of_trans) begin
      std::randomize(rand_no);
      `sv_do_with(trans_h,{kind_e == WRITE; wr_data == rand_no; })
      `sv_do_with(trans_h,{kind_e == READ; wr_data == rand_no; })
    end
    #(`half_clk);

    ram_pkg::drop_objection();
  endtask
endclass

`endif