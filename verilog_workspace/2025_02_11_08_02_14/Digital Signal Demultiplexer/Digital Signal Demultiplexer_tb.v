module DigitalSignalDemultiplexer_tb;
    // Inputs
    reg data_in;
    reg sel;
    reg clk;
    reg rst;

    // Outputs
    wire data_out_0;
    wire data_out_1;
    wire data_out_2;
    wire data_out_3;

    // Clock generation
    initial begin
        clk = 0;
        forever #5ns clk = ~clk;
    end

    // Reset signal
    initial begin
        rst = 1;
        #20ns rst = 0; // Wait for one full clock cycle to ensure reset is applied
    end

    // Test cases
    initial begin
        $display("Digital Signal Demultiplexer Testbench");
        $display("----------------------------------------");

        // Test with data_in = 0
        data_in = 0;
        sel = 0;
        #10ns; // Wait for one clock cycle
        sel = 1;
        #10ns;
        sel = 2;
        #10ns;
        sel = 3;
        #10ns;

        // Test with data_in = 1
        data_in = 1;
        sel = 0;
        #10ns;
        sel = 1;
        #10ns;
        sel = 2;
        #10ns;
        sel = 3;
        #10ns;

        $display("All test cases passed!");
        $finish;
    end

    // Check outputs
    always @(posedge clk) begin
        if (rst == 1) begin
            $display("Reset is active, all outputs should be 0");
            if (data_out_0 != 0 || data_out_1 != 0 || data_out_2 != 0 || data_out_3 != 0) begin
                $error("Outputs are not correctly reset during rst=1");
            end
        end else begin
            case (sel)
                0: 
                    if (data_out_0 != data_in) $error("sel=0 failed, data_out_0 should be %b", data_in);
                1: 
                    if (data_out_1 != data_in) $error("sel=1 failed, data_out_1 should be %b", data_in);
                2: 
                    if (data_out_2 != data_in) $error("sel=2 failed, data_out_2 should be %b", data_in);
                3: 
                    if (data_out_3 != data_in) $error("sel=3 failed, data_out_3 should be %b", data_in);
                default:
                    $display("sel is invalid, no output should be selected");
            endcase
        end
    end

endmodule