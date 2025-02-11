module mux_4to1 (
    input wire [1:0] sel,
    input wire in0,
    input wire in1,
    input wire in2,
    input wire in3,
    output wire out
);

    // This module selects between four inputs based on a 2-bit selector
    always @(*) begin
        case (sel)
            0:   out <= in0;  // sel == 00, select input 0
            1:   out <= in1;  // sel == 01, select input 1
            2:   out <= in2;  // sel == 10, select input 2
            default: out <= in3; // default case, select input 3 (sel == 11)
        endcase
    end

endmodule