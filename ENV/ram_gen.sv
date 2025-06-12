////////////////////////////////////////////////////////////////////////
//   File Name      : ram_gen.sv                                      //
//   Author         : Anshul_Pandya                                   //
//   Project Name   : Dual_Port_Ram                                   //
//   Description    : generate stimuli and send to mailbox to         //
//                    ram_driver.                                     //
////////////////////////////////////////////////////////////////////////

`ifndef RAM_GEN_SV
`define RAM_GEN_SV
virtual class ram_gen;

  ram_trans trans_h, trans_h_copy;

  //mailbox
  mailbox #(ram_trans) gen2drv;

  rand int no_of_trans;

  constraint TRANS {soft no_of_trans == 5;}

  function void connect (mailbox #(ram_trans) gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  pure virtual task run();

  protected task put_trans(ram_trans req);
    ram_trans req_copy;
    req_copy = new req;
    req.print(req,"generator");
    this.gen2drv.put(req_copy);
    //wait(drv_comp.triggered);
    @(drv_comp);
  endtask
endclass

`endif
