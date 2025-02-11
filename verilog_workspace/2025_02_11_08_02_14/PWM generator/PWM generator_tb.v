module tb_mux_4_1;
    // Define local parameters
    localparam CLOCK_PERIOD = 10;  // Clock period in time units
    localparam DATA_WIDTH = 1;     // Data width of inputs
    
    // Declare input and output signals
    reg clk, rst;
    reg s0, s1;
    reg d0, d1, d2, d3;
    wire y;
    
    // DUT instance
    mux_4_1 dut (
        .clk(clk),
        .rst(rst),
        .s0(s0),
        .s1(s1),
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .y(y)
    );
    
    // Clock generation
    always begin
        clk = 0;
        # (CLOCK_PERIOD / 2);
        clk = 1;
        # (CLOCK_PERIOD / 2);
    end
    
    initial begin
        // Initialize testbench signals
        rst = 0;
        s0 = 0;
        s1 = 0;
        d0 = 0;
        d1 = 0;
        d2 = 0;
        d3 = 0;
        
        // Reset assertion after 5 time units
        #5;
        rst = 1;
        
        // Test all input combinations
        for (s1 = 0; s1 < 2; s1++) begin
            for (s0 = 0; s0 < 2; s0++) begin
                for (d3 = 0; d3 < 2; d3++) begin
                    for (d2 = 0; d2 < 2; d2++) begin
                        for (d1 = 0; d1 < 2; d1++) begin
                            for (d0 = 0; d0 < 2; d0++) begin
                                #20;
                                rst = 0;
                                
                                // Wait for signals to stabilize
                                #CLOCK_PERIOD;
                                
                                // Calculate expected output based on control signals
                                reg expected_y = (s1 == 0 && s0 == 0) ? d0 :
                                                (s1 == 0 && s0 == 1) ? d1 :
                                                (s1 == 1 && s0 == 0) ? d2 :
                                                d3;
                                
                                // Check if output matches expected value
                                if (y != expected_y) begin
                                    $display("Failure: S1=%b, S0=%b, D0=%b, D1=%b, D2=%b, D3=%b, Y=%b",
                                         s1, s0, d0, d1, d2, d3, y);
                                    $stop;
                                end else begin
                                    $display("Success: S1=%b, S0=%b, D0=%b, D1=%b, D2=%b, D3=%b, Y=%b",
                                         s1, s0, d0, d1, d2, d3, y);
                                end
                                
                                // Add delay before next test case
                                #20;
                            end
                        end
                    end
                end
            end
        end
        
        // Final stop after all tests
        $stop;
    end
    
endmodule