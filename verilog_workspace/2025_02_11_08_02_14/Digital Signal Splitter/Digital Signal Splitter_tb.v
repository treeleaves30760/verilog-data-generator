`timescale 1ns / 1ps

module tb_channel_splitter;
    // Clock generation
    localparam CLOCK_PERIOD = 10 ns;
    
    wire clk;
    reg rst_n, input_data;
    reg [1:0] channel_select;
    wire ch0, ch1, ch2, ch3;
    
    // DUT instance
    channel_splitter dut (
        .clk(clk),
        .rst_n(rst_n),
        .input_data(input_data),
        .channel_select(channel_select),
        .ch0(ch0),
        .ch1(ch1),
        .ch2(ch2),
        .ch3(ch3)
    );
    
    // Clock generation
    always begin
        #5ns;
        clk = 1;
        #5ns;
        clk = 0;
    end
    
    initial begin
        rst_n = 0;
        input_data = 0;
        channel_select = 0;
        
        // Reset phase
        repeat(2) @(posedge clk);
        rst_n = 1;
        
        // Test cases
        `TEST_CASE("Test case: Channel selection 00 (no output)")
            input_data = 0;
            channel_select = 0;
            #10ns;
            if ({ch3, ch2, ch1, ch0} != 4'b0000) `FAIL("Outputs are not all 0 for channel select 00");
        
        `TEST_CASE("Test case: Channel selection 01")
            input_data = 1;
            channel_select = 1;
            #10ns;
            if (ch1 != 1 || {ch3, ch2, ch0} != 3'b000) `FAIL("Outputs not correct for channel select 01");
        
        `TEST_CASE("Test case: Channel selection 10")
            input_data = 1;
            channel_select = 2;
            #10ns;
            if (ch2 != 1 || {ch3, ch1, ch0} != 3'b000) `FAIL("Outputs not correct for channel select 10");
        
        `TEST_CASE("Test case: Channel selection 11")
            input_data = 1;
            channel_select = 3;
            #10ns;
            if (ch3 != 1 || {ch2, ch1, ch0} != 3'b000) `FAIL("Outputs not correct for channel select 11");
        
        // Additional test cases with toggling input_data
        `TEST_CASE("Test case: Channel selection 01 with toggling input")
            input_data = !input_data;
            repeat(2) @(posedge clk);
            if ({ch3, ch2, ch1, ch0} != 4'b0000) `FAIL("Outputs not correct after toggle");
        
        // Final check
        `SUCCESS("All test cases passed");
    end
    
endmodule