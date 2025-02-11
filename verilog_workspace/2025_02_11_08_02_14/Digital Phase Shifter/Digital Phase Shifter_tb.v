#include "DigitalPhaseShifter.v"

module DigitalPhaseShifter_tb;
    // Clock generation
    localparam CLOCK_PERIOD = 10;
    
    // Reset signal
    localparam RESET_DURATION = 2;

    // Inputs
    reg aclk;
    reg aclr;
    reg [8:0] shift_amount; // signed 9-bit integer (-512 to +511)
    reg direction;

    // Outputs
    wire dout;
    wire error;

    // DUT instance
    DigitalPhaseShifter dut (
        .aclk(aclk),
        .aclr(aclr),
        .shift_amount(shift_amount),
        .direction(direction),
        .dout(dout),
        .error(error)
    );

    // Clock generation
    always begin
        aclk = 0;
        # (CLOCK_PERIOD / 2);
        aclk = 1;
        # (CLOCK_PERIOD / 2);
    end

    // Reset signal
    initial begin
        aclr = 1;
        repeat(RESET_DURATION) @(posedge aclk);
        aclr = 0;
    end

    // Test all possible input combinations
    integer i, j;
    initial begin
        $display("Digital Phase Shifter Testbench");
        $display("-----------------------------");
        $display("Testing all shift_amount (9-bit signed) and direction (1-bit)");
        
        for (i = -512; i <= 511; i++) begin
            shift_amount = i;
            
            for (j = 0; j < 2; j++) begin
                direction = j;
                
                // Apply inputs
                # (CLOCK_PERIOD);
                @(posedge aclk);
                # (CLOCK_PERIOD);
                
                // Check error condition
                if ($abs(i) > 360 || $abs(i) == 512) begin
                    if (!error) begin
                        $display("FAIL: Test case %d, direction %b - Error not detected for invalid shift_amount!", i, direction);
                        $finish;
                    end
                end else begin
                    if (error) begin
                        $display("FAIL: Test case %d, direction %b - Error incorrectly detected for valid shift_amount!", i, direction);
                        $finish;
                    end
                end
                
                // Display test result
                $display("PASS: Test case %d, direction %b - Error correctly %s", 
                         i, direction, (error ? "detected" : "not detected"));
            end
        end
        
        $display("-----------------------------");
        $display("All tests passed successfully!");
        $finish;
    end

endmodule