module digital_oscillator (
    input rst, en, freq_select, duty_cycle_sel, phase_shift_sel,
    input clk,
    output reg oscl_out
);

// Internal signals and counters
reg [1:0] state_counter;
reg [2:0] phase_shifter;

// Frequency selection logic
always @ (posedge clk) begin
    if (rst) begin
        oscl_out <= 0;
        state_counter <= 0;
        phase_shifter <= 0;
    end else begin
        if (en) begin
            // Frequency divider based on freq_select
            case (freq_select)
                0: state_counter <= 2'b11; // Lower frequency
                default: state_counter <= 2'b00; // Higher frequency
            endcase
            
            // Determine the output based on state and duty cycle
            if (state_counter == 0) begin
                oscl_out = 1;
            end else begin
                oscl_out = 0;
            end
            
            // Apply phase shift
            case (phase_shift_sel)
                1: phase_shifter <= {oscl_out, phase_shifter[2]};
                2: phase_shifter <= {1'b0, phase_shifter[2], phase_shifter[1]};
                default: phase_shifter <= 3'b0;
            endcase
        end
    end
end

// Output the final phase-shifted signal
assign oscl_out = phase_shifter[0];

endmodule