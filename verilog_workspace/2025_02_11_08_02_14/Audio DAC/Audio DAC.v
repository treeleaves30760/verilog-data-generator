module multiplier (
    input  [7:0] a,
    input  [7:0] b,
    output [15:0] product
);

    reg [15:0] acc;

    always @* begin
        acc = 0;
        for (i = 0; i < 8; i = i + 1) begin
            shifted_a = a << i;
            if (b[i]) begin
                acc = acc + shifted_a;
            end
        end
        product = acc;
    end

endmodule