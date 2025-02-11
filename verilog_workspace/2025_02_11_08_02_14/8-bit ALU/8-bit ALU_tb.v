module alu_testbench;
    reg A, B;
    reg [1:0] op_mode;
    reg rst, clk;
    
    wire result, z, co, ov, n;
    
    // Include your ALU module here
    ALU uut (
        .A(A),
        .B(B),
        .op_mode(op_mode),
        .rst(rst),
        .clk(clk),
        .result(result),
        .z(z),
        .co(co),
        .ov(ov),
        .n(n)
    );
    
    // Initialize testbench
    initial begin
        rst = 1;
        clk = 0;
        
        // Wait for one clock cycle to reset the ALU
        #10 rst = 0;
        
        // Generate all possible combinations of A, B, and op_mode
        for (A = 0; A < 256; A++) {
            for (B = 0; B < 256; B++) {
                for (op_mode = 0; op_mode < 4; op_mode++) {
                    // Toggle clock to allow ALU to compute
                    #10 clk = ~clk;
                    
                    // Calculate expected result and flags based on op_mode
                    case (op_mode)
                        0: begin
                            // Add operation
                            expected_result = A + B;
                            expected_z = (A + B == 0) ? 1 : 0;
                            expected_co = (A + B > 255) ? 1 : 0;
                            expected_ov = ((A & B) | (~A ^ ~B)) ? 1 : 0; // Overflow for addition
                            expected_n = (expected_result >> 7) & 1;
                        end
                        1: begin
                            // Subtract operation
                            expected_result = A - B;
                            expected_z = (A - B == 0) ? 1 : 0;
                            expected_co = (A < B) ? 1 : 0; // Borrow for subtraction
                            expected_ov = ((~A & B) | (~B & ~A)) ? 1 : 0; // Overflow for subtraction
                            expected_n = (expected_result >> 7) & 1;
                        end
                        2: begin
                            // AND operation
                            expected_result = A & B;
                            expected_z = (expected_result == 0) ? 1 : 0;
                            expected_co = 0; // No carry in AND operation
                            expected_ov = 0; // No overflow in AND operation
                            expected_n = (expected_result >> 7) & 1;
                        end
                        3: begin
                            // OR operation
                            expected_result = A | B;
                            expected_z = (expected_result == 0) ? 1 : 0;
                            expected_co = 0; // No carry in OR operation
                            expected_ov = 0; // No overflow in OR operation
                            expected_n = (expected_result >> 7) & 1;
                        end
                    endcase
                    
                    // Compare actual and expected results
                    if (result != expected_result) {
                        $display("Failure: A=%d, B=%d, op_mode=%b", A, B, op_mode);
                        $display("Actual result: %d, Expected result: %d", result, expected_result);
                    }
                    
                    // Check flags
                    if (z != expected_z) {
                        $display("Mismatch: Z flag not as expected for A=%d, B=%d, op_mode=%b", A, B, op_mode);
                    }
                    if (co != expected_co) {
                        $display("Mismatch: CO flag not as expected for A=%d, B=%d, op_mode=%b", A, B, op_mode);
                    }
                    if (ov != expected_ov) {
                        $display("Mismatch: OV flag not as expected for A=%d, B=%d, op_mode=%b", A, B, op_mode);
                    }
                    if (n != expected_n) {
                        $display("Mismatch: N flag not as expected for A=%d, B=%d, op_mode=%b", A, B, op_mode);
                    }
                }
            }
        }
        
        // Terminate simulation
        #10 $finish;
    end
endmodule