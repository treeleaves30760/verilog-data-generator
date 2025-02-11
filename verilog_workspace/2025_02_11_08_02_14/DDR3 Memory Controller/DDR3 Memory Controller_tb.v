`timescale 1ns / 1ps

module multiplier_tb;
    // Clock generation
    localparam CLK_PERIOD = 100;  // 10 MHz clock
    
    // Inputs
    input clk, rst_n;
    input [7:0] a, b;
    
    // Outputs
    output [15:0] product;
    
    // Testbench signals
    reg tb_clk, tb_rst_n;
    reg [7:0] tb_a, tb_b;
    
    // DUT instantiation
    Multiplier dut (
        .clk(tb_clk),
        .rst_n(tb_rst_n),
        .a(tb_a),
        .b(tb_b),
        .product(product)
    );

    // Clock generation
    always begin
        tb_clk = 1;
        # (CLK_PERIOD / 2);
        tb_clk = 0;
        # (CLK_PERIOD / 2);
    end

    // Reset handling
    initial begin
        tb_rst_n = 0;
        repeat(2) { @posedge tb_clk; }
        tb_rst_n = 1;
    end

    // Test cases
    initial begin
        $display("8-bit Multiplier Testbench");
        $display("------------------------");
        
        // Initialize test inputs
        tb_a = 0;
        tb_b = 0;

        // Test all possible input combinations
        for (tb_a from 0 to 255) begin
            for (tb_b from 0 to 255) begin
                // Apply inputs with setup time
                # (CLK_PERIOD * 0.1);
                tb_a = a;
                tb_b = b;
                
                // Wait for one clock cycle
                repeat(2) { @posedge tb_clk; }
                
                // Check output with hold time
                # (CLK_PERIOD * 0.1);
                if (product != (a * b)) begin
                    $display("FAIL: Expected %h, Actual %h", a * b, product);
                    $finish;
                end
            end
        end
        
        // All tests passed
        $display("ALL TESTS PASSED");
        $finish;
    end
endmodule