module dds_core (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  freq_word,     // Frequency word
    input  interpolation_factor,
    output reg [15:0] dac_out
);
    
    reg phase;
    reg [16:0] phase_accumulator;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phase_accumulator <= 0;
            phase <= 0;
        end else begin
            phase_accumulator <= phase_accumulator + freq_word;
            phase <= phase_accumulator[16:1]; // Truncate to match sine table index width
        end
    end
    
    always @(phase) begin
        dac_out = sine_table[phase];
    end
endmodule