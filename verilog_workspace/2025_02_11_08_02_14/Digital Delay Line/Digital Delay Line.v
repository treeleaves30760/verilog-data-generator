// 4-bit counter module with reset and overflow detection
module four_bit_counter (
    input clk,          // Clock input (rising edge)
    input rst,          // Reset input (active high)
    output reg [3:0] count_out,  // 4-bit binary counter output
    output reg overflow   // Overflow flag when counting exceeds 15
);

    // Internal registers for each bit of the counter
    reg b0;  // Least significant bit
    reg b1;
    reg b2;
    reg b3;  // Most significant bit

    // Reset functionality: sets all bits to 0 and clears overflow on rst rising edge
    always @(posedge rst) begin
        b0 <= 0;
        b1 <= 0;
        b2 <= 0;
        b3 <= 0;
        overflow <= 0;
    end

    // Counting logic: increments counter on each clock cycle if not in reset state
    always @(posedge clk) begin
        if (rst == 1) begin
            // Reset state: set all bits to 0 and clear overflow
            b0 <= 0;
            b1 <= 0;
            b2 <= 0;
            b3 <= 0;
            overflow <= 0;
        end else begin
            // Calculate new count value
            reg [4:0] new_count = {b3, b2, b1, b0} + 1;

            // Check if the new count exceeds the maximum (15)
            if (new_count == 5'b10000) begin
                overflow <= 1;  // Set overflow flag
                b0 <= 0;
                b1 <= 0;
                b2 <= 0;
                b3 <= 0;       // Reset all bits to 0 on overflow
            end else begin
                overflow <= 0;  // Clear overflow flag if not overflowing
                b0 <= new_count[0];
                b1 <= new_count[1];
                b2 <= new_count[2];
                b3 <= new_count[3];  // Update each bit with new value
            end
        end
    end

    // Assign the four bits to the output bus
    assign count_out = {b3, b2, b1, b0};

endmodule