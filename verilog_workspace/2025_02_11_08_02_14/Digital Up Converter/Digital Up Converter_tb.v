module tb_duc;

    // Define clock frequencies (you can adjust these values as needed)
    localparam CLOCK_FREQ = 100 MHz;
    localparam CARRIER_CLOCK_FREQ = 40 MHz;

    // Declare signals for testing
    reg i_signal, q_signal;
    wire sys_clk, carrier_clk, valid, empty;
    wire [15:0] rf_output;

    // Clock generation blocks
    initial begin
        sys_clk = 0;
        forever # (CLOCK_FREQ / 2) sys_clk = ~sys_clk;
    end

    initial begin
        carrier_clk = 0;
        forever # (CARRIER_CLOCK_FREQ / 2) carrier_clk = ~carrier_clk;
    end

    // DUT instantiation
    Duc dut (
        .i_signal(i_signal),
        .q_signal(q_signal),
        .sys_clk(sys_clk),
        .carrier_clk(c_carrier_clk),
        .valid(valid),
        .empty(empty),
        .rf_output(rf_output)
    );

    // Test cases setup
    initial begin
        // Reset the DUC
        i_signal = 0;
        q_signal = 0;
        reset_duc();

        // Define test vectors
        reg [15:0] test_cases[4][2];
        test_cases[0] = '{0, 0};          // All zeros
        test_cases[1] = '{0xFFFF, 0};     // Maximum I signal
        test_cases[2] = '{0, 0xFFFE};     // Near maximum Q signal
        test_cases[3] = '{0x8000, 0x8000}; // Mid-scale I and Q signals

        // Iterate through each test case
        for (int i = 0; i < 4; i++) begin
            // Apply the current test case
            i_signal = test_cases[i][0];
            q_signal = test_cases[i][1];

            // Wait for one clock cycle to ensure signals are stable
            #CLOCK_FREQ;

            // Check if valid signal is asserted
            if (!valid) begin
                $display("FAIL: Valid signal not asserted after setting inputs.");
                $finish;
            end

            // Wait for empty signal to be asserted
            wait_for_empty();

            // Capture and verify RF output
            capture_and_verify_rf_output(test_cases[i]);
        end

        // All test cases passed
        $display("INFO: All test cases passed successfully.");
        $finish;
    end

    // Helper function to reset the DUC
    task reset_duc();
        sys_clk = 0;
        carrier_clk = 0;
        i_signal = 0;
        q_signal = 0;
        #CLOCK_FREQ;
    endtask

    // Helper function to wait for empty signal
    task wait_for_empty();
        @ (posedge carrier_clk)
            if (!empty) begin
                $display("FAIL: Empty signal not asserted after conversion.");
                $finish;
            end
    endtask

    // Helper function to capture and verify RF output
    task capture_and_verify_rf_output(reg [15:0] expected_rf);
        @ (posedge carrier_clk)
            if (rf_output != expected_rf) begin
                $display("FAIL: RF Output mismatch. Expected %h, Got %h.", expected_rf, rf_output);
                $finish;
            end
    endtask

endmodule