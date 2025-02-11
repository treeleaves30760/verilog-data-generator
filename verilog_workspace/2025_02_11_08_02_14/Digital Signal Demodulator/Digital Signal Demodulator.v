module digital_signal_demodulator (
    input  clock,
    input  reset_n,
    input  modulated_data_in,
    output demodulated_data_out,
    output error_flag,
    output lock
);

    // Internal signals and state variables
    reg [7:0] data_buffer;
    reg       buffer_full;
    reg       error_detected;
    reg       locked;

    // Demodulation process
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            data_buffer <= 0;
            buffer_full <= 0;
            error_detected <= 0;
            locked <= 0;
        end else begin
            // Simulate filtering and demodulation logic here
            // This is a simplified version for demonstration purposes
            if (modulated_data_in) begin
                data_buffer <= modulated_data_in;
                buffer_full <= 1;
                error_detected <= 0;
            end else begin
                error_detected <= 1;
            end
            
            locked <= buffer_full & ~error_detected;
        end
    end

    // Output assignments with propagation delay
    assign demodulated_data_out = data_buffer;          // Small delay for combinational logic
    assign error_flag = error_detected;                 // Small delay to simulate detection time
    assign lock = locked;                               // Longer delay to simulate synchronization process
endmodule