`timescale 1ns / 1ps

module uart_receiver_testbench();
    // Define local parameters
    localparam BAUD_RATE = 16;
    localparam CLK_PERIOD = 10;  // 50MHz clock (20ns period)
    
    // Inputs
    reg clk;
    reg rst;
    reg rx_data;
    
    // Outputs
    wire rx_char;
    wire rx_busy;
    wire rx_done;
    
    // DUT instance
    uart_receiver #(
        .BAUD_RATE(BAUD_RATE)
    ) dut (
        .clk(clk),
        .rst(rst),
        .rx_data(rx_data),
        .rx_char(rx_char),
        .rx_busy(rx_busy),
        .rx_done(rx_done)
    );
    
    // Clock generation
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    initial begin
        rst = 1;
        rx_data = 0;
        
        // Reset the DUT
        rst = 1;
        repeat(3) { @posedge clk; }
        rst = 0;
        
        // Test all possible input combinations
        for (rx_data = 0; rx_data < 8'hFF; rx_data++) {
            // Generate test patterns with start and stop bits
            reg [7:0] data_byte = rx_data;
            
            // Create a valid UART frame:
            // Start bit (0), Data (data_byte), Parity (even), Stop bit(s) (1 or 2)
            // For simplicity, we'll use one stop bit
            reg [9:0] frame = {1'b0, data_byte, 6'b000000};  // Adjust parity if required
            
            $display("Testing data: %h", data_byte);
            
            // Drive the frame onto rx_data with appropriate timing
            for (bit_pos = 0; bit_pos < 10; bit_pos++) {
                rx_data = frame[9 - bit_pos];  // MSB first
                @posedge clk;
            }
            
            // Wait for receiver to process the data
            wait_for_rx_done();
            
            // Check if received character matches expected
            check_received_char(data_byte, rx_char);
            
            // Ensure busy state is correctly managed
            check_busy_state(!rx_done);
        }
        
        $display("Testbench completed successfully!");
    end
    
    // Helper task to wait for receiver completion
    task wait_for_rx_done();
        while (1) begin
            if (rx_done == 1) break;
            @posedge clk;
        end
    endtask
    
    // Helper function to check received character
    task check_received_char(expected_char, actual_char);
        if (actual_char != expected_char) begin
            $display("Failure: Received character mismatch - Expected: %h, Actual: %h", 
                     expected_char, actual_char);
            $finish;
        end
    endtask
    
    // Helper function to check busy state
    task check_busy_state(expected_value);
        if (rx_busy != expected_value) begin
            $display("Failure: rx_busy mismatch - Expected: %b, Actual: %b", 
                     expected_value, rx_busy);
            $finish;
        end
    endtask
    
endmodule