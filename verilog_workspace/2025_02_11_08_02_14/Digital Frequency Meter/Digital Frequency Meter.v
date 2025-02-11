module edge_detector(input wire input_signal, clk, rst, output reg detect);
    reg prev_state;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_state <= 0;
            detect <= 0;
        end else begin
            prev_state <= input_signal;
            if (~prev_state & input_signal) detect <= 1; // Rising edge detection
            else detect <= 0;
        end
    end
endmodule