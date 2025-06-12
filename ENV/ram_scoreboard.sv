////////////////////////////////////////////////////////////////////////
//   File Name      : ram_scoreboard.sv                               //
//   Author         : Anshul_Pandya                                   //
//   Project Name   : Dual_Port_Ram                                   //
//   Description    :   //
//                        //
////////////////////////////////////////////////////////////////////////

`ifndef RAM_SB_SV
`define RAM_SB_SV

class ram_scoreboard;
  //take transation handles
  ram_trans exp_trans,act_trans;
  int success;
  int failure;
  event ev_sample;
  //declare mailboxs
  mailbox #(ram_trans) ref2sb;
  mailbox #(ram_trans) mon2sb;

  //take connect method

  covergroup cvg@(ev_sample);
    KIND: coverpoint act_trans.kind_e {
      bins write_bin = {WRITE};
      bins read_bin = {READ};
      bins simrw_bin = {SIM_RW};
      bins b2b_bin = {WRITE->READ->WRITE->READ};
    }
    WR_ADDR: coverpoint act_trans.wr_addr {
      bins min_addr = {'h00};
      bins low_rng = {['h01:'h04]};
      bins med_rng = {['h05:'h0A]};
      bins high_rng = {['h0B:'h0E]};
      bins max_addr = {'h0F};
    }
    WR_DATA: coverpoint act_trans.wr_data {
      bins low_rng = {['h00:'h2F]};
      bins med_rng = {['h30:'h7F]};
      bins high_rng = {['h80:'hFF]};
      ignore_bins ign_rng = {['h50:'h60]};
      //illegal_bins ign_rng = {['h50:'h60]};
    }
    RD_ADDR: coverpoint act_trans.rd_addr {
      bins min_addr = {'h00};
      bins low_rng = {['h01:'h04]};
      bins med_rng = {['h05:'h0A]};
      bins high_rng = {['h0B:'h0E]};
      bins max_addr = {'h0F};
    }
    RD_DATA: coverpoint act_trans.rd_data {
      bins low_rng = {['h00:'h2F]};
      bins med_rng = {['h30:'h4F]};
      bins high_rng = {['h50:'hFF]};
      ignore_bins ign_rng = {['h50:'h60]};
      //illegal_bins ign_rng = {['h50:'h60]};
    }
    RST: coverpoint act_trans.rst {
      bins rst_bins = (0=>1=>0);
    }
    READ_TEN_TIMES: coverpoint act_trans.kind_e {
      bins ten_read = (READ[*10]);
    }
    WRITE_TEN_TIMES: coverpoint act_trans.kind_e {
      bins ten_write = (WRITE[*10]);
    }

    DATAXADDR: cross WR_DATA, WR_ADDR{
      bins RW0 = bins_of(WR_DATA) instersect {'h00,'h01,'h02}
    }
  endgroup

  cvg =new();

  function void connect ( mailbox #(ram_trans) ref2sb,
                          mailbox #(ram_trans) mon2sb);
    this.mon2sb = mon2sb;
    this.ref2sb = ref2sb;
  endfunction

  task run();

    forever begin
      ref2sb.get(exp_trans);
      ram_pkg::raise_objection();
      //collect data from all mailboxs
      //$display("scb");
      mon2sb.get(act_trans);
      exp_trans.print(exp_trans,"expected");
      act_trans.print(act_trans,"actual");

      //compare act and exp and log the results
      check_data(act_trans,exp_trans);
      #(`half_clk)
      ram_pkg::drop_objection();
    end
  endtask

  //description
 task check_data(ram_trans act_trans, ram_trans exp_trans);
//    if(act_trans == exp_trans)
//      success++;
//    else
//      failure++;
   `ram_checker(act_trans.rd_data,exp_trans.rd_data)
   //cvg.sample();
   -> ev_sample;
 endtask


  function void print_sb();
    $display(" ----------------------------------");
    if ((this.success > 0) && (this.failure < 5)) begin
      $display("| .#####....####....####....####.. |");
      $display("| .##..##..##..##..##......##..... |");
      $display("| .#####...######...####....####.. |");
      $display("| .##......##..##......##......##. |");
      $display("| .##......##..##...####....####.. |");

    end else begin
      $display("| .######...####...######..##..... |");
      $display("| .##......##..##....##....##..... |");
      $display("| .####....######....##....##..... |");
      $display("| .##......##..##....##....##..... |");
      $display("| .##......##..##..######..######. |");

    end
    $display("| -> Total Read: %3d               |",act_trans.rd_cnt);
    $display("| -> Total Write: %3d              |",act_trans.wr_cnt);
    $display("| -> Total success: %3d            |",this.success);
    $display("| -> Total failure: %3d            |",this.failure);
    $display(" ----------------------------------");

  endfunction

 endclass
`endif
