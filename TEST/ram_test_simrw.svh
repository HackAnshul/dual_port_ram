`ifndef SIM_RW_TEST_SV
`define SIM_RW_TEST_SV

class sim_rw_test extends ram_gen;

  task run();
    ram_pkg::raise_objection();
    repeat (no_of_trans) begin
      `sv_do_with(trans_h,{kind_e == SIM_RW;})
    end
        #(`half_clk);
    ram_pkg::drop_objection();
  endtask
endclass

`endif
