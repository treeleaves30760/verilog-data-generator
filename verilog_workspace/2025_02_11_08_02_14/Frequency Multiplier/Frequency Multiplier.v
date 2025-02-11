module mux_4to1 (
    input wire [7:0] in0,
    input wire [7:0] in1,
    input wire [7:0] in2,
    input wire [7:0] in3,
    input wire sel0,
    input wire sel1,
    output wire [7:0] out
);

    // This module selects between four 8-bit inputs based on two control signals (sel0 and sel1).
    // The selection is determined as follows:
    // - sel0=0, sel1=0 ¡÷ in0
    // - sel0=0, sel1=1 ¡÷ in1
    // - sel0=1, sel1=0 ¡÷ in2
    // - sel0=1, sel1=1 ¡÷ in3
    case ({sel0, sel1}) {
        2'b00: out = in0;
        2'b01: out = in1;
        2'b10: out = in2;
        default: out = in3; // 2'b11: out = in3
    }

endmodule