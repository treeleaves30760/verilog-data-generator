`timescale 1ns / 1ps

module dct_testbench;
    // Clock generation
    localparam CLOCK_PERIOD = 10 ns;
    localparam RESET_DURATION = 3 * CLOCK_PERIOD;

    // Inputs
    reg clk;
    reg rst_n;           // Active-low reset
    reg start;
    reg [511:0] data_in;  // 512 bits (64 elements of 8 bits each)
    reg [511:0] quantization_table;

    // Outputs
    wire done;
    wire [511:0] data_out;

    // DUT instance
    dct_dut dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .data_in(data_in),
        .quantization_table(quantization_table),
        .done(done),
        .data_out(data_out)
    );

    // Clock generator
    always begin
        clk = 1'b0;
        # (CLOCK_PERIOD / 2);
        clk = 1'b1;
        # (CLOCK_PERIOD / 2);
    end

    initial begin
        // Initialize inputs
        rst_n = 1'b0;  // Active-low reset
        start = 1'b0;
        data_in = {512{1'b0}};
        quantization_table = {512{1'b0}};

        // Reset the DUT
        rst_n = 1'b0;
        # (RESET_DURATION);
        rst_n = 1'b1;

        // Test case: Process a matrix with all zeros
        start = 1'b1;
        # (CLOCK_PERIOD);
        start = 1'b0;

        // Wait for processing to complete
        while (!done) begin
            # (CLOCK_PERIOD);
        end

        // Verify the output
        $display("Test case: All-zero input matrix");
        $monitor($format("\nOutput data_out:\n"), 0);
        $monitor($format("%b\n", data_out), 0);
        
        // Success message
        if (data_out == {512{1'b0}}) begin
            $display("Test passed: Correct output for all-zero input");
        end else begin
            $error("Test failed: Unexpected output for all-zero input");
        end

        // Final reset to ensure clean exit
        rst_n = 1'b0;
        # (RESET_DURATION);
        rst_n = 1'b1;

        // End simulation
        $finish;
    end

endmodule