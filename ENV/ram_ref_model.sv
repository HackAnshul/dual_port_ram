`ifndef RAM_REF_MOD_SV
`define RAM_REF_MOD_SV
class ram_ref_model;

  //take transation handles
  ram_trans trans_h1,trans_h2;
  
  //declare variables needed
  bit [`DATA_WIDTH - 1:0] mem [`DEPTH - 1:0];
  bit [`DATA_WIDTH-1:0] rd_data_tmp;
  

  //declare mailboxs
  mailbox #(ram_trans) mon2rf;
  mailbox #(ram_trans) ref2sb;

  //take connect method
  function void connect (mailbox #(ram_trans) mon2rf,
                         mailbox #(ram_trans) ref2sb);
    this.mon2rf = mon2rf;
    this.ref2sb = ref2sb;
  endfunction

  task run();
    forever begin
      mon2rf.get(trans_h1);
      trans_h2 = new trans_h1;
      //trans_h1.print(trans_h1,"trans_h1");
      //collect data from mailbox
      predict_exp_rd_data(trans_h2);
      //put transaction for scoboard
      //$display("before putting");
      ref2sb.put(trans_h2);
      //trans_h1.print(trans_h1,"rerf model");

      
   end
  endtask

  //description
  task predict_exp_rd_data(ram_trans trans_h);
    if(trans_h.rst) begin
      trans_h.rd_data <= 0;
      foreach(mem[i])
        mem[i] <= 0;
    end else begin
      if((trans_h.kind_e == WRITE) || (trans_h.kind_e == SIM_RW))
        mem[trans_h.wr_addr] <= trans_h.wr_data;
      
      if((trans_h.kind_e == READ) || (trans_h.kind_e == SIM_RW))
        rd_data_tmp <= mem[trans_h.rd_addr];
        trans_h.rd_data <= rd_data_tmp;
    end
  endtask

 endclass
`endif