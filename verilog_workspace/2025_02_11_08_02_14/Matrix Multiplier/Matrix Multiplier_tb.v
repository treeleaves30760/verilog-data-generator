module tb_matrix_multiplier;
    // Define matrix multiplier module
    Matrix_Multiplier DUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .A(A),
        .B(B),
        .C(C),
        .done(done)
    );

    // Clock generation
    always begin
        clk = 0;
        #10;  // 50MHz clock (period=20ns)
        clk = 1;
        #10;
    end

    // Reset signal
    initial begin
        rst = 1;
        #20;  // Wait for two clock cycles to ensure reset is applied
        rst = 0;
    end

    // Start signal
    initial begin
        start = 0;
        #30;  // Wait until after reset and clock cycles
        start = 1;
        #10;
        start = 0;
    end

    // Initialize matrices A and B with specific patterns
    initial begin
        for (i = 0; i < 8; i++) begin
            for (j = 0; j < 8; j++) begin
                A[i][j] = {16{i + j}};  // Example pattern: A[i][j] = i + j (16-bit)
                B[i][j] = {16{i * j}};  // Example pattern: B[i][j] = i * j (16-bit)
            end
        end

        #20;  // Wait until after reset and start is asserted
    end

    // Monitor done signal and check results
    initial begin
        @(posedge done);
        $display("Matrix multiplication completed successfully");
        
        // Verify each element of C
        for (i = 0; i < 8; i++) begin
            for (j = 0; j < 8; j++) begin
                // Calculate expected value based on A and B patterns
                integer expected_val;
                expected_val = 0;
                for (k = 0; k < 8; k++) begin
                    expected_val += (A[i][k] * B[k][j]);
                end
                if (C[i][j] != expected_val) begin
                    $error("Mismatch at C[%d][%d]: Expected %h, Actual %h", i, j, expected_val, C[i][j]);
                end
            end
        end
        
        $display("All tests passed successfully");
        $finish;
    end

    // Tasks to display matrices
    task display_matrix;
        input [7:0] matrix[8][8];
        string name;
        begin
            for (i = 0; i < 8; i++) begin
                $display("%s row %d: %h", name, i, matrix[i]);
            end
            $display("----------------------------------------");
        end
    endtask

    // Final termination if simulation ends without completion
    final begin
        $fatal("Simulation ended without completion");
    end
endmodule