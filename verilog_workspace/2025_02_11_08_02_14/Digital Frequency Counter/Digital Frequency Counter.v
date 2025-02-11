module cnt_8bit (
    input Clk,          // Clock input
    input En,           // Enable input
    input Rst,          // Reset input
    output reg [7:0] Q  // 8-bit counter output
);

always @ (posedge Clk) begin
    if (Rst) begin
        Q <= 0;  // Reset counter to 0 when Rst is high
    else if (En) begin
        Q <= Q + 1;  // Increment counter on rising edge of Clk when En is high
    end
end

endmodule