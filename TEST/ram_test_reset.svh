`ifndef RAM_TEST_TEST
`define RAM_TEST_TEST

class reset_test extends ram_gen;

  task run();
    ram_pkg::raise_objection();
    repeat(no_of_trans) begin
      `sv_do_with(trans_h,{kind_e == WRITE; wr_addr == 10; wr_data == 5*no_of_trans;})
      `sv_do_with(trans_h,{kind_e == READ; rd_addr == 10; })
    //  `sv_do_with(trans_h,{kind_e == READ; rd_addr == 10; })
    ->ram_pkg::rst_drv;
      #10;
      `sv_do_with(trans_h,{kind_e == READ; rd_addr == 10; })
    end

//     repeat(no_of_trans)begin
//       `sv_do_with(trans_h,{wr_data < 100;})
//     end
    #(`half_clk);
    ram_pkg::drop_objection();
  endtask

endclass
`endif
