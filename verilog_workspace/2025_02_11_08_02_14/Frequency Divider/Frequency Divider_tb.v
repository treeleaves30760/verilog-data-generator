module testbench;
    // Inputs
    wire clk;
    wire rst;
    wire incr;  // Increment button
    wire decr;  // Decrement button
    
    // Output
    wire [3:0] count;
    
    // Clock generation
    always begin
        clk = 1'b1;
        #5ns;
        clk = 1'b0;
        #5ns;
    end
    
    initial begin
        rst = 1'b1;  // Reset initially held high
        incr = 1'b0;
        decr = 1'b0;
        
        // Wait for one clock cycle to ensure reset is properly applied
        #10ns;
        rst = 1'b0;
    end
    
    initial begin
        $display("Starting counter testbench simulation...");
        $monitor(clk, rst, incr, decr, count);
    end
    
    // Test all possible input combinations
    for (incr = 0; incr < 2; incr++) 
        for (decr = 0; decr < 2; decr++) 
            begin
                #10ns;
                $display("Testing incr=%b, decr=%b", incr, decr);
                incr <= incr;
                decr <= decr;
                #10ns;
                
                // Check if count changes as expected
                if (incr && !decr) 
                    assert(count != 0) $display("Success: Count incremented correctly");
                else if (!incr && decr)
                    assert(count != 0) $display("Failure: Count did not decrement when expected");
                else if (!incr && !decr)
                    assert($count == 0) $display("Success: Count remains same with no input");
            end
    
    final begin
        $display("\nSimulation completed successfully!");
    end
endmodule