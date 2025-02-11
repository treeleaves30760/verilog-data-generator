module seven_segment_display (
    input wire             clk,
    input wire             rst,
    input wire [3:0]       seg_data,
    output reg [63:0]      led_matrix
);

    localparam LED_MATRIX_SIZE = 8;

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            led_matrix <= 63'h0;
        end else begin
            case (seg_data[3])
                0 : begin
                    // Calculate the row offset and current row to determine which row of LEDs to light up
                    reg [5:0] row_offset = LED_MATRIX_SIZE - 1;
                    reg [2:0] current_row = 0;

                    led_matrix <= (led_matrix | ((1 << (current_row * LED_MATRIX_SIZE + 7)) >> (current_row * LED_MATRIX_SIZE)));
                end
                // Additional cases can be added here for other segment data configurations
            endcase
        end
    end

endmodule