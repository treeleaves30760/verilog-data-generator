module dds_core (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  [31:0] freq_word,     // Frequency word
    input  [7:0] interpolation_factor,
    output reg [15:0] dac_out
);

    // Phase accumulator and current phase registers
    reg [16:0] phase_accumulator;
    reg [15:0] current_phase;

    // Sine table lookup
    localparam sine_table = {
        16'h8000, 16'h7FFF, 16'h6FFF, 16'h6000,
        16'h4999, 16'h3FFF, 16'h2FFD, 16'h1FFC,
        16'h0000, 16'h1FF8, 16'h2FFA, 16'h3FFB,
        16'h499D, 16'h5FFF, 16'h6FFC, 16'h7FFE
    };

    // Phase accumulation logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phase_accumulator <= 0;
            current_phase <= 0;
        end else begin
            phase_accumulator <= phase_accumulator + freq_word;
            current_phase <= phase_accumulator[16:1]; // Truncate to match sine table index width
        end
    end

    // DAC output generation with interpolation
    always @(current_phase or interpolation_factor) begin
        integer i, step;
        reg [15:0] samples[4];

        // Load interpolated samples from sine_table based on current phase and interpolation factor
        for (i = 0; i < 4; i++) begin
            step = (interpolation_factor * i);
            samples[i] = sine_table[current_phase + step];
        end

        // Average the samples to generate smooth output
        dac_out = (samples[0] + samples[1] + samples[2] + samples[3]) / 4;
    end
endmodule