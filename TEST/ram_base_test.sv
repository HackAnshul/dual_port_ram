// guard statement
`ifndef RAM_BASE_TEST_SV
`define RAM_BASE_TEST_SV

class ram_base_test;

  local int itr;

  //take handle of verification environment class
  ram_env env;

  //testcases
  ram_lrng_data_xtn lxtn;
  ////////////
  reset_test reset_test;
  read_test rd_test;
  write_test wr_test;
  sim_rw_test sim_test;
  back2back b2b_test;


  // declare all interface
  virtual ram_inf.DRV_MP vif;
  virtual ram_inf.MON_MP mvif;

  // take connect method (only for virtual interface)
  function void connect(virtual ram_inf.DRV_MP vif,
                        virtual ram_inf.MON_MP mvif);
    this.vif = vif;
    this.mvif = mvif;
    env.connect(vif,mvif);
  endfunction

  //create environment and call its methods here as needed
  function void build();
    env = new();
    env.build();
    void'($value$plusargs("iter=%d",itr));
    `sv_do_on_with(RESET_TEST,     reset_test, {no_of_trans == itr;})
    `sv_do_on_with(READ_TEST,      rd_test,    {no_of_trans == itr;})
    `sv_do_on_with(WRITE_TEST,     wr_test,    {no_of_trans == itr;})
    `sv_do_on_with(SIM_RW_TEST,    sim_test,   {no_of_trans == itr;})
    `sv_do_on_with(BACK2BACK_TEST, b2b_test,  {no_of_trans == itr;})
  endfunction


  // call environment run task
  task run();
    env.run();
  endtask

  function print_sb();
    env.print_sb();
  endfunction

endclass

`endif
