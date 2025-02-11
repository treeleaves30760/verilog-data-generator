module tb_full_adder_2bit;
    // Define the clock period (10 ns)
    timeunit 1ns;
    
    // Clock signal
    wire clk;
    
    // Reset signal
    reg rst;
    
    // Inputs to the full adder
    reg A, B, C_in;
    
    // Outputs from the full adder
    wire S, C_out;
    
    // Strobe signal to indicate when inputs are valid
    reg strobe;
    
    // DUT (Design Under Test) instantiation
    full_adder_2bit DUT (
        .A(A),
        .B(B),
        .C_in(C_in),
        .S(S),
        .C_out(C_out)
    );
    
    // Clock generator
    always begin
        clk = 1; #5ns;
        clk = 0; #5ns;
    end
    
    initial begin
        rst = 1;
        #20ns; // Reset after two clock periods
        rst = 0;
        
        strobe = 0;
        A = 0; B = 0; C_in = 0;
        #CLOCK_PERIOD;
        
        for (int i=0; i<8; i++) begin
            // Generate all possible input combinations
            {A, B, C_in} = i[2:0]; // Extract bits to assign to A, B, C_in
            
            strobe <= 1;
            #CLOCK_PERIOD;
            
            strobe <= 0;
            #CLOCK_PERIOD;
            
            // Calculate expected sum and carry
            wire expected_S = (A ^ B ^ C_in);
            wire expected_C_out = ((A & B) | (A & C_in) | (B & C_in));
            
            if ($time == 0)
                $display("i | A B C_in | S C_out | Expected S C_out");
            else
                $display("%d | %b %b %b | %b %b | %b %b", 
                         i, A, B, C_in, S, C_out, expected_S, expected_C_out);
            
            if (S == expected_S && C_out == expected_C_out) begin
                $display("  Test case %d: PASS", i);
            end else begin
                $display("  Test case %d: FAIL", i);
            end
            
            #CLOCK_PERIOD;
        end
        
        $display("\nSimulation completed successfully!");
    end
    
endmodule