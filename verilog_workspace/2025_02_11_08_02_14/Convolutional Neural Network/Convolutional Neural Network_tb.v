module tb_cnn;

    // Define clock frequency
    localparam CLK_PERIOD = 10 ns;

    // Inputs
    reg clk;
    reg rst;
    reg [783:0] input_data;  // 28x28 grayscale image (784 bits)
    reg start;

    // Outputs
    wire [9:0] output_class;
    wire done;

    // Clock generation
    initial begin
        clk = 0;
        forever begin
            # (CLK_PERIOD / 2);
            clk = ~clk;
        end
    end

    // Reset signal
    initial begin
        rst = 1;
        input_data = 0;
        start = 0;
        # 50 ns;  // Wait for clock cycles to settle
        rst = 0;
    end

    // Test cases
    integer test_case;
    reg [783:0] test_images [];
    initial begin
        test_images = {
            // MNIST digit '0' (example input)
            12'b000000000000_000000000000_...,
            // MNIST digit '1' (example input)
            12'b000000000000_000000000000_...
            // Add more test cases for other digits here
        };

        for (test_case = 0; test_case < 10; test_case++) begin
            # 20 us;  // Wait for previous processing to complete

            // Apply reset
            rst = 1;
            # CLK_PERIOD;
            rst = 0;

            // Set input data and start signal
            input_data = test_images[test_case];
            start = 1;
            # CLK_PERIOD;
            start = 0;

            // Wait for processing to complete
            while (!done) 
                @ (posedge clk);

            // Check output
            if (output_class == test_case + 1) begin
                $display("Test case %d: Success! Predicted class %d.", test_case, output_class);
            end else begin
                $display("Test case %d: Failure! Expected %d, got %d.", test_case, test_case + 1, output_class);
            end

            # 20 us;  // Wait before next test case
        end

        $display("All test cases completed.");
        $finish;
    end

endmodule