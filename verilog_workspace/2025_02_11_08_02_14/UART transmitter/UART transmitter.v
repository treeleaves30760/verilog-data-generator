module uart_receiver (
    input clk,
    input rst,
    input rx,
    output reg [7:0] data_out,
    output reg frame_error,
    output reg overrun_error
);

    // State machine states
    typedef enum {
        IDLE,
        START_BIT,
        DATA_BITS,
        PARITY_BIT,
        STOP_BIT
    } state_t;

    state_t state;
    
    // Internal signals
    reg [7:0] rx_data_reg;
    reg parity_error;
    reg frame_done;
    reg [4:0] baud_counter;  // BAUD_RATE = 16 (5 bits for counter)
    wire start_edge;

    // Baud rate generator
    always @(posedge clk) begin
        if (rst) begin
            baud_counter <= 0;
        end else begin
            if (baud_counter == BAUD_RATE - 1) begin
                baud_counter <= 0;
            end else begin
                baud_counter <= baud_counter + 1;
            end
        end
    end

    // Detect falling edge on rx to indicate start bit
    always @(posedge clk) begin
        if (rst) begin
            start_edge <= 0;
        end else begin
            start_edge <= (rx == 1'b0 && !prev_rx);
        end
    end

    // Store previous state of rx for edge detection
    reg prev_rx;
    always @(posedge clk) begin
        if (rst) begin
            prev_rx <= 0;
        end else begin
            prev_rx <= rx;
        end
    end

    // Main state machine
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            data_out <= 0;
            frame_error <= 0;
            overrun_error <= 0;
        end else case (state) {
            IDLE: begin
                if (start_edge) begin
                    state <= START_BIT;
                end
            end,
            START_BIT: begin
                if (baud_counter == BAUD_RATE - 1) begin
                    state <= DATA_BITS;
                end
            end,
            DATA_BITS: begin
                // Shift in data bits
                rx_data_reg <= {rx, rx_data_reg[7:1]};
                if (baud_counter == BAUD_RATE - 1) begin
                    state <= PARITY_BIT;
                end
            end,
            PARITY_BIT: begin
                // Check even parity
                parity_error = (~^(rx_data_reg)) ^ rx;
                if (baud_counter == BAUD_RATE - 1) begin
                    state <= STOP_BIT;
                end
            end,
            STOP_BIT: begin
                if (baud_counter == BAUD_RATE - 1) begin
                    if (rx) begin
                        // Valid stop bit, frame received
                        data_out <= rx_data_reg[7:1];
                        frame_error <= parity_error;
                        state <= IDLE;
                    end else begin
                        // Invalid stop bit
                        frame_error <= 1;
                        state <= IDLE;
                    end
                end
            end
        }
    end

    // Handle overruns when a new start is detected while processing
    always @(posedge clk) begin
        if (state == IDLE && start_edge) begin
            if (!frame_done) begin  // Previous frame not completed
                overrun_error <= 1;
            end
        end
    end

endmodule