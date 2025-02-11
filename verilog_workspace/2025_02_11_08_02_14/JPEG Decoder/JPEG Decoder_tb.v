module jpeg_decoder_testbench;
    // Define clock period (100 MHz)
    localparam CLK_PERIOD = 10 ns;

    // Clock generation
    bit clk;
    always #(CLK_PERIOD/2) clk = !clk;  // 50% duty cycle

    // Reset signal
    bit rst_n;
    initial begin
        rst_n = 1'b1;
        #1ns rst_n = 1'b0;
        #1ns rst_n = 1'b1;
    end

    // Input signals
    bit jpeg_valid;
    bit h_sync, v_sync;
    bit [7:0] jpeg_data;

    // Output signals
    bit rgb_valid;
    bit decode_done;
    bit [23:0] rgb_data;

    // Testbench variables
    integer success = 1;

    initial begin
        $display("JPEG Decoder Testbench");
        #1ns;
        rst_n = 1'b0;  // Apply reset
        #1ns rst_n = 1'b1;  // Release reset

        // Simulate JPEG data input (simplified for testing)
        jpeg_data = 8'hFF;  // Start Of Image marker
        jpeg_valid = 1'b1;
        #20ns;

        jpeg_data = 8'hD8;  // JPEG image start
        jpeg_valid = 1'b1;
        #20ns;

        jpeg_data = 8'h00;  // Huffman table data
        jpeg_valid = 1'b1;
        #20ns;

        jpeg_data = 8'h12;  // Quantization table data
        jpeg_valid = 1'b1;
        #20ns;

        jpeg_data = 8'hFF;  // End Of Image marker
        jpeg_valid = 1'b1;
        #20ns;

        jpeg_valid = 1'b0;  // No more data

        // Wait for decoding to complete
        while (!decode_done) @ (posedge clk);

        $display("Decoding completed successfully");
        success = 1;
    end

    // Verification of outputs
    always @(posedge clk) begin
        if (!rgb_valid) continue;

        // Check RGB data here
        if (rgb_data != expected_rgb_data) begin
            $display("Mismatch in RGB data at %t", $time);
            success = 0;
        end
    end

    final begin
        if (success)
            $display("\nTestbench completed successfully\n");
        else
            $display("\nTestbench failed\n");
    end
endmodule