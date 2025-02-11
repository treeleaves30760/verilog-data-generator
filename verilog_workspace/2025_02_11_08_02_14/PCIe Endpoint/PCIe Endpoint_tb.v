module tb_full_adder_2bit;
    // Clock generation
    localparam CLOCK_PERIOD = 10;
    localparam SETTLE_TIME = 10;

    // Inputs
    reg a, b, c_in;
    wire s, c_out;

    // Clock signal
    reg clock;
    initial begin
        clock = 0;
        forever begin
            #CLOCK_PERIOD;
            clock = ~clock;
        end
    end

    // Testbench setup
    initial begin
        a = 0;
        b = 0;
        c_in = 0;

        // Wait for settling time
        #SETTLE_TIME;

        // Test all combinations of A, B, C_in (8 cases)
        integer test_case;
        for (test_case = 0; test_case < 8; test_case++) begin
            // Calculate expected sum and carry out
            reg expected_s, expected_c_out;
            {expected_s, expected_c_out} = 
                {a ^ b ^ c_in, (a & b) | (a & c_in) | (b & c_in)};

            // Apply inputs at the start of a clock cycle
            #0;
            a = test_case[1:0];
            b = test_case[2:1];
            c_in = test_case[3];

            // Wait for two clock cycles to allow outputs to stabilize
            #CLOCK_PERIOD * 2;

            // Check results
            if (s == expected_s && c_out == expected_c_out) begin
                $display("Test case %d: Success!", test_case);
                $display("Inputs: A=%b, B=%b, C_in=%b", a, b, c_in);
                $display("Outputs: S=%b, C_out=%b", s, c_out);
            end else begin
                $display("Test case %d: Failure!", test_case);
                $display("Inputs: A=%b, B=%b, C_in=%b", a, b, c_in);
                $display("Expected: S=%b, C_out=%b", expected_s, expected_c_out);
                $display("Observed:  S=%b, C_out=%b", s, c_out);
            end

            // Add delay between test cases
            #10;
        end

        // Wait for some time before stopping
        #100;
        $stop;
    end

endmodule