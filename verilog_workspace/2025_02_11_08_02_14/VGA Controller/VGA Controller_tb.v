module vga_controller_testbench;

// Define clock frequency (25 MHz for VGA)
`define CLK_FREQ 25_000_000

// Clock generation at 10 kHz for simulation purposes
always begin
    clk = 1'b1;
    #(`CLK_FREQ == 25_000_000) ? (1/(25_000_000)) : (1/10_000);
    clk = 1'b0;
    #(`CLK_FREQ == 25_000_000) ? (1/(25_000_000)) : (1/10_000);
end

// Reset signal generation
initial begin
    rst_n = 1'b0;
    #10;
    rst_n = 1'b1;
end

// DUT instance
vga_controller dut (
    .clk(clk),
    .rst_n(rst_n),
    .pixel_clk_en(pixel_clk_en),
    .hsync_in(hsync_in),
    .vsync_in(vsync_in),
    .rgb_data(rgb_data),
    .irq(irq),
    // Add other output ports as per DUT definition
);

// Test cases and stimulus generation
initial begin
    // Initialize all inputs to 0
    pixel_clk_en = 1'b0;
    hsync_in = 1'b0;
    vsync_in = 1'b0;
    rgb_data = 24'h000000;
    irq = 1'b0;

    #100; // Wait for some time

    // Test case 1: Basic operation
    $display("Test Case 1: Basic Operation");
    pixel_clk_en = 1'b1;
    hsync_in = 1'b1;
    vsync_in = 1'b1;
    rgb_data = 24'hFF0000; // Red color
    irq = 1'b0;
    #100;

    // Test case 2: Transition between colors
    $display("Test Case 2: Color Transition");
    rgb_data = 24'h00FF00; // Green color
    #100;
    rgb_data = 24'h0000FF; // Blue color
    #100;

    // Test case 3: Edge cases for sync signals
    $display("Test Case 3: Sync Signal Edges");
    hsync_in = ~hsync_in; // Toggle horizontal sync
    vsync_in = ~vsync_in; // Toggle vertical sync
    #100;
    hsync_in = ~hsync_in; // Revert horizontal sync
    vsync_in = ~vsync_in; // Revert vertical sync
    #100;

    // Test case 4: FIFO full condition
    $display("Test Case 4: FIFO Full");
    // Assume vga_fifo_full is a status output from DUT
    while (vga_fifo_full == 1'b0) begin
        rgb_data = ~rgb_data; // Toggle RGB data to simulate usage
        #50;
    end
    $display("FIFO became full at %t", $time);
    #100;

    // Test case 5: Interrupt handling
    $display("Test Case 5: Interrupt Handling");
    irq = 1'b1;
    #50;
    irq = 1'b0;
    #50;

    // Final check and exit
    $display("All test cases completed successfully!");
    $finish;
end

// Monitor FIFO full status
always @(posedge clk) begin
    if (rst_n == 1'b1) begin
        if (vga_fifo_full == 1'b1) begin
            $display("FIFO is full at %t", $time);
        end
    end
end

// Add other monitoring logic as needed for outputs

endmodule