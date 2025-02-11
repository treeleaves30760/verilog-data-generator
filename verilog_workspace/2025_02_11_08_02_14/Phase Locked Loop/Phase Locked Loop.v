module pll_core_testbench;
    // Testbench signals
    reg rst_n;
    reg [2:0] div_num;  // Divisor control (3-bit for values 1 to 7)
    reg clk_in;
    reg clk_out_enable;

    wire clk_out;
    wire locked;

    // DUT instantiation
    pll_core dut (
        .rst_n(rst_n),
        .div_num(div_num),
        .clk_in(clk_in),
        .clk_out_enable(clk_out_enable),
        .clk_out(clk_out),
        .locked(locked)
    );

    // Clock generation
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

    // Test cases
    initial begin
        rst_n = 1;  // No reset at start
        div_num = 4;  // Initial divisor
        clk_out_enable = 1;  // Enable output

        // Test case 1: Basic operation without reset
        #20;
        rst_n = 0;  // Reset the system
        #10;
        rst_n = 1;  // Release reset

        // Test case 2: Change divisor during operation
        #30;
        div_num = 2;

        // Test case 3: Disable output
        #30;
        clk_out_enable = 0;

        // Test case 4: Re-enable output
        #30;
        clk_out_enable = 1;

        // Test case 5: Change divisor again
        #30;
        div_num = 6;

        // Continue testing as needed...
    end

endmodule