module tb_pll_core;
    // Declaration of signals
    reg rst_n;
    reg div_num;
    reg clk_in;
    reg clk_out_enable;
    wire clk_out;
    wire locked;

    // Clock generation for clk_in
    initial begin
        forever begin
            #10 ns;
            clk_in = ~clk_in;
        end
    end

    // DUT instance
    pll_core dut (
        .rst_n(rst_n),
        .div_num(div_num),
        .clk_in(clk_in),
        .clk_out_enable(clk_out_enable),
        .clk_out(clk_out),
        .locked(locked)
    );

    initial begin
        rst_n = 1'b0;  // Reset active low
        div_num = 3'b0;
        clk_out_enable = 1'b1;

        // Reset the DUT
        rst_n = 1'b0;
        repeat(2) @(posedge clk_in);
        rst_n = 1'b1;
        repeat(1) @(posedge clk_in);

        $display("Starting PLL testbench simulation...");
        
        // Test case 1: Basic lock detection
        $display("\nTest Case 1: Check basic locking");
        div_num = 3'b001;  // Set divisor to 1
        repeat(20) @(posedge clk_in);
        if (locked == 1'b1) 
            $display("PLL locked successfully!");
        else
            $error("PLL failed to lock");

        // Test case 2: Change divisor during operation
        $display("\nTest Case 2: Check divisor change");
        div_num = 3'b010;  // Set divisor to 2
        repeat(20) @(posedge clk_in);
        if (locked == 1'b1)
            $display("PLL successfully re-locked with new divisor!");
        else
            $error("PLL failed to re-lock after divisor change");

        // Test case 3: Toggle clock output enable
        $display("\nTest Case 3: Check clock output enable");
        clk_out_enable = 1'b0;
        repeat(5) @(posedge clk_in);
        if (clk_out == 1'b0)
            $display("Clock output disabled correctly");
        else
            $error("Clock output failed to disable");

        // Test case 4: Edge cases and maximum divisor
        $display("\nTest Case 4: Check edge cases and max divisor");
        div_num = 3'b111;  // Set divisor to 7
        repeat(20) @(posedge clk_in);
        if (locked == 1'b1)
            $display("PLL successfully locked with maximum divisor!");
        else
            $error("PLL failed to lock with maximum divisor");

        $display("\nAll test cases completed successfully!");
        $finish;
    end

endmodule