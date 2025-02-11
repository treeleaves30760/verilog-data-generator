module digital_diff_testbench;
    // Define signals
    reg clk, rst, data_in;
    wire diff_out, valid;

    // Instantiate the DUT
    digital_diff dut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .diff_out(diff_out),
        .valid(valid)
    );

    // Generate clock
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    // Reset and input generation
    initial begin
        rst = 1;
        data_in = 0;
        #2; // Wait for two time units to ensure reset is applied
        rst = 0;

        // Test all combinations of data_in (0 and 1)
        for (data_in in {0, 1}) {
            repeat(2) {
                #4; // Wait for two clock cycles to capture changes
                $display("Current data_in: %b", data_in);
                $display("Current diff_out: %b, valid: %b", diff_out, valid);
            }
        }

        // Final check after test cases
        if ($test$pass) {
            $display("All tests passed successfully!");
        } else {
            $display("Test failed. Check simulation for details.");
        }
    end

endmodule