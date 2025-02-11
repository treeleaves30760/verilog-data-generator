module tb_full_adder();
    // Inputs
    reg A;
    reg B;
    reg C_in;

    // Outputs
    wire S;
    wire C_out;

    // Clock generation
    always begin
        #5; 
        clock = ~clock;
    end

    initial begin
        clock = 0;
        #10;
        {A, B, C_in} = 0;
        #1;
        if (S != 0 || C_out != 0) $error("Initial state failed");
        
        for (i = 0; i < 8; i++) begin
            A = (i >> 2) & 1;
            B = (i >> 1) & 1;
            C_in = i & 1;
            
            #1;
            if ((S != (A ^ B ^ C_in)) || 
                (C_out != ((A & B) | (A & C_in) | (B & C_in)))) begin
                $error("Test case %d failed", i);
            end else begin
                $display("Test case %d passed", i);
            end
        end
        
        #1;
        $display("All test cases passed");
    end

endmodule