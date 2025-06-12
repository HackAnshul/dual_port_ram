`ifndef RAM_LRNG_DATA_XTN_SVH
`define RAM_LRNG_DATA_XTN_SVH

class ram_lrng_data_xtn extends ram_gen;


  task run();
    ram_pkg::raise_objection();
    repeat(no_of_trans) begin
      `sv_do_with(trans_h,{wr_data < 100;})
    end
    #10;
    ->ram_pkg::rst_drv;
    repeat(no_of_trans)begin
      `sv_do_with(trans_h,{wr_data < 100;})
    end
    #2.5;
    ram_pkg::drop_objection();
  endtask
	 
endclass
`endif