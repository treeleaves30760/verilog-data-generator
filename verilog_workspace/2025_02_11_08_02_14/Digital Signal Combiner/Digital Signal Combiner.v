module tb_combiner;
    // Inputs
    reg in1, in2, in3;
    reg enable, rst_n;
    reg clk;
    
    // Output
    wire out;
    
    // Clock generation
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    // DUT instance
    combiner dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .enable(enable),
        .rst_n(rst_n),
        .clk(clk),
        .out(out)
    );
    
    initial begin
        // Initialize inputs
        in1 = 0;
        in2 = 0;
        in3 = 0;
        enable = 0;
        rst_n = 0;
        
        // Wait for reset to complete
        #10 rst_n = 1;
        
        // Test all combinations of in1, in2, in3
        for (in3 = 0; in3 <= 1; in3++) begin
            for (in2 = 0; in2 <= 1; in2++) begin
                for (in1 = 0; in1 <= 1; in1++) begin
                    // Set enable to test both enabled and disabled states
                    for (enable = 0; enable <= 1; enable++) begin
                        #10;
                        
                        // Calculate expected output
                        if (enable) 
                            logic expected_out = in1 | in2 | in3;
                        else 
                            logic expected_out = dut.ff_out;
                        
                        // Compare actual and expected outputs
                        if (out != expected_out) begin
                            $display("Test failed: in1=%b, in2=%b, in3=%b, enable=%b", 
                                     in1, in2, in3, enable);
                            $display("Expected output: %b, Actual output: %b", 
                                     expected_out, out);
                        end
                    end
                end
            end
        end
        
        // All tests passed
        $display("All tests passed!");
    end
    
endmodule