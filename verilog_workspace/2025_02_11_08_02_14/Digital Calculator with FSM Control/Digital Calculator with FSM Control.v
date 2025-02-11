// 2-to-1 Multiplexer Module
// Inputs: a, b (data inputs)
//         sel (selector input)
// Output: y (selected output)
module mux_2to1 (
    input wire a,
    input wire b,
    input wire sel,
    output wire y
);

    always @(*) begin
        // If selector is 0, output a; else, output b
        if (sel == 0) begin
            y = a;
        end else begin
            y = b;
        end
    end

endmodule