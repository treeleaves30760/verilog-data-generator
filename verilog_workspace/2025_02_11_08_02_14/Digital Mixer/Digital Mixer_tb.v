module tb_full_adder_2bit;
    // Clock generation
    always begin
        clock = 0;
        #5ns;
        clock = 1;
        #5ns;
    end

    initial begin
        // Reset signals and inputs
        a = 0;
        b = 0;
        c_in = 0;
        
        $display("Starting full adder testbench...");
        success = 1;

        // Test all combinations of A, B, C_in (0 to 7)
        for (test_case = 0; test_case < 8; test_case++) begin
            {a, b, c_in} = test_case;
            
            // Wait for positive edge of clock to ensure setup
            @(posedge clock);
            wait(2ns);  // Allow some propagation delay
            
            // Calculate expected sum and carry
            sum_expected = (a ^ b ^ c_in);
            carry_expected = (a & b) | (a & c_in) | (b & c_in);

            // Compare actual outputs with expected values
            if (sum != sum_expected || carry_out != carry_expected) begin
                $display("Failure: Test case %d", test_case);
                $display("A=%d, B=%d, C_in=%d", a, b, c_in);
                $display("Expected S=%d, C_out=%d; Actual S=%d, C_out=%d",
                         sum_expected, carry_expected, sum, carry_out);
                success = 0;
            end
        end

        // Final test result
        if (success) begin
            $display("\nAll test cases passed successfully!");
        end else begin
            $display("\nTestbench failed. See above for details.");
        end
        
        // Stop simulation after testing
        #1ns;
        $stop;
    end

    // DUT ports
    input a, b, c_in;
    output sum, carry_out;

    // Clock signal
    wire clock;
    
    // Reset signal (not used in this testbench)
    wire reset;

endmodule