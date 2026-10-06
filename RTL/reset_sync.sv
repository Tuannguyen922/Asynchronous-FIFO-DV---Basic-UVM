`timescale 1ns/1ps
module reset_sync (
  input  logic clk,
  input  logic async_rst_n,
  output logic sync_rst_n
);

  logic rst_ff1_r, rst_ff2_r;

  always_ff @(posedge clk or negedge async_rst_n) begin
    if (!async_rst_n) begin
      rst_ff1_r <= 1'b0;
      rst_ff2_r <= 1'b0;
    end else begin
      rst_ff1_r <= 1'b1;
      rst_ff2_r <= rst_ff1_r;
    end
  end

  assign sync_rst_n = rst_ff2_r;

endmodule