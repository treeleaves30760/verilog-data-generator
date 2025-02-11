module four_bit_counter (
    input clk,
    input rst,
    output reg [3:0] count_out
);

always @(posedge clk) begin
    if (rst) begin
        count_out <= 4'b0000;
    else begin
        count_out <= count_out + 1;
        if (count_out == 4'b1111) begin
            count_out <= 4'b0000;
        end
    end
end

endmodule