`timescale 1ns / 1ps

module band_stop_filter (
    input clk,
    input rst_n,
    input [15:0] data_in,
    input [15:0] coefficients,
    input enable,
    output reg [15:0] data_out,
    output reg valid,
    output overflow
);

    // Internal signals and registers
    reg rst;
    reg [15:0] coeff_reg, data_reg;
    wire [15:0] multiply_result;
    reg [31:0] accumulator;
    reg overflow_flag;

    // Control logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            rst <= 1;
        end else begin
            rst <= 0;
        end
    end

    // Main processing logic
    always @(posedge clk) begin
        if (rst) begin
            coeff_reg <= 0;
            data_reg <= 0;
            accumulator <= 0;
            overflow_flag <= 0;
            valid <= 0;
        end else if (enable) begin
            // Update coefficient and data registers
            coeff_reg <= coefficients;
            data_reg <= data_in;

            // FIR filter processing
            multiply_result = signed_mult(data_reg, coeff_reg);
            accumulator = add_with_overflow(accumulator, multiply_result);
            overflow_flag = $overflow(accumulator);

            // Validity and output handling
            if (overflow_flag) begin
                valid <= 0;
            end else begin
                valid <= 1;
            end

            data_out <= accumulator[15:0];
        end
    end

    // Helper functions for arithmetic operations
    function signed_mult(a, b);
        input [15:0] a, b;
        output [31:0] signed_mult;
        integer i;
        for (i = 0; i < 32; i = i + 1) begin
            if (i < 16) begin
                signed_mult[i] = a[i] & b[i];
            end else begin
                signed_mult[i] = a[15] & b[15];
            end
        end
    endfunction

    function add_with_overflow(a, b);
        input [31:0] a, b;
        output [31:0] add_with_overflow;
        add_with_overflow = a + b;
    endfunction

endmodule