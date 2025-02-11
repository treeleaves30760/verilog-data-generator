module mux_4to1 (
    input wire [1:0] s,
    input wire in0,
    input wire in1,
    input wire in2,
    input wire in3,
    output wire out
);

    always @(*) begin
        case (s)
            2'b00:  // Select input0 when s is 00
                out = in0;
            2'b01:  // Select input1 when s is 01
                out = in1;
            2'b10:  // Select input2 when s is 10
                out = in2;
            2'b11:  // Select input3 when s is 11
                out = in3;
        endcase
    end

endmodule