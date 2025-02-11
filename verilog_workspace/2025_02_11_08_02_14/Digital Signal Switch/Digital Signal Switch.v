module mux_2to1 (
    input IN_A,         // First input signal
    input IN_B,         // Second input signal
    input SEL,          // Selection control signal (0 selects IN_A, 1 selects IN_B)
    input RST,          // Active-high reset signal
    input CLK,          // Clock signal at 50 MHz
    output OUT           // Output signal (routes either IN_A or IN_B based on SEL)
);
    
    // Internal signals for synchronized inputs
    wire a_sync, b_sync;
    
    // Synchronize inputs with clock
    DFlipFlopdff_a (
        .clk(CLK),
        .rst(RST),
        .d(IN_A),
        .q(a_sync)
    );
    
    DFlipFlopdff_b (
        .clk(CLK),
        .rst(RST),
        .d(IN_B),
        .q(b_sync)
    );
    
    // Synchronous selection logic
    always @(posedge CLK) begin
        if (RST) begin
            OUT <= 0;  // Reset state: output is 0
        end else begin
            case (SEL)
                0: OUT <= a_sync;  // Select IN_A
                default: OUT <= b_sync;  // Select IN_B
            endcase
        end
    end
    
endmodule

// D-Type Flip-Flop Definition
module DFlipFlopdff_a (
    input clk,
    input rst,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (rst) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end
endmodule

module DFlipFlopdff_b (
    input clk,
    input rst,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (rst) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end
endmodule