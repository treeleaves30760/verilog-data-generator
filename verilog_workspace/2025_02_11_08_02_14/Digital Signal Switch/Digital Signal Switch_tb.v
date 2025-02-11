module tb_mux_2to1;
    // Define inputs and outputs
    reg IN_A, IN_B, SEL, RST;
    wire OUT, CLK;

    // Clock generation
    always begin
        CLK = 0;
        #10ns;  // Wait for half the period to toggle clock
        CLK = 1;
        #10ns;  // Wait for the other half of the period
        CLK = 0;
    end

    initial begin
        // Reset the DUT
        RST = 1;
        IN_A = 0;
        IN_B = 0;
        SEL = 0;

        // Apply reset for one clock cycle
        #20ns RST = 0;

        // Test all combinations of IN_A, IN_B, and SEL
        for (IN_A = 0; IN_A < 2; IN_A++) begin
            for (IN_B = 0; IN_B < 2; IN_B++) begin
                for (SEL = 0; SEL < 2; SEL++) begin
                    // Wait for setup time before clock edge
                    #1ns;
                    // Apply inputs
                    IN_A;
                    IN_B;
                    SEL;

                    // Wait for hold time after clock edge
                    #2ns;

                    // Expected output calculation
                    wire expected_out = (SEL == 0) ? IN_A : IN_B;

                    // Wait for next clock cycle to ensure output has propagated
                    #10ns;

                    // Check actual output
                    if (OUT != expected_out) begin
                        $display("FAIL: IN_A=%b, IN_B=%b, SEL=%b, OUT Expected:%b, Actual:%b", 
                                 IN_A, IN_B, SEL, expected_out, OUT);
                        $stop;
                    end else begin
                        $display("PASS: IN_A=%b, IN_B=%b, SEL=%b, OUT=%b", 
                                 IN_A, IN_B, SEL, OUT);
                    end

                    // Wait for next clock cycle before next test case
                    #10ns;
                end
            end
        end

        // All tests passed
        $display("ALL TEST CASES PASSED");
        $finish;
    end

endmodule