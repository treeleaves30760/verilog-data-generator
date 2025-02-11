`timescale 1ns / 1ps

module tb_modulator_bpsk_qpsk;
    // Define signals
    reg clk, rst, data_in, modulate_enable;
    wire d0, d1;

    // DUT instance
    modulator_bpsk_qpsk dut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .modulate_enable(modulate_enable),
        .d0(d0),
        .d1(d1)
    );

    // Clock generation
    always begin
        clk = 0;
        #(5ns);
        clk = 1;
        #(5ns);
    end

    initial begin
        // Initialize signals
        rst = 1;
        data_in = 0;
        modulate_enable = 0;

        // Reset the DUT properly
        rst = 1;
        #(20ns);  // Wait for two clock cycles
        rst = 0;
        #(10ns);

        // Test all input combinations
        // 1. data_in=0, modulateEnable=0
        data_in = 0;
        modulate_enable = 0;
        #(30ns);
        check_output(0, 0);

        // 2. data_in=1, modulateEnable=0
        data_in = 1;
        modulate_enable = 0;
        #(30ns);
        check_output(1, 0);

        // 3. data_in=0, modulateEnable=1
        data_in = 0;
        modulate_enable = 1;
        #(30ns);
        check_output(0, 1);

        // 4. data_in=1, modulateEnable=1
        data_in = 1;
        modulate_enable = 1;
        #(30ns);
        check_output(1, 1);

        // Additional test cases if needed
        // ...

        $finish;
    end

    task check_output(input bit expected_d0, expected_d1);
        if (d0 == expected_d0 && d1 == expected_d1) begin
            $display("TEST CASE PASSED: data_in=%b, modulate_enable=%b -> d0=%b, d1=%b", 
                     data_in, modulate_enable, d0, d1);
        end else begin
            $display("TEST CASE FAILED: data_in=%b, modulate_enable=%b. Expected d0=%b, d1=%b but got d0=%b, d1=%b",
                     data_in, modulate_enable, expected_d0, expected_d1, d0, d1);
        end
    endtask

endmodule