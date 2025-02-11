module dlpf (
    input  clk,
    input  rst,
    input  data_in,
    output data_out
);

// Internal state variables declaration
reg [15:0] x_n2, y_n2;  // Previous two inputs and outputs for recursive calculation
reg [15:0] x_n1, y_n1;

// Coefficients scaled to integer values (multipliers and shifters)
localparam 
    b0 = 4899/1000,
    b1 = 1736/1000,
    b2 = 748/1000,
    a1 = 9356/1000,
    a2 = 3020/1000;

// Difference equation calculation using integer arithmetic to prevent overflow
always @(posedge clk) begin
    if (rst) begin
        // Reset condition: clear all internal states and output
        x_n2 <= 0;
        y_n2 <= 0;
        x_n1 <= 0;
        y_n1 <= 0;
        data_out <= 0;
    end else begin
        // Store current input for next cycle calculations
        x_n2 <= x_n1;
        x_n1 <= data_in;

        // Recursive filter calculation using 32-bit intermediate results
        reg [31:0] next_data_out;
        reg [31:0] b0_x, b1_x, b2_x, a1_y, a2_y;

        // Calculate each term separately to avoid overflow
        b0_x = $signed({data_in}) * b0;
        b1_x = $signed(x_n1) * b1;
        b2_x = $signed(x_n2) * b2;
        a1_y = $signed(y_n1) * a1;
        a2_y = $signed(y_n2) * a2;

        // Sum all terms to compute next output
        next_data_out = (b0_x + b1_x + b2_x - a1_y - a2_y);
        
        // Assign the computed value to the output, ensuring 16-bit signed integer range
        data_out <= ($signed(next_data_out[31:16])) >> 1;
        
        // Update previous outputs for next cycle
        y_n2 <= y_n1;
        y_n1 <= data_out;
    end
end

// Synchronize input data with clock
always @(posedge clk) begin
    x_n1 <= data_in;
end

endmodule