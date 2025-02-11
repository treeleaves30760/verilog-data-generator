// 4-to-1 Multiplexer Module
// This module selects between four input signals based on two control signals (sel0 and sel1).
module mux4to1 (
    input wire a,   // Input 0
    input wire b,   // Input 1
    input wire c,   // Input 2
    input wire d,   // Input 3
    input wire sel0, // Most significant selection bit (control signal)
    input wire sel1, // Least significant selection bit (control signal)
    output wire y   // Output of the multiplexer
);
    // The if-else chain is used to select between a, b, c, d based on sel0 and sel1.
    // sel0 and sel1 form a 2-bit binary number where:
    // 00 selects a, 01 selects b, 10 selects c, 11 selects d
    if (sel0 == 0 && sel1 == 0) begin
        y = a;
    end else if (sel0 == 0 && sel1 == 1) begin
        y = b;
    end else if (sel0 == 1 && sel1 == 0) begin
        y = c;
    end else if (sel0 == 1 && sel1 == 1) begin
        y = d;
    end
endmodule