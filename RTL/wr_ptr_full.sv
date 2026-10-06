`timescale 1ns/1ps
//------------------------------------------------------------------------
// Module      : wr_ptr_full
// Description : Write-side Gray pointer generator + FULL flag.
//------------------------------------------------------------------------
module wr_ptr_full #(
  parameter int ADDR_WIDTH = 3
) (
  input  logic                   wr_clk,
  input  logic                   wr_rst_n,
  input  logic                   wr_en,
  input  logic [ADDR_WIDTH:0]    rd_ptr_sync_bin,
  output logic [ADDR_WIDTH-1:0]  wr_addr,
  output logic [ADDR_WIDTH:0]    wr_gray,
  output logic                   wr_full
);

  logic [ADDR_WIDTH:0] wr_ptr_bin;
  logic [ADDR_WIDTH:0] wr_ptr_bin_next;
  logic [ADDR_WIDTH:0] wr_gray_next;
  logic                wr_full_next;

  gray_counter #(
    .WIDTH (ADDR_WIDTH+1)
  ) u_wr_gray_cnt (
    .clk        (wr_clk),
    .rst_n      (wr_rst_n),
    .en         (wr_en),
    .bin_count  (wr_ptr_bin),
    .gray_count (wr_gray),
    .bin_next   (wr_ptr_bin_next),
    .gray_next  (wr_gray_next)
  );

  assign wr_addr = wr_ptr_bin[ADDR_WIDTH-1:0];

  // Next-state FULL logic: wrap bit differs, address bits match.
  always_comb begin
    wr_full_next = (wr_ptr_bin_next[ADDR_WIDTH]    != rd_ptr_sync_bin[ADDR_WIDTH]) &&
                (wr_ptr_bin_next[ADDR_WIDTH-1:0] == rd_ptr_sync_bin[ADDR_WIDTH-1:0]);
  end

  // Registered output at module boundary.
  always_ff @(posedge wr_clk or negedge wr_rst_n) begin
    if (!wr_rst_n) begin
      wr_full <= 1'b0;
    end else begin
      wr_full <= wr_full_next;
    end
  end

endmodule