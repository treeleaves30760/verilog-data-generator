`timescale 1ns / 1ps

module tb_full_adder_2bit();
    // Clock generation
    localparam CLOCK_PERIOD = 1 ns;
    
    // Inputs
    reg a, b, c_in;
    wire s, c_out;

    // DUT (Design Under Test)
    full_adder_2bit dut (
        .a(a),
        .b(b),
        .c_in(c_in),
        .s(s),
        .c_out(c_out)
    );

    // Clock signal
    always begin
        clk = 1'b1;
        #CLOCK_PERIOD/2;
        clk = 1'b0;
        #CLOCK_PERIOD/2;
    end

    initial begin
        // Power-up delay
        #10;

        // Test all combinations of a, b, c_in (3 inputs)
        for (a=0; a<2; a++) 
            for (b=0; b<2; b++)
                for (c_in=0; c_in<2; c_in++) begin
                    #1;
                    {a, b, c_in} = {a, b, c_in};
                    
                    // Wait for rising edge of clock
                    @posedge clk;
                    
                    // Expected sum and carry
                    wire expected_s = a ^ b ^ c_in;
                    wire expected_c_out = (a & b) | (a & c_in) | (b & c_in);
                    
                    if (s == expected_s && c_out == expected_c_out) begin
                        $display("TEST PASS: a=%d, b=%d, c_in=%d | s=%d, c_out=%d", 
                            a, b, c_in, s, c_out);
                    end else begin
                        $error("TEST FAIL: a=%d, b=%d, c_in=%d | s=%d (expected %d), c_out=%d (expected %d)", 
                            a, b, c_in, s, expected_s, c_out, expected_c_out);
                    end
                    
                    #1;
                end
    end

endmodule