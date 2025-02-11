module digital_signal_demodulator_testbench;
    // Define inputs and outputs
    reg             clock;
    reg             reset_n;
    reg             modulated_data_in;
    
    wire            demodulated_data_out;
    wire            error_flag;
    wire            lock;

    // Clock generation
    initial begin
        clock = 0;
        forever #10ns clock = ~clock;  // 100 MHz clock
    end

    // Reset generation
    initial begin
        reset_n = 0;
        #20ns;  // Wait for two full clock cycles
        reset_n = 1;
    end

    // Testbench logic
    initial begin
        $display("Digital Signal Demodulator Testbench");
        $display("----------------------------------------");
        
        // Test case 1: Basic synchronization with data=0
        #20ns; modulated_data_in = 0;       $display("Test Case 1: Testing basic synchronization with data=0");
        #20ns; modulated_data_in = 1;       $display("Test Case 2: Testing basic synchronization with data=1");
        
        // Test case 3: Error detection under noise conditions
        #20ns; modulated_data_in = $random; $display("Test Case 3: Random input to test error detection");
        
        // Test case 4: Lock assertion after valid frames
        #20ns; modulated_data_in = 0;       $display("Test Case 4: Testing lock assertion with stable data=0");
        #20ns; modulated_data_in = 1;       $display("Test Case 5: Testing lock assertion with stable data=1");
        
        // Monitor outputs
        @(posedge clock) disable reset_n;
        wait_for_clock(10); // Wait for 10 clock cycles
        
        if (lock == 1 && error_flag == 0) 
            $display("Success: Demodulator locked onto signal with no errors");
        else 
            $display("Failure: Demodulator failed to lock or encountered errors");
        
        #5ns; $finish;
    end

    // Helper function for timing
    function wait_for_clock(input integer cycles);
        repeat (cycles) @(posedge clock);
    endfunction

endmodule