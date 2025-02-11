module i2c_slave (
    input wire scl,
    input wire sda,
    output reg scl_out,
    output reg sda_out
);

// Define states for the state machine
typedef enum {
    IDLE,
    START,
    ADDRESS_RECEIVE,
    DATA_RECEIVE,
    ACKNOWLEDGE,
    STOP
} state_t;

state_t state = IDLE;

reg [7:0] received_address;
reg [7:0] data_buffer;
reg buffer_full;
reg buffer_empty;
reg acknowledge;

// Timing constants
parameter CLOCK_STRETCH_TIME = 10; // Time in units for clock stretching

always @(posedge scl) begin
    case (state)
        IDLE: begin
            if (~scl & ~sda) begin // Start condition detected
                state <= START;
            end
        end
        
        START: begin
            state <= ADDRESS_RECEIVE;
        end
        
        ADDRESS_RECEIVE: begin
            received_address <= {sda, received_address[6:0]}; // Shift in address bits
            if (received_address == 7'b1111111) begin // Example address check
                state <= DATA_RECEIVE;
            end else begin
                state <= IDLE; // Address mismatch, return to idle
            end
        end
        
        DATA_RECEIVE: begin
            data_buffer <= {sda, data_buffer[6:0]}; // Shift in data bits
            buffer_full <= 1;
            state <= ACKNOWLEDGE;
        end
        
        ACKNOWLEDGE: begin
            acknowledge <= ~buffer_full; // Generate ACK/NACK
            if (acknowledge) begin
                state <= STOP;
            end else begin
                state <= TRANSMIT;
            end
        end
        
        STOP: begin
            state <= IDLE;
        end
    endcase
    
    // Clock stretching logic
    if (state == ADDRESS_RECEIVE || state == DATA_RECEIVE) begin
        scl_out <= 1'b0; // Stretch clock low
        #CLOCK_STRETCH_TIME;
        scl_out <= 1'b1; // Release clock
    end
end

always @* begin
    case (state)
        IDLE: begin
            scl_out <= 'Z; // High impedance
            sda_out <= 'Z;
        end
        
        START: begin
            scl_out <= 1'b0; // Drive SCL low
            sda_out <= 1'b0; // Drive SDA low for start condition
        end
        
        ADDRESS_RECEIVE: begin
            scl_out <= 1'b0; // Clock is driven low by master, no need to drive
            sda_out <= 'Z; // High impedance during address reception
        end
        
        DATA_RECEIVE: begin
            scl_out <= 1'b0; // Clock is driven low by master
            sda_out <= 'Z; // High impedance during data reception
        end
        
        ACKNOWLEDGE: begin
            scl_out <= 1'b1; // Release clock after acknowledge/NACK
            sda_out <= acknowledge ? 1'b0 : 1'b1;
        end
        
        STOP: begin
            scl_out <= 1'b1; // Clock released high
            sda_out <= 1'b1; // SDA released high for stop condition
        end
    endcase
end

// Reset logic (optional)
reset input rst,
always @(rst) begin
    state <= IDLE;
    received_address <= 0;
    data_buffer <= 0;
    buffer_full <= 0;
    buffer_empty <= 1;
    acknowledge <= 0;
end

endmodule