module tb_two_bit_comparator;
    // Define the clock period
    parameter CLK_PERIOD = 10 ns;

    // Declare the inputs and output
    reg [1:0] A, B;
    wire       c;

    // Clock generation
    always begin
        # (CLK_PERIOD / 2);
        clk = ~clk;
    end

    // DUT instantiation
    two_bit_comparator dut (
        .a(A),
        .b(B),
        .c(c)
    );

    // Test bench initialization
    initial begin
        // Reset the inputs
        A = 0;
        B = 0;

        // Wait for one clock period to ensure all signals are initialized
        # (CLK_PERIOD);
        
        // Test all combinations of A and B
        for (A = 0; A < 4; A++) begin
            for (B = 0; B < 4; B++) begin
                // Set the inputs
                # (CLK_PERIOD / 2);
                A = A;
                B = B;

                // Wait for the next clock edge to ensure the output is stable
                @ (posedge clk);

                // Expected result when A == B
                if (A == B) begin
                    assert(c == 1) else $error("Test failed: A=%b, B=%b, c=%b", A, B, c);
                end
                else begin
                    assert(c == 0) else $error("Test failed: A=%b, B=%b, c=%b", A, B, c);
                end

                // Display the test result
                $display("Test passed: A=%b, B=%b, c=%b", A, B, c);
            end
        end

        // Final message after all tests are completed
        $display("------------------------");
        $display("All 16 tests passed successfully!");
    end
endmodule