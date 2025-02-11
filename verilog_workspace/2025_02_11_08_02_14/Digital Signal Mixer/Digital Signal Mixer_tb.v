module tb_full_adder;
    // Define inputs and outputs
    reg        clock;
    reg [1:0]  A, B;
    reg        C_in;
    wire [1:0] S;
    wire       C_out;

    // Clock generation
    always begin
        clock = 1; #5;
        clock = 0; #5;
    end

    // DUT instantiation
    full_adder dut (
        .A(A),
        .B(B),
        .C_in(C_in),
        .S(S),
        .C_out(C_out)
    );

    initial begin
        // Test all combinations of A, B, and C_in
        for (a in 0..1) begin
            for (b in 0..1) begin
                for (c_in in 0..1) begin
                    // Assign inputs
                    A = a;
                    B = b;
                    C_in = c_in;

                    // Wait for one clock period to allow propagation
                    #1;

                    // Calculate expected sum and carry-out
                    wire expected_S = (a ^ b ^ c_in);
                    wire expected_C_out = (a & b) | (a & c_in) | (b & c_in);

                    // Compare actual outputs with expected values
                    if ({S, C_out} != {expected_S, expected_C_out}) begin
                        $display("Test case failed: A=%d, B=%d, C_in=%d", a, b, c_in);
                        $display("Expected S=%d, C_out=%d; Actual S=%d, C_out=%d",
                                 expected_S, expected_C_out, S, C_out);
                        $finish;
                    end
                end
            end
        end

        // All test cases passed
        $display("All test cases passed successfully!");
        $finish;
    end
endmodule