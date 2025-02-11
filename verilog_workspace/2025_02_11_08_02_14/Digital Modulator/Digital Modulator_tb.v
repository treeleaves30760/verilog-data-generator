module testbench_qpsk_modulator;
    // Define local parameters
    localparam CLOCK_PERIOD = 10;

    // Clock signal
    reg clk;
    always begin
        #CLOCK_PERIOD;
        clk = ~clk;
    end

    // Reset signal
    reg rst;
    initial begin
        rst = 1;
        #20;  // Wait for two clock periods
        rst = 0;
    end

    // Input signals
    reg data_in;
    wire encoded_out;

    // DUT instance
    digital_modulator_mod inst_digital_modulator (
        .data_in(data_in),
        .clk(clk),
        .rst(rst),
        .encoded_out(encoded_out)
    );

    initial begin
        $display("\nStarting QPSK Modulator Testbench");
        #10;

        // Test all possible 8-bit input combinations
        for (data_in = 0; data_in < 256; data_in++) begin
            #20;  // Wait for one clock period

            $display("\nTesting data_in = %b", data_in);

            // Apply the current data_in value
            #10;

            // Wait a few periods to allow modulator to process
            #30;

            // Check if encoded_out matches expected QPSK modulation
            if (encoded_out == ((data_in >> 7) ^ (data_in >> 6))) begin
                $display("Test PASSED for data_in = %b", data_in);
            end else begin
                $display("Test FAILED for data_in = %b", data_in);
            end

            #10;
        end

        // End of simulation
        $display("\nSimulation complete");
        $finish;
    end

endmodule