`timescale 1ns / 1ps

module digital_calculator_testbench;
    // Inputs
    reg [9:0] switch;          // Number switches (0-9)
    reg op_add, op_sub;        // Operation buttons
    reg clock, reset;           // Clock and reset signals
    
    // Outputs
    wire [6:0] display_segments;  // 7-segment display segments a-g
    wire result_valid;            // Result validity LED
    wire power_on;                // Power status LED

    // Testbench variables
    integer test_case;
    parameter 
        IDLE = 0,
        NUM_ENTRY1 = 1,
        OP_SELECT = 2,
        NUM_ENTRY2 = 3,
        CALCULATE = 4,
        SHOW_RESULT = 5;

    initial begin
        // Initialize all inputs to 0
        switch <= 0;
        op_add <= 0;
        op_sub <= 0;
        clock <= 0;
        reset <= 1;
        
        display_segments = 7'b0000000;  // Default segments off
        result_valid = 0;
        power_on = 1;                  // Power on LED
        
        $display("Starting digital calculator testbench...");
    end

    always begin
        clock = 0;
        #5;
        clock = 1;
        #5;
        clock = 0;
        #5;
    end

    initial begin
        reset <= 1;
        #10;
        reset <= 0;
        #10;
        reset <= 1;
        
        // Test case: Basic addition
        test_case = 1;
        switch[3] <= 1;  // Enter '3'
        #10;
        switch[3] <= 0;
        op_add <= 1;     // Press add button
        #10;
        op_add <= 0;
        
        switch[5] <= 1;  // Enter '5'
        #10;
        switch[5] <= 0;
        op_sub <= 1;     // Press subtract button
        #10;
        op_sub <= 0;
        
        switch[8] <= 1;  // Enter '8'
        #10;
        switch[8] <= 0;
        
        op_add <= 1;     // Press add button to calculate
        #10;
        op_add <= 0;
        
        #50;
        $display("Test case %d: Addition result displayed: %b", test_case, display_segments);
        $display("Result validity: %b", result_valid);
        $display("------------------------");
    end

endmodule