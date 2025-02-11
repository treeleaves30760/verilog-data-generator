module traffic_light_controller_testbench;
    // Define clock signal with 10ns period (100MHz)
    localparam CLK_PERIOD = 10 ns;
    
    // Clock generation
    reg [7:0] clk;
    initial begin
        clk = 0;
        forever begin
            #CLK_PERIOD;
            clk = ~clk;
        end
    end
    
    // DUT inputs
    reg rst, start;
    reg [3:0] pedestrian;
    
    // DUT outputs
    wire [2:0] traffic_light;
    wire pedestrian_grant;
    wire violation;
    
    // DUT instance
    traffic_light_controller dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .pedestrian(pedestrian),
        .traffic_light(traffic_light),
        .pedestrian_grant(pedestrian_grant),
        .violation(violation)
    );
    
    // Test cases
    initial begin
        $display("Starting traffic light controller testbench");
        
        // Initialize inputs
        rst = 1;
        start = 0;
        pedestrian = 0;
        
        // Apply reset for 100ns
        #100ns rst <= 0;
        
        // Test all pedestrian input combinations (4 bits: 0 to 15)
        for (pedestrian = 0; pedestrian < 16; pedestrian++) begin
            #CLK_PERIOD;
            
            // Activate start signal for the last test case
            if (pedestrian == 15) 
                start = 1;
            
            // Monitor and verify outputs
            $display("Pedestrian input: %b", pedestrian);
            $display("Traffic light: %b", traffic_light);
            $display("Pedestrian grant: %b", pedestrian_grant);
            $display("Violation detected: %b", violation);
            
            // Check for violations during test cases
            if (violation) begin
                $display("Testbench Error: Violation occurred at pedestrian input %b", pedestrian);
                $finish;
            end
            
            #200ns;  // Wait for two full cycles to observe behavior
        end
        
        $display("All test cases completed successfully");
        $finish;
    end
    
    // Optional: Add additional assertions or checks here
endmodule