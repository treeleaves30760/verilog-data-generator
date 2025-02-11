module Multiplier (
    input clk,
    input rst_n,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] product
);
    
    // Internal signals
    reg [7:0] a_reg;
    reg [7:0] b_reg;

    always @(posedge clk) begin
        if (~rst_n) begin
            a_reg <= 0;
            b_reg <= 0;
            product <= 0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            product <= (a_reg * b_reg);
        end
    end

endmodule