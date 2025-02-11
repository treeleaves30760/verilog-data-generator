module multiplier_8x8 (
    input  [7:0] a,
    input  [7:0] b,
    output [15:0] product
);

always @* begin
    [15:0] sum;
    integer i;
    
    sum = 0;
    for (i = 0; i < 8; i++) begin
        [15:0] partial_product;
        partial_product = a * ((b >> i) & 1);
        partial_product = partial_product << i;
        sum = sum + partial_product;
    end
    product = sum;
end

endmodule