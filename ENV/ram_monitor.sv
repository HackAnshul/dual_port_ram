////////////////////////////////////////////////////////////////////////
//   File Name      : ram_monitor.sv                                  //
//   Author         : Anshul Pandya                                   //
//   Project Name   : Dual_Port_Ram                                   //
//   Description    :  //
//                                                                    //
////////////////////////////////////////////////////////////////////////

`ifndef RAM_MONITOR_SV
`define RAM_MONITOR_SV
class ram_monitor;



  //declare mailboxs
  mailbox #(ram_trans) mon2rf;
  mailbox #(ram_trans) mon2sb;

  //declare transaction class
  ram_trans trans_h;

  //declare virtual interface
  virtual ram_inf.MON_MP vif;

  //take connect method
  function void connect (mailbox #(ram_trans) mon2rf,
                         mailbox #(ram_trans) mon2sb,
                         virtual ram_inf.MON_MP vif);
    this.mon2rf = mon2rf;
    this.mon2sb = mon2sb;
    this.vif = vif;
  endfunction
  
  
  task get_from_dut(ram_trans item_collected);

    @(vif.mon_cb);

    //$cast(item_collected.kind_e,{vif.mon_cb.wr_enb, vif.mon_cb.rd_enb});
 
    case({vif.mon_cb.wr_enb,vif.mon_cb.rd_enb})
      2'b00: trans_h.kind_e = IDLE;
      2'b01: trans_h.kind_e = READ;
      2'b10: trans_h.kind_e = WRITE;
      2'b11: trans_h.kind_e = SIM_RW;
    endcase
    item_collected.wr_addr = vif.mon_cb.wr_addr;
    item_collected.wr_data = vif.mon_cb.wr_data;
    item_collected.rd_addr = vif.mon_cb.rd_addr;
    item_collected.rd_data = vif.mon_cb.rd_data;
  endtask
  
  task run();
    wait_reset_release();
    forever begin
      //ram_pkg::raise_objection();
      fork
        begin
          trans_h=new();
          get_from_dut(trans_h);
          trans_h.print(trans_h,"Monitor");
          mon2rf.put(trans_h);
          mon2sb.put(trans_h);
        end
        wait_reset_assert();
      join_any
      disable fork;
      wait_reset_release();  
          //ram_pkg::drop_objection();
    end
  endtask
  
  task wait_reset_release();
    wait (vif.mon_cb.rst == 0);
  endtask
  task wait_reset_assert();
    wait (vif.mon_cb.rst == 1);
  endtask
  

//  description
//  task monitor();
//    sample data from design
//    create item_collected
//    item_collected.wr_addr = vif.wmon_cb.wr_addr;
//    item_collected.kind_e = kind'{vif.wmon_cb.wr_enb,vif.wmon_cb.rd_enb};
//    $cast(item_collected.kind_e,{vif.wmon_cb.wr_enb,vif.wmon_cb.rd_enb});
//  endtask

endclass

`endif