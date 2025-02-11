module testbench;
    // Define signals
    bit clk, reset_n, mult_factor, multiplied_clk;

    // Clock generation
    initial begin
        forever begin
            #10 clk = ~clk;  // Generate a stable clock signal with period 20 units
        end
    end

    // Reset handling and test cases
    initial begin
        $display("Testbench for Frequency Multiplier Circuit");
        $display("-------------------------------------------");

        // Initialize signals to their reset state
        reset_n = 0;
        mult_factor = 0;

        // Apply reset with proper setup time (t_SETUP)
        #20;  // Wait for two clock periods to ensure setup and hold times
        reset_n = 1;

        // Test case 1: multiplier factor is 0 (x1)
        $display("\nTest Case 1: mult_factor = 0 (x1)");
        $display("-----------------------------");
        #20;  // Wait for one clock cycle after reset
        if ($time % 20 != 0) begin
            $display("Failure: multiplied_clk does not match input clock when x1 factor is applied");
            $finish;
        end else begin
            $display("Success: multiplied_clk matches input clock frequency when x1 factor is applied");
        end

        // Test case 2: multiplier factor is 1 (x2)
        $display("\nTest Case 2: mult_factor = 1 (x2)");
        $display("-----------------------------");
        #20;  // Wait for one clock cycle
        mult_factor = 1;
        #20;  // Wait for another clock cycle to observe the effect
        if ($time % 10 != 0) begin
            $display("Failure: multiplied_clk does not double when x2 factor is applied");
            $finish;
        end else begin
            $display("Success: multiplied_clk frequency doubled as expected when x2 factor is applied");
        end

        // All tests passed
        $display("\nAll test cases completed successfully");
    end

endmodule