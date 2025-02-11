// 4-to-1 Multiplexer Module
// This module selects between four input signals based on two selector bits
module mux_4to1 (
    input logic A,          // Input 00
    input logic B,          // Input 01
    input logic C,          // Input 10
    input logic D,          // Input 11
    input logic [1:0] Sel,  // Selector bits (2 bits)
    output logic Y          // Output (selected input)
);

    always @(*) begin
        case (Sel)            // Select between A, B, C, D based on Sel[1:0]
            00: Y = A;        // When selector is 00, output A
            01: Y = B;        // When selector is 01, output B
            10: Y = C;        // When selector is 10, output C
            11: Y = D;        // When selector is 11, output D
        endcase
    end

endmodule