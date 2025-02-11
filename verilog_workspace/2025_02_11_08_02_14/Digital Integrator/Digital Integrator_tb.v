module testbench;
    // Define clock frequency (10 units per cycle)
    timeprecision 1ns;
    timeunits 1ns = 1s/10;

    // Inputs
    reg clk;
    reg rst;
    reg [15:0] in_data;
    
    // Output
    wire [15:0] out_integrated;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Toggle clock every 10 units
    end
    
    // Reset signal
    initial begin
        rst = 1;
        #20 rst = 0; // Keep reset active for two clock periods
    end
    
    // Testbench main
    initial begin
        $display("Digital Integrator Testbench");
        $display("----------------------------------------");
        
        // Loop through all possible input combinations
        for (in_data = 0; in_data < 65536; in_data++) begin
            #10;
            clk = 0;
            rst = 0;
            in_data <= in_data;
            
            // Wait two clock periods to allow the module to settle
            #20;
            
            // Calculate expected result based on trapezoidal rule
            integer expected_result;
            expected_result = (in_data + previous_in_data) * 10 / 2;
            
            if (out_integrated == expected_result) begin
                $display("Pass: Input %h -> Output %h", in_data, out_integrated);
            end else begin
                $display("Fail: Input %h -> Expected %h, Actual %h", 
                         in_data, expected_result, out_integrated);
                $finish;
            end
            
            // Store current input for next iteration
            previous_in_data = in_data;
        end
        
        $display("All tests passed!");
        #2;
        $finish;
    end
    
    // Storage for previous input value
    reg [15:0] previous_in_data;
    
endmodule