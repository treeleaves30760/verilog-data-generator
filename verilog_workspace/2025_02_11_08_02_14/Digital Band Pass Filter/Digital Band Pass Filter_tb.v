`timescale 1ns / 1ps

module tb_full_adder_4bit;
    // Clock generation
    always begin
        clock = 0;
        #10;
        clock = 1;
        #10;
    end
    
    // Input signals
    reg [3:0] A, B;
    reg C_in;
    
    // Output signals
    wire [3:0] S;
    wire C_out;
    
    // DUT instance
    full_adder_4bit dut (
        .A(A),
        .B(B),
        .C_in(C_in),
        .S(S),
        .C_out(C_out)
    );
    
    initial begin
        // Power-up delays
        #1;
        
        // Test all input combinations
        for (test_case = 0; test_case < 8; test_case++) begin
            A = (test_case >> 2) & 3;
            B = (test_case >> 1) & 2;
            C_in = test_case & 1;
            
            #10;
            
            // Calculate expected sum and carry out
            wire [4:0] expected_sum = A + B + {1, C_in};
            wire expected_carry_out = (A[3] | B[3]) | ((~A[2] & ~B[2]) ? 0 : 1);
            
            #10;
            
            if (S == expected_sum[3:0] && C_out == expected_carry_out) begin
                $display("TEST CASE %d: SUCCESS", test_case);
            end else begin
                $error("TEST CASE %d: FAILURE - Expected S: %b, Actual S: %b; Expected C_out: %b, Actual C_out: %b",
                    test_case,
                    expected_sum[3:0],
                    S,
                    expected_carry_out,
                    C_out);
            end
        end
        
        #1;
        $display("TEST BENCH COMPLETED SUCCESSFULLY");
    end
endmodule