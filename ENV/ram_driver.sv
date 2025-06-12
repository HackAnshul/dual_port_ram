
////////////////////////////////////////////////////////////////////////
//   File Name      : ram_driver.sv                                   //
//   Author         : Anshul Pandya                                   //
//   Project Name   : Dual_Port_Ram                                   //
//   Description    : Drives the stimulus coming from ram_gen to DUT. //
//                                                                    //
////////////////////////////////////////////////////////////////////////

`ifndef RAM_DRIVER_SV
`define RAM_DRIVER_SV
class ram_driver;

  ram_trans trans_h;

  //mailbox
  mailbox #(ram_trans) gen2drv;

  //virtual interface
  virtual ram_inf.DRV_MP vif;


  function void connect (mailbox #(ram_trans) mbx,
                         virtual ram_inf.DRV_MP vif);
    this.gen2drv = mbx;
    this.vif = vif;
  endfunction

  task run();
    wait_reset_release();
    forever begin
      trans_h = new();

      //ram_pkg::raise_objection();
      fork
        begin
          gen2drv.try_get(trans_h);
          trans_h.print(trans_h,"Driver");
          //collect transaction from mailbox
          //and drive the interface pins for design
          //input as per the protocol
          //keep separte task for driving
          send_to_dut();
          -> drv_comp;
        end
        wait_reset_assert();
      join_any
      disable fork;
      //init
//       fork
//         vif.drv_cb.wr_enb <= 0;
//         vif.drv_cb.rd_enb <= 0;

//         vif.drv_cb.rd_addr <= 0;

//         vif.drv_cb.wr_addr <= 0;
//         vif.drv_cb.wr_data <= 0;
//       join_none
      wait_reset_release();
//       disable fork;
    end
  endtask

  //description
  task send_to_dut();
    //drive data to design
    @(vif.drv_cb);

    vif.drv_cb.wr_enb <= (trans_h.kind_e == WRITE || trans_h.kind_e == SIM_RW) ? 1'b1 : 1'b0;
    vif.drv_cb.rd_enb <= (trans_h.kind_e == READ  || trans_h.kind_e == SIM_RW) ? 1'b1 : 1'b0;

    vif.drv_cb.rd_addr <= trans_h.rd_addr;

    vif.drv_cb.wr_addr <= trans_h.wr_addr;
    vif.drv_cb.wr_data <= trans_h.wr_data;

  endtask

  task wait_reset_release();
    wait (vif.drv_cb.rst == 0);
  endtask
  task wait_reset_assert();
    wait (vif.drv_cb.rst == 1);
  endtask
endclass
`endif
