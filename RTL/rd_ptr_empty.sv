`timescale 1ns/1ps
//------------------------------------------------------------------------
// Module      : rd_ptr_empty
// Description : Read-side Gray pointer generator + EMPTY flag.
//------------------------------------------------------------------------
module rd_ptr_empty #(
  parameter int ADDR_WIDTH = 3
) (
  input  logic                   rd_clk,
  input  logic                   rd_rst_n,
  input  logic                   rd_en,
  input  logic [ADDR_WIDTH:0]    wr_ptr_sync_bin,
  output logic [ADDR_WIDTH-1:0]  rd_addr,
  output logic [ADDR_WIDTH:0]    rd_gray,
  output logic                   rd_empty
);

  logic [ADDR_WIDTH:0] rd_ptr_bin;
  logic [ADDR_WIDTH:0] rd_ptr_bin_next;
  logic [ADDR_WIDTH:0] rd_gray_next;
  logic                rd_empty_next;

  gray_counter #(
    .WIDTH (ADDR_WIDTH+1)
  ) u_rd_gray_cnt (
    .clk        (rd_clk),
    .rst_n      (rd_rst_n),
    .en         (rd_en),
    .bin_count  (rd_ptr_bin),
    .gray_count (rd_gray),
    .bin_next   (rd_ptr_bin_next),
    .gray_next  (rd_gray_next)
  );

  assign rd_addr = rd_ptr_bin[ADDR_WIDTH-1:0];

  // Next-state EMPTY logic: pointers fully match (address + wrap bit).
  always_comb begin
    rd_empty_next = (rd_ptr_bin_next == wr_ptr_sync_bin);
  end

  // Registered output at module boundary. Reset value = 1 (FIFO starts
  // empty), matching the reset behavior of the original design.
  always_ff @(posedge rd_clk or negedge rd_rst_n) begin
    if (!rd_rst_n) begin
      rd_empty <= 1'b1;
    end else begin
      rd_empty <= rd_empty_next;
    end
  end

endmodule