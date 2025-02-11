// 4-bit counter module with rising edge increment on clock
module four_bit_counter (
    input wire clk,
    input wire rst,
    output reg [3:0] count_out
);

    // D-Flip-Flop (DFF) macro to create a simple flip-flop
    // This is used for each bit in the 4-bit counter
    `define DFF(clk, rst, d, q) \
        always @(posedge clk or posedge rst) begin \
            if (rst) q <= 0; \
            else       q <= d; \
        end

    // Instantiate four DFFs for each bit of the 4-bit counter
    reg [3:0] count;
    
    // Create a DFF for each bit of the counter
    `DFF(clk, rst, count[0], count_out[0])
    `DFF(clk, rst, count[1], count_out[1])
    `DFF(clk, rst, count[2], count_out[2])
    `DFF(clk, rst, count[3], count_out[3])

    // Compute the next value of the counter
    wire [3:0] next_val;
    wire all_ones;

    // Check if all bits are 1 (overflow condition)
    assign all_ones = (count == 4'b1111);

    // Calculate next value, reset if overflow
    always @(posedge clk) begin
        if (rst) begin
            count <= 0;
        end else begin
            if (all_ones) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule