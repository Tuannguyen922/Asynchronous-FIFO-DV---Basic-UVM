`timescale 1ns/1ps
interface fifo_if #(
  parameter int DEPTH = `DEPTH,
  parameter int DATA_WIDTH = `DATA_WIDTH    
) ();
  bit             			wr_clk_setup;
  bit             			wr_clk;
  bit             			wr_clk_hold;
  bit             			rd_clk_setup;
  bit             			rd_clk;
  bit             			rd_clk_hold;
  logic           			rst_n;      
  logic           			wr_en;
  logic [DATA_WIDTH-1:0]	wr_data;
  logic           			wr_full;
  logic           			rd_en;
  logic [DATA_WIDTH-1:0]	rd_data;
  logic           			rd_empty;
endinterface