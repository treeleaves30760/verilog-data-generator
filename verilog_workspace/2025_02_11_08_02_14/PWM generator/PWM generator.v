// High-Resolution PWM Generator Module
module pwm_generator (
    input  clk,          // System clock
    input  rst_n,        // Active-low reset signal
    input  enable,       // Enable PWM generation
    input  channel_sel,  // Channel selection (2 bits for 4 channels)
    input  duty_cycle,   // Duty cycle for the selected channel (0 to 100)
    input  sync_in,      // Synchronization input to align PWM output
    output pwm_out,      // Generated PWM signal
    output busy          // Indicates if module is processing a request
);

// Constants and Parameters
`define CLOCK_FREQ        100_000_000  // Example clock frequency in Hz
`define COUNTER_WIDTH     24          // Sufficient for high-resolution timing
`define FREQUENCY_WIDTH   16          // Assuming up to 65535 different frequencies

// State definitions
enum {
    IDLE,
    GENERATE_HIGH,
    GENERATE_LOW,
    SYNC_STATE
} state;

// Channel configuration (example)
typedef struct {
    int duty_cycle;      // Duty cycle for the channel (0 to 100)
    int frequency;       // Frequency in Hz
} channel_config;

channel_config channels[4] = '{ 
    '{10, 1000},        // Channel 0: 10% duty cycle, 1kHz
    '{25, 500},         // Channel 1: 25% duty cycle, 500Hz
    '{50, 1000},        // Channel 2: 50% duty cycle, 1kHz
    '{75, 2000}         // Channel 3: 75% duty cycle, 2kHz
};

// Internal signals and counters
reg [`COUNTER_WIDTH-1 : 0] counter;
reg [`FREQUENCY_WIDTH-1 : 0] period;

// Calculate the period based on frequency
function automatic int calculate_period(input int freq);
    if (freq == 0) return 0;
    return (`CLOCK_FREQ / freq);
endfunction

// Main state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        period <= 0;
        state <= IDLE;
        busy <= 0;
        pwm_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                // Wait for enable signal or new channel selection
                if (enable || sync_in) begin
                    // Calculate the period based on selected channel's frequency
                    period = calculate_period(channels[channel_sel].frequency);
                    // Set duty cycle by adjusting the high and low times
                    counter <= 0;
                    state <= GENERATE_HIGH;
                    busy <= 1;
                end else begin
                    state <= IDLE;
                    busy <= 0;
                end
            end

            GENERATE_HIGH: begin
                if (counter < (period * channels[channel_sel].duty_cycle / 100)) begin
                    pwm_out = 1;
                    counter++;
                    state <= GENERATE_HIGH;
                end else begin
                    counter <= 0;
                    state <= GENERATE_LOW;
                end
            end

            GENERATE_LOW: begin
                if (counter < (period - (period * channels[channel_sel].duty_cycle / 100))) begin
                    pwm_out = 0;
                    counter++;
                    state <= GENERATE_LOW;
                end else begin
                    counter <= 0;
                    state <= IDLE;
                    busy <= 0;
                end
            end

            SYNC_STATE: begin
                // Synchronization logic to align PWM output
                counter <= 0;
                period = calculate_period(channels[channel_sel].frequency);
                state <= GENERATE_HIGH;
                busy <= 1;
            end
        endcase
    end
end

// Output the current state of pwm_out
assign pwm_out = (state == GENERATE_HIGH) ? 1 : 0;

// Indicate when the module is processing a request
assign busy = (state != IDLE);

endmodule