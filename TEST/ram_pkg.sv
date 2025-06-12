// guard statement to avoid multiple compilation of a file
`ifndef RAM_PACKAGE_SV
`define RAM_PACKAGE_SV

`include "ram_defines.svh"
`include "ram_inf.sv"

package ram_pkg;
  event drv_comp;
  event rst_drv;
  event rst_assert;
  event rst_release;

  int objection_count;

  function void raise_objection();
    objection_count++;
  endfunction

  function void drop_objection();
    objection_count--;
  endfunction
//   task wait_reset_release();
//     @(rst_release);
//   endtask
//   task wait_reset_assert();
//     @(rst_assert);
//   endtask

  `include "sv_sequence_item.sv"
  `include "ram_trans.sv"
  `include "ram_gen.sv"
  `include "ram_driver.sv"
  `include "ram_monitor.sv"
  `include "ram_ref_model.sv"
  `include "ram_scoreboard.sv"
  `include "ram_env.sv"
  //add all file till test, don't miss the order

  //testcases
  `include "ram_lrng_data_xtn.svh"
  `include "ram_test_reset.svh"
  `include "ram_test_read.svh"
  `include "ram_test_write.svh"
  `include "ram_test_simrw.svh"
  `include "ram_test_back2back.svh"

  `include "ram_base_test.sv"

endpackage


`endif
