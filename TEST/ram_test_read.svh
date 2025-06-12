`ifndef READ_TEST_SV
`define READ_TEST_SV

class read_test extends ram_gen;

  task run();
    ram_pkg::raise_objection();
    repeat(no_of_trans) begin
      `sv_do_with(trans_h,{kind_e == READ;})
    end
    #(`half_clk);
    ram_pkg::drop_objection();
  endtask
endclass

`endif
