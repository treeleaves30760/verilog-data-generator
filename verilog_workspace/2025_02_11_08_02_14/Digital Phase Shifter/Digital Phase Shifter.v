module DigitalPhaseShifter (
    input aclk,
    input aclr,
    input [8:0] shift_amount,
    input direction,
    output dout,
    output error
);
    
// Internal signals and counters
reg [$clog2(361)-1 : 0] phase_counter; // Sufficient width to cover 360 degrees
reg error_flag;
reg current_phase;

always @(posedge aclk) begin
    if (aclr) begin
        phase_counter <= 0;
        error_flag <= 0;
        current_phase <= 0;
    end else begin
        // Calculate new phase based on shift_amount and direction
        if (direction) begin
            phase_counter <= current_phase - shift_amount;
        end else begin
            phase_counter <= current_phase + shift_amount;
        end
        
        // Check for overflow beyond กำ360 degrees
        if ($abs(phase_counter) > 360 || $abs(shift_amount) == 512) begin
            error_flag <= 1;
        end else begin
            error_flag <= 0;
        end
        
        current_phase <= phase_counter % 360; // Wrap around modulo 360 degrees
    end
end

// Output the adjusted phase as a clock signal
assign dout = current_phase;
assign error = error_flag;

endmodule