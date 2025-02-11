module mux_4to1 (
    input logic in0,
    input logic in1,
    input logic in2,
    input logic in3,
    input logic [1:0] sel,
    output logic data_out
);

always_comb begin
    case (sel)
        00: data_out = in0;
        01: data_out = in1;
        10: data_out = in2;
        11: data_out = in3;
        default: data_out = in0; // Default case, though not necessary for 2-bit sel
    endcase
end

endmodule