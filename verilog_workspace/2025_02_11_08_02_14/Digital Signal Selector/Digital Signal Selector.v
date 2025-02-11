module sel_4to1;
    // Inputs
    input Clk;          // Clock signal
    input Rst_n;        // Reset signal (active high)
    input D0;           // Data input 0
    input D1;           // Data input 1
    input D2;           // Data input 2
    input D3;           // Data input 3
    input [1:0] S;      // Select control (2 bits)

    // Output
    output Y;           // Selected output

    // Internal signals
    reg y_reg;
    reg [1:0] s_reg;

    // Flip-flop to capture inputs synchronously
    DFF ff (
        .clk(Clk),
        .rst(~Rst_n),  // Active low reset for D-type FF
        .d({D3, D2, D1, D0}),  // All data inputs concatenated
        .q(s_reg)       // Store the select and data in s_reg
    );

    // Synchronous selection logic
    always @(posedge Clk or negedge Rst_n) begin
        if (~Rst_n) begin
            y_reg <= 0;
        end else begin
            case (s_reg)
                2'b00: y_reg = D0;
                2'b01: y_reg = D1;
                2'b10: y_reg = D2;
                2'b11: y_reg = D3;
                default: y_reg = 0;  // Default to 0 if S is invalid
            endcase
        end
    end

    // Output the selected value
    assign Y = y_reg;

endmodule

// Define a simple D-type flip-flop for internal use
module DFF;
    input clk;
    input rst;
    input d;           // Data input (can be multiple bits)
    output reg q;       // Registered output

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end
endmodule