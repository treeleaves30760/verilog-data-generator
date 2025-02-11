module tb_mux4to1;
    // Clock generation parameters
    localparam CLOCK_PERIOD = 10 ns;

    // Inputs
    reg D0, D1, D2, D3;
    reg S0, S1;

    // Output
    wire Y;

    // Clock signal
    reg clock;

    // Testbench initial block
    initial begin
        // Initialize all inputs to 0
        D0 = 0; D1 = 0; D2 = 0; D3 = 0;
        S0 = 0; S1 = 0;

        // Generate clock signal
        clock = 0;
        forever begin
            # (CLOCK_PERIOD / 2) clock = ~clock;
        end

        // Test all combinations of S0 and S1
        for (S1 = 0; S1 < 2; S1 = ~S1)
            for (S0 = 0; S0 < 2; S0 = ~S0) {
                // Test all combinations of D0, D1, D2, D3
                for (D3 = 0; D3 < 2; D3 = ~D3)
                    for (D2 = 0; D2 < 2; D2 = ~D2)
                        for (D1 = 0; D1 < 2; D1 = ~D1)
                            for (D0 = 0; D0 < 2; D0 = ~D0) {
                                // Wait a bit to ensure inputs are stable
                                #1ns;
                                // Apply falling edge of clock
                                clock = 0;
                                #1ns;

                                // Check the output based on selection
                                case ({S1, S0})
                                    2'b00: assert(Y == D0) $display("TEST PASSED: Y = D0 (00)"); else $error("TEST FAILED: Y != D0 (00)");
                                    2'b01: assert(Y == D1) $display("TEST PASSED: Y = D1 (01)"); else $error("TEST FAILED: Y != D1 (01)");
                                    2'b10: assert(Y == D2) $display("TEST PASSED: Y = D2 (10)"); else $error("TEST FAILED: Y != D2 (10)");
                                    2'b11: assert(Y == D3) $display("TEST PASSED: Y = D3 (11)"); else $error("TEST FAILED: Y != D3 (11)");
                                endcase
                            }
                        }
                    }
                }
            }
        }

        // Terminate simulation after all tests
        #CLOCK_PERIOD;
        $finish;
    end
endmodule