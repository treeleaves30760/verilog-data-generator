module testbench_analyzer;
    // Define clock frequency (50 MHz to 100 MHz)
    parameter CLOCK_FREQ = 100 MHz;  // Example: 100 MHz
    
    // Generate clock signal
    generate_clock(CLK, CLOCK_FREQ);
    
    // Reset signal handling
    reg rst;
    initial begin
        rst = 1;
        #50ns;
        rst = 0;
    end

    // Test cases
    test_case tc();
    
endmodule