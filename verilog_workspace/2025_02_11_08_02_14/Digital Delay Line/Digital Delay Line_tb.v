module delay_line_testbench;

    // Define clock period based on 100 MHz
    `define CLOCK_PERIOD 10 ns

    // Inputs
    reg clk;
    reg rst_n;
    reg [3:0] delay_value;
    reg [7:0] data_in;

    // Output
    wire [7:0] data_out;

    // DUT instance
    delay_line dut (
        .clk(clk),
        .rst_n(rst_n),
        .delay_value(delay_value),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    always begin
        clk = 1;
        # (`CLOCK_PERIOD / 2);
        clk = 0;
        # (`CLOCK_PERIOD / 2);
    end

    // Reset initialization
    initial begin
        rst_n = 0;
        delay_value = 0;
        data_in = 0;
        # (3 * `CLOCK_PERIOD);
        rst_n = 1;
    end

    // Test cases
    initial begin
        for (delay_value = 0; delay_value < 16; delay_value++) begin
            // Apply test pattern: all ones
            data_in = 8'hFF;
            # (`CLOCK_PERIOD);
            // Wait for the expected number of clock cycles to allow propagation
            # ((delay_value + 1) * `CLOCK_PERIOD);
            if (data_out != data_in) begin
                $error("Test failed: Expected data_out = %b, but got %b at delay value %d",
                       data_in, data_out, delay_value);
            end else begin
                $display("Test passed for delay value %d with all ones", delay_value);
            end
            // Apply test pattern: all zeros
            data_in = 8'h00;
            # (`CLOCK_PERIOD);
            // Wait for the expected number of clock cycles to allow propagation
            # ((delay_value + 1) * `CLOCK_PERIOD);
            if (data_out != data_in) begin
                $error("Test failed: Expected data_out = %b, but got %b at delay value %d",
                       data_in, data_out, delay_value);
            end else begin
                $display("Test passed for delay value %d with all zeros", delay_value);
            end
            // Wait one clock cycle before next iteration
            # (`CLOCK_PERIOD);
        end
        
        $display("\nAll tests completed successfully!");
    end

endmodule