module testbench;
    // Clock generation
    always begin
        clock = 0;
        #5;
        clock = 1;
        #5;
    end

    // Test cases for full_adder_4bit
    initial begin
        // Reset inputs
        A = 0;
        B = 0;
        C_in = 0;
        #20;  // Wait for two clock cycles
        
        // Test case 1: A=0 (0000), B=0 (0000), C_in=0
        A = 0;
        B = 0;
        C_in = 0;
        #10;
        if (S == 0 & C_out == 0) $display("Test 1: Success"); else $display("Test 1: Failed - S=%d, C_out=%d", S, C_out);
        
        // Test case 2: A=1 (0001), B=0 (0000), C_in=0
        A = 1;
        B = 0;
        C_in = 0;
        #10;
        if (S == 1 & C_out == 0) $display("Test 2: Success"); else $display("Test 2: Failed - S=%d, C_out=%d", S, C_out);
        
        // Test case 3: A=0 (0000), B=1 (0001), C_in=0
        A = 0;
        B = 1;
        C_in = 0;
        #10;
        if (S == 1 & C_out == 0) $display("Test 3: Success"); else $display("Test 3: Failed - S=%d, C_out=%d", S, C_out);
        
        // Test case 4: A=1 (0001), B=1 (0001), C_in=0
        A = 1;
        B = 1;
        C_in = 0;
        #10;
        if (S == 0 & C_out == 1) $display("Test 4: Success"); else $display("Test 4: Failed - S=%d, C_out=%d", S, C_out);
        
        // Test case 5: A=2 (0010), B=3 (0011), C_in=0
        A = 2;
        B = 3;
        C_in = 0;
        #10;
        if (S == 1 & C_out == 1) $display("Test 5: Success"); else $display("Test 5: Failed - S=%d, C_out=%d", S, C_out);
        
        // Test case 6: A=4 (0100), B=5 (0101), C_in=1
        A = 4;
        B = 5;
        C_in = 1;
        #10;
        if (S == 0 & C_out == 1) $display("Test 6: Success"); else $display("Test 6: Failed - S=%d, C_out=%d", S, C_out);
        
        // Test case 7: A=7 (0111), B=8 (1000), C_in=0
        A = 7;
        B = 8;
        C_in = 0;
        #10;
        if (S == 15 & C_out == 1) $display("Test 7: Success"); else $display("Test 7: Failed - S=%d, C_out=%d", S, C_out);
        
        // Test case 8: A=15 (1111), B=0 (0000), C_in=1
        A = 15;
        B = 0;
        C_in = 1;
        #10;
        if (S == 14 & C_out == 1) $display("Test 8: Success"); else $display("Test 8: Failed - S=%d, C_out=%d", S, C_out);
        
        // Test case 9: A=9 (1001), B=6 (0110), C_in=0
        A = 9;
        B = 6;
        C_in = 0;
        #10;
        if (S == 15 & C_out == 0) $display("Test 9: Success"); else $display("Test 9: Failed - S=%d, C_out=%d", S, C_out);
        
        // Test case 10: A=3 (0011), B=4 (0100), C_in=1
        A = 3;
        B = 4;
        C_in = 1;
        #10;
        if (S == 7 & C_out == 1) $display("Test 10: Success"); else $display("Test 10: Failed - S=%d, C_out=%d", S, C_out);
        
        // Final reset
        A = 0;
        B = 0;
        C_in = 0;
        #10;
    end

    // Input signals
    output reg clock;
    input wire [3:0] A;
    input wire [3:0] B;
    input wire C_in;
    
    // Output signals
    output wire [3:0] S;
    output wire C_out;
endmodule