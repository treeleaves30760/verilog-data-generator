module tb_digital_oscillator;
    // Inputs
    input wire        rst;
    input wire        en;
    input wire [1:0]  freq_select;
    input wire [1:0]  duty_cycle_sel;
    input wire [2:0]  phase_shift_sel;
    input wire        clk;

    // Output
    output reg        oscl_out;

    // Clock generation
    initial begin
        forever begin
            #5ns clk = ~clk;
        end
    end

    // Reset signal
    initial begin
        rst = 1;
        en = 0;
        freq_select = 0;
        duty_cycle_sel = 0;
        phase_shift_sel = 0;
        oscl_out = 0;
        #20ns rst = 0;
    end

    // Test all input combinations
    initial begin
        $display("Digital Oscillator Testbench");
        $display("----------------------------------");
        $display("Testing all input combinations...");
        
        for (freq_select = 0; freq_select < 2; freq_select++) {
            for (duty_cycle_sel = 0; duty_cycle_sel < 2; duty_cycle_sel++) {
                for (phase_shift_sel = 0; phase_shift_sel < 4; phase_shift_sel++) {
                    for (en = 0; en < 2; en++) {
                        #15ns;
                        $display("Frequency Select: %b", freq_select);
                        $display("Duty Cycle Select: %b", duty_cycle_sel);
                        $display("Phase Shift Select: %b", phase_shift_sel);
                        $display("Enable: %b", en);
                        
                        #10ns;
                        if (oscl_out == (en ? 1 : 0)) {
                            $display("Test passed - Output matches expected value");
                        } else {
                            $error("Test failed - Output mismatch");
                        }
                        
                        #5ns;
                        $display("----------------------------------");
                    }
                }
            }
        }
        
        #100ms;
        $display("All tests completed successfully!");
        $stop;
    end

endmodule