module digital_slicer (
    input  clk,
    input  rst_n,
    input  vin,
    input  vref,
    input  [7:0] pulse_width,
    output dout
);

// Internal state to track whether the condition is met and count pulses
reg condition_met;
reg [7:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        condition_met <= 0;
        counter <= 0;
        dout <= 0;
    end else begin
        // Convert analog inputs to digital for comparison
        wire vin_digital = $adc(vin, 8'b1111_1111);
        wire vref_digital = $adc(vref, 8'b1111_1111);

        // Check if VIN exceeds VREF
        condition_met <= (vin_digital > vref_digital);

        // Update output based on condition and counter
        if (condition_met) begin
            // Start counting when condition is met
            if (counter < pulse_width - 1) begin
                counter <= counter + 1;
                dout <= 1;
            end else begin
                // Turn off after specified pulse width
                dout <= 0;
                counter <= 0;
            end
        end else begin
            // Keep output low if condition not met
            dout <= 0;
            counter <= 0;  // Reset counter when condition is false
        end
    end
end

endmodule