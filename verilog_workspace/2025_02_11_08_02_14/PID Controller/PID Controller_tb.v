module testbench;
    // Clock generation
    initial begin
        clock = 0;
        forever begin
            #5 clock = ~clock;
        end
    end

    // Input signals
    reg A, B, C_in;

    // Output signals
    wire S, C_out;

    // DUT instantiation
    full_adder dut(
        .A(A),
        .B(B),
        .C_in(C_in),
        .S(S),
        .C_out(C_out)
    );

    initial begin
        // Reset inputs
        A = 0;
        B = 0;
        C_in = 0;
        #10;

        $display("Testing full adder for all possible input combinations:");
        $display("---------------------------------------------");
        $display("| A | B | C_in | Expected S | Expected C_out | Actual S | Actual C_out |");
        $display("---------------------------------------------");

        // Test all possible input combinations
        for (A = 0; A < 2; A = ~A) {
            for (B = 0; B < 2; B = ~B) {
                for (C_in = 0; C_in < 2; C_in = ~C_in) {
                    #10;
                    // Calculate expected sum and carry
                    reg expected_S, expected_C_out;
                    expected_S = (A ^ B ^ C_in);
                    expected_C_out = ((A & B) | (C_in & (A ^ B)));

                    // Wait for the end of the clock cycle before checking outputs
                    #10;
                    
                    if (S == expected_S && C_out == expected_C_out) {
                        $display("| %b | %b | %b | %b | %b | %b | %b |", A, B, C_in, expected_S, expected_C_out, S, C_out);
                        $display("------------------------------------------------");
                        $display("TEST CASE PASSED");
                        $display("---------------------------------------------");
                    } else {
                        $error("TEST CASE FAILED for inputs A=%b, B=%b, C_in=%b", A, B, C_in);
                        $finish;
                    }
                }
            }
        }

        // All tests passed
        $display("All test cases passed successfully!");
        #10;
        $finish;
    end

endmodule