`timescale 1ns/1ps
module dual_port_ram #(
  parameter int DEPTH      = 8,
  parameter int DATA_WIDTH = 16,
  parameter int ADDR_WIDTH = $clog2(DEPTH)
) (
  input  logic                  wr_clk,
  input  logic                  wr_rst_n,
  input  logic                  wr_en,
  input  logic [ADDR_WIDTH-1:0] wr_addr,
  input  logic [DATA_WIDTH-1:0] wr_data,
  input  logic                  rd_clk,
  input  logic                  rd_rst_n,
  input  logic                  rd_en,
  input  logic [ADDR_WIDTH-1:0] rd_addr,
  output logic [DATA_WIDTH-1:0] rd_data
);

  logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

  always_ff @(posedge wr_clk) begin
    if (wr_en) begin
      mem[wr_addr] <= wr_data;
    end
  end

  always_ff @(posedge rd_clk or negedge rd_rst_n) begin
    if (!rd_rst_n) begin
      rd_data <= '0;
    end else if (rd_en) begin
      rd_data <= mem[rd_addr];
    end
  end

endmodule