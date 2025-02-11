module tb_ula;

    // Define the period for the clock signal
    parameter CLOCK_PERIOD = 10 ns;
    
    // Generate a clock signal
    generate
        clock clk(
            .clk     (),
            .rst     (),
            .CLOCK_PERIOD(CLOCK_PERIOD)
        );
    endgenerate

    // Reset signal
    reg n_rst;

    // DUT inputs and outputs
    wire [1:0] A, B;
    wire [1:0] C_in;
    wire [1:0] Sum;
    wire [1:0] C_out;

    // Instantiate the ULA module under test
    ula dut (
        .A(A),
        .B(B),
        .C_in(C_in),
        .Sum(Sum),
        .C_out(C_out),
        .n_rst(n_rst)
    );

    // Clock and reset control
    initial begin
        n_rst = 0;  // Active low reset
        #10ns;
        n_rst = 1;  // Release reset
    end

    // Test cases for A, B, C_in
    reg [5:0] test_cases;

    always @(posedge clk.clk) begin
        if (test_cases < 64) begin
            // Extract each bit from the test_cases variable
            wire [1:0] a = (test_cases >> 4) & 2'b11;
            wire [1:0] b = (test_cases >> 2) & 2'b11;
            wire [1:0] c_in = test_cases & 2'b11;

            // Set A, B, and C_in for each bit
            A <= a;
            B <= b;
            C_in <= c_in;

            // Calculate expected Sum and C_out for each bit
            reg [1:0] expected_sum;
            reg [1:0] expected_cout;

            // For each bit i (0 and 1)
            genvar i;
            generate
                for (i = 0; i < 2; i++) begin : compute_expected
                    wire a_bit = a[i];
                    wire b_bit = b[i];
                    wire c_in_bit = c_in[i];

                    // Full adder logic for sum and carry-out
                    expected_sum[i] = a_bit ^ b_bit ^ c_in_bit;
                    expected_cout[i] = (a_bit & b_bit) | ((a_bit ^ b_bit) & c_in_bit);
                end
            endgenerate

            // Wait one clock cycle to ensure all signals are stable
            #CLOCK_PERIOD;

            // Compare actual outputs with expected values
            if ({Sum, C_out} != {expected_sum, expected_cout}) begin
                $display("Test case %d failed:", test_cases);
                $display("A = %b, B = %b, C_in = %b", a, b, c_in);
                $display("Expected Sum: %b, Expected C_out: %b", expected_sum, expected_cout);
                $display("Actual Sum: %b, Actual C_out: %b", Sum, C_out);
                $stop;
            end

            // Move to the next test case
            test_cases++;
        end
    end

endmodule