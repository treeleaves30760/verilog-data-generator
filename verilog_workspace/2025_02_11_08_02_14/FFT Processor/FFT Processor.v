module fft_processor (
    input  wire        clock,
    input  wire        reset,
    input  wire        start,
    input  wire [15:0] real_in,
    input  wire [15:0] imag_in,
    output reg [15:0]  real_out,
    output reg [15:0]  imag_out,
    output reg         done
);

// Define the FFT size (N=16)
localparam STAGES = 4;  // Number of butterfly stages for N=16

reg [2:0] stage_counter;
reg [15:0] real_buffer, imag_buffer;
reg [15:0] addr;
wire [15:0] twiddle_real, twiddle_imag;

// ROM for storing precomputed twiddle factors
memory rom (
    .address(addr),
    .clock(clock),
    .data_out(twiddle_real, twiddle_imag)
);

always @(posedge clock) begin
    if (reset) begin
        // Reset state
        stage_counter <= 0;
        addr <= 0;
        real_buffer <= 0;
        imag_buffer <= 0;
        done <= 0;
    end else if (start) begin
        case(stage_counter) begin
            0: 
                // Initial stage, compute first butterfly operations
                addr <= 0;  // Address for first twiddle factor
                real_buffer <= real_in + twiddle_real * imag_in;
                imag_buffer <= imag_in - twiddle_imag * real_in;
                stage_counter <= 1;
            1: 
                // Second stage of butterfly operations
                addr <= 4;  // Address for next set of twiddle factors
                real_buffer <= real_buffer + twiddle_real * imag_buffer;
                imag_buffer <= imag_buffer - twiddle_imag * real_buffer;
                stage_counter <= 2;
            2: 
                // Third stage of butterfly operations
                addr <= 8;  // Address for next set of twiddle factors
                real_buffer <= real_buffer + twiddle_real * imag_buffer;
                imag_buffer <= imag_buffer - twiddle_imag * real_buffer;
                stage_counter <= 3;
            default:
                // Final stage, apply bit-reversal permutation and complete FFT
                real_out <= real_buffer;
                imag_out <= imag_buffer;
                done <= 1;
        endcase
    end
end

// Assign outputs
assign real_out = real_buffer;
assign imag_out = imag_buffer;

endmodule