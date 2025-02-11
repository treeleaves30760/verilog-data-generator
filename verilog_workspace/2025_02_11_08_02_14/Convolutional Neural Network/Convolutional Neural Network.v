module mul_8x8_Wallace_tree (
    input  [7:0] a,
    input  [7:0] b,
    output [15:0] c
);

    // This module implements an 8x8 multiplier using the Wallace tree algorithm.
    // It efficiently reduces the number of adders by leveraging parallel addition.

    // Step 1: Generate all partial products
    wire [7:0][7:0] partial_products;
    genvar i, j;
    generate
        for (i = 0; i < 8; i++) begin
            for (j = 0; j < 8; j++) begin
                assign partial_products[i][j] = a[i] & b[j];
            end
        end
    endgenerate

    // Step 2: Implement Wallace tree reduction stages
    wire [15:0] sum, carry;

    // First level of reduction (Level 1)
    always @(partial_products) begin
        {sum, carry} = {
            partial_products[0][0] ^ partial_products[0][1] ^ partial_products[0][2] ^ partial_products[0][3] ^
            partial_products[0][4] ^ partial_products[0][5] ^ partial_products[0][6] ^ partial_products[0][7],
            
            partial_products[0][0] & partial_products[0][1] |
            partial_products[0][2] & partial_products[0][3] |
            partial_products[0][4] & partial_products[0][5] |
            partial_products[0][6] & partial_products[0][7]
        };
    end

    // Subsequent levels of reduction (Level 2 and beyond)
    always @(sum, carry) begin
        {sum, carry} = {
            sum ^ carry,
            sum & carry
        };
    end

    // Step 3: Final addition to produce the product
    assign c = sum + carry;

endmodule