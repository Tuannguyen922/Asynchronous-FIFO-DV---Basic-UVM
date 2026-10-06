`timescale 1ns/1ps
module gray_counter #(parameter int WIDTH = 4) 
  (
  input  logic         		clk,
  input  logic         		rst_n,
  input  logic         		en,
  output logic [WIDTH-1:0] 	bin_count,
  output logic [WIDTH-1:0] 	gray_count,
  output logic [WIDTH-1:0] 	bin_next,
  output logic [WIDTH-1:0] 	gray_next
);

  always_comb begin
    bin_next = bin_count;
    if (en) begin
      bin_next = bin_count + 1'b1;
    end
    gray_next = bin_next ^ (bin_next >> 1);
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      bin_count  <= '0;
      gray_count <= '0;
    end else begin
      bin_count  <= bin_next;
      gray_count <= gray_next;
    end
  end

endmodule