module digital_diff (
    input data_in,
    input clk,
    input rst,
    output diff_out,
    output valid
);

// Internal signals
reg prev_data;
reg valid_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        prev_data <= 0;
        valid_reg <= 0;
    end else begin
        // Capture previous data on rising edge of clock
        if (!valid_reg) begin
            prev_data <= data_in;
            valid_reg <= 1;
        end else begin
            // Compute difference after one cycle delay
            diff_out <= (data_in != prev_data);
            prev_data <= data_in;
        end
    end
end

assign valid = valid_reg;

endmodule