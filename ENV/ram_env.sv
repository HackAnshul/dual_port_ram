////////////////////////////////////////////////////////////////////////
//   File Name      : ram_env.sv                                      //
//   Author         : Anshul_Pandya                                   //
//   Project Name   : Dual_Port_Ram                                   //
//   Description    :  //
//                                                                    //
////////////////////////////////////////////////////////////////////////

`ifndef RAM_ENV_EV
`define RAM_ENV_EV
class ram_env;

  //take handles of all verification sub component i.e. genrator, driver etc
  ram_gen        gen_h;
  ram_driver     drv_h;
  ram_monitor    mon_h;
  ram_ref_model  ref_h;
  ram_scoreboard scb_h;

  //declare all mailboxs
  mailbox #(ram_trans) gen2drv=new();
  mailbox #(ram_trans) mon2rf=new();
  mailbox #(ram_trans) mon2sb=new();
  mailbox #(ram_trans) rf2sb=new();

  //declare all interface
  virtual ram_inf.DRV_MP  drv_inf;
  virtual ram_inf.MON_MP  mon_inf;

  //take connect method (only for virtual interface)
  function void connect(virtual ram_inf.DRV_MP drv_inf,
                   virtual ram_inf.MON_MP mon_inf);
	this.drv_inf = drv_inf;
	this.mon_inf = mon_inf;
    this.connect_all();
  endfunction

  //create all the component in this method
  function void build();
    //gen_h=new();
    drv_h=new();
    mon_h=new();
    ref_h=new();
    scb_h=new();
  endfunction

  //call all verif sub component connect method here
  function void connect_all();
    gen_h.connect(gen2drv);
    drv_h.connect(gen2drv,drv_inf);
    mon_h.connect(mon2rf,mon2sb,mon_inf);
    ref_h.connect(mon2rf,rf2sb);
    scb_h.connect(rf2sb,mon2sb);
  endfunction

  //call all verif sub component run task in parallel
  task run();
    fork
      gen_h.run();
      drv_h.run();
      mon_h.run();
      ref_h.run();
      scb_h.run();
    join_any
  endtask
  
  function void print_sb();
    scb_h.print_sb();
  endfunction

endclass
`endif