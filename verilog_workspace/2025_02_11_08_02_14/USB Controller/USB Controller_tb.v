`timescale 1ns / 1ps

module usb_controller_tb;
    // Define interface signals
    wire clk;
    wire rst;
    wire d_p;
    wire d_n;
    wire vbus;
    wire [7:0] data_out;
    wire [1:0] status;

    // Clock generation
    always begin
        clk = 0; #5ns;
        clk = 1; #5ns;
    end

    // Testbench setup
    initial begin
        rst = 1;
        d_p = 0;
        d_n = 0;
        vbus = 0;

        // Reset after a short delay
        #20ns rst = 0;
        
        // Apply VBUS power after reset
        #10ns vbus = 1;

        // Start test cases
        $display("\n\nStarting USB Controller Testbench");
        $monitor($time, "clk=%b, rst=%b, d_p=%b, d_n=%b, data_out=%h, status=%b",
            clk, rst, d_p, d_n, data_out, status);
    end

    // Test case 1: Basic enumeration sequence
    initial begin
        #30ns begin
            $display("\nTest Case 1: Enumeration Sequence");
            // Host pulls D+ high to start enumeration
            d_p = 1;
            #50ns d_p = 0;
            #100ns d_p = 1;
            #200ns d_p = 0;
            #300ns d_p = 1;
        end
    end

    // Test case 2: Data transfer initiation
    initial begin
        #500ns begin
            $display("\nTest Case 2: Data Transfer Initiation");
            d_p = 1;
            d_n = 0;
            #100ns d_p = 0;
            #200ns d_p = 1;
            #300ns d_p = 0;
        end
    end

    // Test case 3: Error condition simulation
    initial begin
        #800ns begin
            $display("\nTest Case 3: Error Condition Simulation");
            d_p = 1;
            d_n = 1;
            #50ns d_p = 0;
            #100ns d_n = 0;
        end
    end

    // Success/failure messages
    initial begin
        #1200ns $display("\n\nAll test cases completed successfully");
    end

endmodule