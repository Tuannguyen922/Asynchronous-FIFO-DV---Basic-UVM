`timescale 1ns/1ps
`include "gray_counter.sv"
`include "ff2_synchronizer.sv"
`include "gray_to_bin.sv"
`include "wr_ptr_full.sv"
`include "rd_ptr_empty.sv"
`include "dual_port_ram.sv"
`include "reset_sync.sv"

module async_fifo #(
  parameter int DEPTH      = 8,
  parameter int DATA_WIDTH = 16,
  parameter int ADDR_WIDTH = $clog2(DEPTH)
) (
  input  logic             		wr_clk,
  input  logic             		rd_clk,
  input  logic             		rst_n,
  input  logic             		wr_en,
  input  logic             		rd_en,
  input  logic [DATA_WIDTH-1:0] wr_data,
  output logic [DATA_WIDTH-1:0] rd_data,
  output logic             		wr_full,
  output logic             		rd_empty
);

  logic wr_rst_n, rd_rst_n;

  logic [ADDR_WIDTH-1:0] wr_addr, rd_addr;
  logic [ADDR_WIDTH:0]   wr_gray, rd_gray;
  logic [ADDR_WIDTH:0]   wr_gray_sync, rd_gray_sync;
  logic [ADDR_WIDTH:0]   wr_ptr_sync_bin, rd_ptr_sync_bin;

  logic wr_en_gated, rd_en_gated;

  assign wr_en_gated = wr_en & ~wr_full;
  assign rd_en_gated = rd_en & ~rd_empty;

  reset_sync u_rst_sync_wr (
    .clk         (wr_clk),
    .async_rst_n (rst_n),
    .sync_rst_n  (wr_rst_n)
  );

  reset_sync u_rst_sync_rd (
    .clk         (rd_clk),
    .async_rst_n (rst_n),
    .sync_rst_n  (rd_rst_n)
  );

  ff2_synchronizer #(
    .WIDTH (ADDR_WIDTH+1)
  ) u_sync_2ff_r2w (
    .clk_dest   (wr_clk),
    .rst_n      (wr_rst_n),
    .async_data (rd_gray),
    .sync_data  (rd_gray_sync)
  );

  ff2_synchronizer #(
    .WIDTH (ADDR_WIDTH+1)
  ) u_sync_2ff_w2r (
    .clk_dest   (rd_clk),
    .rst_n      (rd_rst_n),
    .async_data (wr_gray),
    .sync_data  (wr_gray_sync)
  );

  gray_to_bin u_g2b_rd (
    .gray_in (rd_gray_sync),
    .bin_out (rd_ptr_sync_bin)
  );

  gray_to_bin u_g2b_wr (
    .gray_in (wr_gray_sync),
    .bin_out (wr_ptr_sync_bin)
  );

  wr_ptr_full #(
    .ADDR_WIDTH (ADDR_WIDTH)
  ) u_wr_ptr_full (
    .wr_clk          (wr_clk),
    .wr_rst_n        (wr_rst_n),
    .wr_en           (wr_en_gated),
    .rd_ptr_sync_bin (rd_ptr_sync_bin),
    .wr_addr         (wr_addr),
    .wr_gray         (wr_gray),
    .wr_full         (wr_full)
  );

  rd_ptr_empty #(
    .ADDR_WIDTH (ADDR_WIDTH)
  ) u_rd_ptr_empty (
    .rd_clk          (rd_clk),
    .rd_rst_n        (rd_rst_n),
    .rd_en           (rd_en_gated),
    .wr_ptr_sync_bin (wr_ptr_sync_bin),
    .rd_addr         (rd_addr),
    .rd_gray         (rd_gray),
    .rd_empty        (rd_empty)
  );

  dual_port_ram #(
    .DEPTH      (DEPTH),
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
  ) u_fifomem (
    .wr_clk   (wr_clk),
    .wr_rst_n (wr_rst_n),
    .wr_en    (wr_en_gated),
    .wr_addr  (wr_addr),
    .wr_data  (wr_data),
    .rd_clk   (rd_clk),
    .rd_rst_n (rd_rst_n),
    .rd_en    (rd_en_gated),
    .rd_addr  (rd_addr),
    .rd_data  (rd_data)
  );

endmodule
