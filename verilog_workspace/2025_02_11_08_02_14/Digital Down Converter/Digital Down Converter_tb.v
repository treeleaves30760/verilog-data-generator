module testbench_digital_down_converter;
    // Define clock period (160 MHz)
    real clock_period = 1 / (160e6);
    
    // Clock generation
    initial begin
        forever begin
            #clock_period;
            clk = ~clk;
        end
    end
    
    // Reset signal
    initial begin
        rst_n = 0;
        #1ns;  // Hold reset for a short period
        rst_n = 1;
    end
    
    // DUT instance
    digital_down_converter dut (
        .input_data(input_data),
        .clk(clk),
        .rst_n(rst_n),
        .sampling_freq(160e6),
        .output_data(output_data),
        .output_valid(output_valid)
    );
    
    // Input signals
    complex input_data;
    wire clk, rst_n, output_valid;
    wire [15:0] output_data;
    
    initial begin
        $display("Digital Down Converter Testbench");
        $display("----------------------------------------");
        
        // Test cases
        integer test_case = 0;
        real amplitude = 1.0;  // Maximum amplitude
        
        // Test case 1: Zero signal
        input_data = complex(0, 0);
        #20ns;
        test_case++;
        
        // Test case 2: Maximum amplitude in-phase only
        input_data = complex(amplitude, 0);
        #20ns;
        test_case++;
        
        // Test case 3: Maximum amplitude quadrature only
        input_data = complex(0, amplitude);
        #20ns;
        test_case++;
        
        // Test case 4: Mix of in-phase and quadrature
        input_data = complex(amplitude/2, amplitude/2);
        #20ns;
        test_case++;
        
        $display("Simulation completed successfully!");
        $finish;
    end
    
    // Monitor output signals
    always @(posedge clk) begin
        if (output_valid) begin
            $display("Output at %t:", $time);
            $display("  Output Data: %b (%h)", output_data, output_data);
        end
    end
endmodule