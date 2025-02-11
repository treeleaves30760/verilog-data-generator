module mux_2to1 (
    input wire s,
    input wire in0,
    input wire in1,
    output wire out
);

always @(*) begin
    if (s == 0) begin
        out <= in0;
    end else begin
        out <= in1;
    end
end

endmodule