module eight_bit_full_adder (
    input wire [7:0] A,
    input wire [7:0] B,
    input wire C_in,
    output wire [7:0] S,
    output wire C_out
);

    // Carry chain to propagate carry signals through each full adder
    wire [7:0] carries;

    // Generate 8 full_adder instances for each bit position
    generate
        for (i = 0; i < 8; i++) begin : FA_instances
            full_adder fa (
                .A(A[i]),
                .B(B[i]),
                .C_in((i == 0) ? C_in : carries[i-1]),
                .S(S[i]),
                .C_out(carries[i])
            );
        end
    endgenerate

    // The final carry-out is the carry from the last full adder
    assign C_out = carries[7];

endmodule