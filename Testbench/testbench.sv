`timescale 1ns/1ps
`include "pkg.sv"
`ifndef TESTCASE
  `define TESTCASE test_balance
`endif
module tb;
  import uvm_pkg::*;
  import pkg::*;

  fifo_if #(.DEPTH(`DEPTH), .DATA_WIDTH(`DATA_WIDTH)) f_if();

  async_fifo #(
    .DEPTH      (`DEPTH),
    .DATA_WIDTH (`DATA_WIDTH)
  ) DUT (
    .wr_clk   (f_if.wr_clk),
    .rd_clk   (f_if.rd_clk),
    .rst_n    (f_if.rst_n),
    .wr_en    (f_if.wr_en),
    .rd_en    (f_if.rd_en),
    .wr_data  (f_if.wr_data),
    .rd_data  (f_if.rd_data),
    .wr_full  (f_if.wr_full),
    .rd_empty (f_if.rd_empty)
  );


  // ---- write-clock domain, with setup/hold skew ----
  initial begin
    forever #(`WR_PERIOD/2) f_if.wr_clk_setup = ~f_if.wr_clk_setup;
  end
  assign #(`T_SETUP) f_if.wr_clk      = f_if.wr_clk_setup;
  assign #(`T_HOLD)  f_if.wr_clk_hold = f_if.wr_clk;

  // ---- read-clock domain, independent frequency, own setup/hold skew ----
  initial begin
    forever #(`RD_PERIOD/2) f_if.rd_clk_setup = ~f_if.rd_clk_setup;
  end
  assign #(`T_SETUP) f_if.rd_clk      = f_if.rd_clk_setup;
  assign #(`T_HOLD)  f_if.rd_clk_hold = f_if.rd_clk;

  initial begin
    uvm_config_db#(virtual fifo_if)::set(uvm_root::get(),"*","vif",f_if);
    run_test();
  end
  
  // Guard against the failure mode where nobody drives rst_n
  initial begin
    #1000;
    if (f_if.rst_n === 1'bx)
      `uvm_fatal("NO_RESET", "rst_n is still X - no sequence applied a reset")
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end

endmodule