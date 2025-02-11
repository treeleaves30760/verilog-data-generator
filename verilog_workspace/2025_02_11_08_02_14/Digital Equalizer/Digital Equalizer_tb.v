`timescale 1ns / 1ps

module DigitalEqualizer_tb;
    // Define clock frequencies (48 MHz and 96 MHz)
    parameter CLOCK_FREQ_48MHZ = 20.8333333333 ns;
    parameter CLOCK_FREQ_96MHZ = 10.4166666667 ns;

    // Clock selection (comment out the ones not needed)
    //parameter CLOCK_FREQUENCY = CLOCK_FREQ_48MHZ;
    parameter CLOCK_FREQUENCY = CLOCK_FREQ_96MHZ;

    // Test data patterns
    parameter TEST_DATA_ZERO = 16'h0000;
    parameter TEST_DATA_MAX = 16'hFFFF;
    parameter TEST_DATA_MID = 16'h7FFF;

    // DUT instance
    DigitalEqualizer dut (
        .SCK(SCK),
        .SFS(SFS),
        .D(D),
        .LR(LR),
        .D_out(D_out),
        .EQ_out(EQ_out)
    );

    // Clock generation
    always begin
        SCK = 0;
        # (CLOCK_FREQUENCY / 2);
        SCK = 1;
        # (CLOCK_FREQUENCY / 2);
        SCK = 0;
    end

    // Frame sync generation (assuming 32-bit frame)
    always begin
        SFS = 0;
        # (CLOCK_FREQUENCY * 32/16);  // Adjust pulse width and period as needed
        SFS = 1;
        # (CLOCK_FREQUENCY / 4);
        SFS = 0;
    end

    // Reset generation
    initial begin
        reset = 1;
        # 10;
        reset = 0;
    end

    // Test cases implementation
    integer test_case;
    reg [15:0] input_data;
    reg bypass_enable;

    initial begin
        test_case = 0;
        input_data = TEST_DATA_ZERO;
        bypass_enable = 1;  // Enable bypass for the first test case
        # 10;
        $display("Starting DigitalEqualizer Testbench");
        forever begin
            # (CLOCK_FREQUENCY * 2);  // Wait for two clock periods
            test_case++;
            case (test_case)
                1: begin
                    input_data = TEST_DATA_MAX;
                    bypass_enable = 0;  // Disable bypass to apply equalization
                    $display("Test Case 1: Input Data = %h, Bypass Enable = %b", input_data, bypass_enable);
                end
                2: begin
                    input_data = TEST_DATA_MID;
                    bypass_enable = 1;  // Re-enable bypass
                    $display("Test Case 2: Input Data = %h, Bypass Enable = %b", input_data, bypass_enable);
                end
                3: begin
                    input_data = $random;
                    bypass_enable = 0;  // Random data with equalization
                    $display("Test Case 3: Random Input Data = %h, Bypass Enable = %b", input_data, bypass_enable);
                end
            endcase
        end
    end

    // Drive inputs to the DUT
    always @(posedge SCK) begin
        D <= input_data;
        LR <= (test_case == 1 || test_case == 2);  // Stereo/mono control
        bypass_enable <= (bypass_enable ? 1 : $random % 2);
    end

    // Monitor outputs and verify correctness
    always @(posedge SCK) begin
        if (EQ_out != 5'b00000 || D_out != input_data) begin
            $display("Failure: EQ_out = %b, D_out = %h", EQ_out, D_out);
            $finish;
        end
    end

endmodule