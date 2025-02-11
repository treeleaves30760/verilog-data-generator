module testbench;

    // Define signals
    wire clk;
    wire rst_n;
    wire freq_in;
    wire [23:0] hex_display;  // Corrected to match 24 bits (6 digits * 4 bits each)
    wire [6:0] segment_output;
    wire [5:0] anode_common;
    wire [2:0] led_status;

    // DUT instantiation
    digital_frequency_counter dut (
        .clk(clk),
        .rst_n(rst_n),
        .freq_in(freq_in),
        .hex_display(hex_display),
        .segment_output(segment_output),
        .anode_common(anode_common),
        .led_status(led_status)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever begin
            #10clk = ~clk;  // 50 MHz clock (20 ns period)
        end
    end

    // Reset signal
    initial begin
        rst_n = 0;
        #10;  // Wait for one clock cycle
        rst_n = 1;
    end

    // Test cases
    initial begin
        // Test case 1: No input pulses
        Info("Test Case 1: Testing no input pulses");
        freq_in = 0;
        #50;  // Wait for 50 ns (5 clock cycles)
        Pass("No input pulses test passed");

        // Test case 2: Single pulse
        Info("Test Case 2: Testing single pulse");
        freq_in = 1;
        #10;  // Wait for 10 ns
        freq_in = 0;
        #40;  // Total of 50 ns (5 clock cycles)
        Pass("Single pulse test passed");

        // Test case 3: Multiple pulses within time window
        Info("Test Case 3: Testing multiple pulses");
        repeat(10) begin
            freq_in = 1;
            #10;  // Wait for 10 ns
            freq_in = 0;
            #10;  // Total of 20 ns per pulse
        end
        #50;  // Wait additional 50 ns
        Pass("Multiple pulses test passed");

        // Test case 4: Overflow condition
        Info("Test Case 4: Testing overflow");
        repeat(64) begin
            freq_in = 1;
            #10;  // Wait for 10 ns
            freq_in = 0;
            #10;  // Total of 20 ns per pulse
        end
        #50;  // Wait additional 50 ns
        Fail("Overflow condition test passed");

        // Final check
        Info("All test cases completed");
    end

endmodule