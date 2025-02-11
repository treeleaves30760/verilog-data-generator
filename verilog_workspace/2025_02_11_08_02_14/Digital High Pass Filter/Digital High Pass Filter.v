module digital_high_pass_filter (
    input  clk,
    input  rst,
    input  d_in,
    output d_out
);

    // Internal state storage for previous input sample
    reg prev_in;
    
    // Difference equation: y[n] = x[n] - x[n-1]
    always @(posedge clk) begin
        if (rst) begin
            prev_in <= 0;
            d_out   <= 0;
        end else begin
            // Store previous input sample
            reg current_in = d_in;
            // Calculate output as difference between current and previous samples
            d_out <= current_in - prev_in;
            // Update previous input for next cycle
            prev_in <= current_in;
        end
    end

endmodule