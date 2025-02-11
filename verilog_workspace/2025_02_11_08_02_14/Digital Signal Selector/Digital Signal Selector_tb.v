module tb_sel_4to1;
    // Define the period of the clock signal (50 MHz)
    timeprecision 1ns;
    real ClkPeriod = 20.0;  // Period in nanoseconds

    // Generate the clock signal
    initial begin
        forever begin
            #ClkPeriod/2;  // Half-period for rising edge
            Clk = ~Clk;    // Toggle the clock
        end
    end

    // Reset signal initialization
    reg Rst_n;
    initial begin
        Rst_n = 0;         // Apply reset
        #10ns;             // Hold reset for at least one period
        Rst_n = 1;         // Release reset
    end

    // Inputs
    reg [3:0] D;          // Data inputs (D0 to D3)
    reg [1:0] S;          // Select inputs (S[1], S[0])
    wire Y;               // Output
    wire Clk;             // Clock signal
    wire Rst_n;           // Reset signal

    // DUT instantiation
    sel_4to1 dut (
        .D(D),
        .S(S),
        .Clk(Clk),
        .Rst_n(Rst_n),
        .Y(Y)
    );

    // Test cases and verification
    initial begin
        // Test case 1: S = 00, D0 = 0, D1 = 1, D2 = 0, D3 = 1
        #5ns;             // Wait for a stable state after reset
        S = 0;
        D = 4'b0101;      // D0=0, D1=1, D2=0, D3=1
        #ClkPeriod;       // Wait for one clock period
        if (Y != 0) begin
            $display("TEST FAILED: S=00, expected Y=0 but got %b", Y);
            $finish;
        end else begin
            $display("TEST PASSED: S=00, Y=%b", Y);
        end

        // Test case 2: S = 01, D0 = 1, D1 = 0, D2 = 1, D3 = 0
        #ClkPeriod;
        S = 1;
        D = 4'b1010;      // D0=1, D1=0, D2=1, D3=0
        #ClkPeriod;
        if (Y != 1) begin
            $display("TEST FAILED: S=01, expected Y=1 but got %b", Y);
            $finish;
        end else begin
            $display("TEST PASSED: S=01, Y=%b", Y);
        end

        // Test case 3: S = 10, D0 = 0, D1 = 1, D2 = 1, D3 = 0
        #ClkPeriod;
        S = 2;
        D = 4'b0110;      // D0=0, D1=1, D2=1, D3=0
        #ClkPeriod;
        if (Y != 1) begin
            $display("TEST FAILED: S=10, expected Y=1 but got %b", Y);
            $finish;
        end else begin
            $display("TEST PASSED: S=10, Y=%b", Y);
        end

        // Test case 4: S = 11, D0 = 1, D1 = 0, D2 = 0, D3 = 1
        #ClkPeriod;
        S = 3;
        D = 4'b1001;      // D0=1, D1=0, D2=0, D3=1
        #ClkPeriod;
        if (Y != 1) begin
            $display("TEST FAILED: S=11, expected Y=1 but got %b", Y);
            $finish;
        end else begin
            $display("TEST PASSED: S=11, Y=%b", Y);
        end

        // All tests passed
        $display("ALL TEST CASES PASSED");
        $finish;
    end

endmodule