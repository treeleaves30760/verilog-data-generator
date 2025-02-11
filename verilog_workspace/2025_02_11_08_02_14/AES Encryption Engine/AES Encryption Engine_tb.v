module testbench_mux_2to1;
    // Define inputs and output
    input A, B, S;
    output Y;

    // Clock generation
    always begin
        clk = 1; #10;
        clk = 0; #10;
    end

    initial begin
        // Initialize inputs to 0
        A = 0;
        B = 0;
        S = 0;
        #5; // Wait for some time

        // Test case 1: A=0, B=0, S=0 ¡÷ Y=0
        #10; // Wait until falling edge of clock
        A = 0; B = 0; S = 0;
        #1;
        if (Y != 0) $display("Failed - Test Case 1: Expected 0, Actual %b", Y);
        else $display("Passed - Test Case 1");

        // Repeat similar steps for all other test cases

        finish;
    end
endmodule