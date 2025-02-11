module counter (
    input  wire        clk,
    input  wire        rst,
    input  wire        incr,
    input  wire        decr,
    output reg [3:0]   count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 4'b0;
        end else begin
            // Handle increment and decrement with proper sequencing
            if (incr) begin
                count <= count + 1;
            end
            
            // Apply decrement after one clock cycle delay to prevent simultaneous changes
            if (!incr && decr) begin
                count <= count - 1;
            end
        end
    end

endmodule