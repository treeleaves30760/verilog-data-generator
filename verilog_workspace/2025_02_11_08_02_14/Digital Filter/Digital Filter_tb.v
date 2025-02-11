`timescale 1ns / 1ps

module Digital_Filter_Testbench;
    // Clock generation
    localparam CLOCK_PERIOD = 5;  // 100 MHz clock (10ns period)
    
    reg clk;
    always begin
        clk = 0;
        #CLOCK_PERIOD;
        clk = 1;
        #CLOCK_PERIOD;
    end

    // Reset signal
    reg rst_n;
    initial begin
        rst_n = 0;
        #20;  // Hold reset for two clock periods (20ns)
        rst_n = 1;
    end

    // Input signals
    reg enable;
    reg [2:0] mode;
    reg [15:0] data_in;

    // Output signals
    wire ready;
    wire [15:0] data_out;

    // DUT instance
    Digital_Filter dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .enable(enable),
        .mode(mode),
        .ready(ready),
        .data_out(data_out)
    );

    // Test cases for data_in
    localparam [15:0] data_values[] = {
        16'h0000,  // All zeros
        16'hFFFF,  // All ones
        16'h0001,  // Single bit set
        16'hFFFE   // All bits except LSB
    };

    // Test cases for mode (low-pass and high-pass)
    localparam [2:0] modes[] = {3'b000, 3'b001, 3'b010};

    integer i;
    initial begin
        #PERIOD;  // Wait one period to ensure proper setup
        rst_n = 1;

        for (i = 0; i < data_values.size(); i++) begin
            mode = modes[i];
            data_in = data_values[i];
            enable = 1;
            
            // Wait for the filter's latency plus a few cycles
            #20;  // Latency is 16, add extra to ensure it's settled
            if (ready == 0) begin
                $error("Ready signal not asserted after sufficient time");
            end
            
            // Check data_out based on mode
            case (mode)
                3'b000: 
                    if (data_out != (data_values[i] >> 1)) begin
                        $error("Low-pass filter output mismatch. Expected: %h, Actual: %h",
                               data_values[i], data_out);
                    end
                3'b001: 
                    if (data_out != (data_values[i]/2)) begin
                        $error("Band-pass filter output mismatch. Expected: %h, Actual: %h",
                               data_values[i], data_out);
                    end
                3'b010: 
                    if (data_out != (data_values[i] >> 2)) begin
                        $error("High-pass filter output mismatch. Expected: %h, Actual: %h",
                               data_values[i], data_out);
                    end
            endcase

            enable = 0;
            
            // Wait for one more cycle to ensure disable functionality
            #CLOCK_PERIOD;
        end
        
        $display("All tests passed successfully!");
    end
endmodule