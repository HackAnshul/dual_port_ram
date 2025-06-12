`ifndef WRITE_TEST_SV
`define WRITE_TEST_SV

class write_test extends ram_gen;

  task run();
    ram_pkg::raise_objection();
    repeat (no_of_trans) begin
      `sv_do_with(trans_h,{kind_e == WRITE;})
    end
    #(`half_clk);
    ram_pkg::drop_objection();
  endtask
endclass

`endif