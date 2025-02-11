`timescale 1ns / 1ps

module tb_counter;
    // Inputs
    reg clk;
    reg rst;
    reg en;
    
    // Output
    wire [3:0] count;
    
    // DUT instance
    counter uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .count(count)
    );
    
    // Clock generation
    always begin
        clk = 0; #10ns;
        clk = 1; #10ns;
    end
    
    initial begin
        rst = 1;  // Apply reset for two clock cycles
        en = 0;
        #20ns rst = 0;
        #20ns rst = 1;
        #20ns rst = 0;
        
        // Test cases
        #40ns en = 1;
        #20ns en = 0;
        #20ns en = 1;
        #20ns en = 0;
        #20ns en = 1;
        
        forever begin
            #20ns $display("_clk: %b, rst: %b, en: %b, count: %4b", clk, rst, en, count);
        end
        
        // Success message
        $info("All test cases passed successfully");
    end
    
    // Reset assertion
    initial begin
        #0ns assert(rst) else $error("Reset is not asserted at the beginning");
    end
    
    // Check enable functionality
    initial begin
        #40ns if(en != 1) $error("Enable signal was not set after reset");
    end
    
    // Check maximum count
    always @(posedge clk) begin
        if(count == 4'b1111 && !rst && !en) $error("Counter exceeded max value without reset/enable");
    end
    
    // Check increment behavior
    always @(posedge clk) begin
        if(en && count != (count + 1)) $error("Counter failed to increment when enabled");
    end
endmodule