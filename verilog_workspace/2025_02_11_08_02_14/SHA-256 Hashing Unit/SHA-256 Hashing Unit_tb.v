module sha256_testbench;

    // Define the period of the clock (e.g., 10 ns)
    parameter CLOCK_PERIOD = 10ns;
    
    // Generate the clock signal
    always begin
        #CLOCK_PERIOD/2;  // Half-period for rising edge
        clock = ~clock;   // Toggle the clock
    end

    // Reset signal initialization
    reg rst_n;
    initial begin
        rst_n = 0;  // Active-low reset
        #10ns;      // Hold reset for a certain period
        rst_n = 1;  // Release reset
    end

    // Input signals
    reg [7:0] msg_in [63:0];  // Message input (assuming 512-bit block size)
    wire [7:0] msg_out [63:0]; // Message output
    
    // DUT instance
    sha256_hash_unit dut (
        .clk(clock),
        .rst_n(rst_n),
        .msg_in(msg_in),
        .msg_out(msg_out)
    );

    // Test cases
    initial begin
        // Test case 1: All zeros
        $display("Test Case 1: Input message is all zeros");
        msg_in <= {64{0}};  // Set all bits to 0
        #20ns;               // Wait for two clock periods
        if (msg_out == {64{0}}) 
            $display("Success: Correct hash computed for all zeros\n");
        else 
            $display("Failure: Incorrect hash computed for all zeros\n");

        // Test case 2: "Hello World"
        $display("\nTest Case 2: Input message is 'Hello World'");
        msg_in <= {64{0}};  // Initialize with zeros
        // Populate the message with ASCII values of "Hello World"
        msg_in[7:0] = 8'h48; // 'H'
        msg_in[15:8] = 8'h65; // 'e'
        msg_in[23:16] = 8'hllo'; // 'l', 'l', 'o'
        // Continue populating the rest of the message...
        #20ns;               // Wait for two clock periods
        if (msg_out == expected_hash) 
            $display("Success: Correct hash computed for 'Hello World'\n");
        else 
            $display("Failure: Incorrect hash computed for 'Hello World'\n");

        // Test case 3: Maximum length message
        $display("\nTest Case 3: Input message is maximum length (512 bits)");
        msg_in <= {64{0}};  // Initialize with zeros
        // Populate the message with a known pattern for maximum length
        #20ns;               // Wait for two clock periods
        if (msg_out == expected_hash) 
            $display("Success: Correct hash computed for maximum length message\n");
        else 
            $display("Failure: Incorrect hash computed for maximum length message\n");

        // Add more test cases as needed
    end

endmodule