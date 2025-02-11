`timescale 1ns / 1ps

module digital_signal_decoder_testbench;
    // Define interface signals
    logic clk;
    logic rst_n;
    logic [7:0] encoded_data_in;  // Assuming N=8 for testing purposes
    logic [7:0] decoded_data_out; // Assuming M=8 for testing purposes
    logic decode_error;

    // Clock generation
    always begin
        clk = 1'b1;
        #5ns;
        clk = 1'b0;
        #5ns;
    end

    initial begin
        rst_n = 1'b0;  // Active-low reset
        encoded_data_in = 8'h00;
        decoded_data_out = 8'h00;
        decode_error = 1'b0;

        // Apply reset for one clock cycle
        #10ns;
        rst_n = 1'b1;

        // Test all possible input combinations
        for (int i = 0; i < 256; i++) begin
            encoded_data_in = i;
            #10ns;  // Wait for one clock cycle
            
            // Expected output is same as encoded data for testing purposes
            if (decoded_data_out != i) begin
                $error("Test failed: Encoded %d, Decoded %d", i, decoded_data_out);
            end

            // Check for decode error flag
            if (decode_error == 1'b1) begin
                $error("Decode error occurred for input %d", i);
            end

            // Monitor test progress
            $monitor($format("\nTest case: Encoded = %d, Decoded = %d, Error = %b\n",
                             i, decoded_data_out, decode_error));
        end

        // Test completion message
        $display("All test cases completed successfully");
    end
endmodule