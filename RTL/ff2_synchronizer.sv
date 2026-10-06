`timescale 1ns/1ps
module ff2_synchronizer #(
  parameter int WIDTH = 5
) (
  input  logic             clk_dest,
  input  logic             rst_n,
  input  logic [WIDTH-1:0] async_data,
  output logic [WIDTH-1:0] sync_data
);

  logic [WIDTH-1:0] sync_ff1_r, sync_ff2_r;

  always_ff @(posedge clk_dest or negedge rst_n) begin
    if (!rst_n) begin
      sync_ff1_r <= '0;
      sync_ff2_r <= '0;
    end else begin
      sync_ff1_r <= async_data;
      sync_ff2_r <= sync_ff1_r;
    end
  end

  assign sync_data = sync_ff2_r;

endmodule