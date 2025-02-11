module generic_fifobuffer_testbench;

    // Define parameters for the FIFO
    parameter WIDTH = 8;
    parameter DEPTH = 4;

    // Clock and reset signals
    reg clk;
    reg rst_n;

    // Write control signals
    reg wr_en;
    reg [WIDTH-1:0] din;

    // Read control signal
    reg rd_en;

    // Output signals
    wire [WIDTH-1:0] dout;
    wire full, empty, almost_full;

    // Instantiate the FIFO module under test
    generic_fifobuffer #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty),
        .almost_full(almost_full)
    );

    // Testbench clock generation
    initial begin
        clk = 0;
        forever #5clk = ~clk;
    end

    // Testbench reset and control logic
    initial begin
        rst_n = 0;  // Reset at start
        din = 0;

        // Wait for one clock cycle to ensure proper reset
        #10;

        rst_n = 1;  // Release reset

        // Test sequence begins here
        // Write and read operations will be simulated below
    end

    // Stimulus generation (write operations)
    initial begin
        // Testbench code for writing data into FIFO
        // Add test cases here
        #20;
        wr_en = 1; din = 8'hAA;
        #5;
        wr_en = 1; din = 8'hBB;
        #5;
        wr_en = 1; din = 8'hCC;
        #5;
        wr_en = 1; din = 8'hDD;
        #5;
        wr_en = 0;

        // Now, start reading
        rd_en = 1;
        #5;
        rd_en = 0;
        #5;
        rd_en = 1;
        #5;
        rd_en = 0;
        #5;
    end

endmodule