`timescale 1ns / 1ps

module demodulator_testbench;
    // Clock generation
    localparam CLOCK_FREQ = 10 MHz;
    localparam PERIOD = 1 / CLOCK_FREQ;

    reg clock;
    initial begin
        clock = 0;
        forever #PERIOD/2 clock = ~clock;
    end

    // Input and output signals
    reg [15:0] input_signal;
    wire [15:0] output_signal;

    // Demodulator instance under test
    demodulator dut (
        .clk(clock),
        .rst(0),  // No reset functionality in this testbench
        .input(input_signal),
        .output(output_signal)
    );

    // Test cases and verification
    initial begin
        $display("Demodulator Testbench");
        $display("------------------------");

        // Initialize input and output vectors
        reg [15:0] input_vector [0:2^16-1];
        wire [15:0] expected_output [0:2^16-1];

        // Populate test cases with specific values
        input_vector[0] = 16'h0000;
        expected_output[0] = 16'h0000;

        input_vector[1] = 16'hFFFF;
        expected_output[1] = 16'h0001;

        // Continue populating test cases as needed...

        $display("Starting tests...");
        #10ns;  // Wait for initial setup

        for (int i = 0; i < 2^16; i++) begin
            input_signal = input_vector[i];
            #5ns;
            if (output_signal != expected_output[i]) begin
                $display("Failure: Test %d - Output mismatch", i);
                $finish;
            end
        end

        $display("Demodulator Testbench: All Tests Passed!");
    end
endmodule