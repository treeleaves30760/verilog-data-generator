`timescale 1ns / 1ps

module DigitalSignalGenerator_tb;
    // Define testbench signals
    reg Clk;
    reg Rst;
    reg Wavetype;          // 2 bits (00: Sine, 01: Square, 10: Triangle, 11: Sawtooth)
    reg Freqsel;           // 3 bits (supports 4 different frequencies)
    reg Phaseshift;        // 4 bits (0 to 15 degrees in 1-degree increments)
    reg Amplitude;         // 4 bits (0 to 15 LSB steps)
    wire [15:0] Sout;
    wire Led;

    // Clock generation
    always begin
        Clk = 0;
        #2ns;  // Half period for 50MHz clock
        Clk = 1;
        #2ns;
    end

    // DUT instance
    DigitalSignalGenerator dut (
        .Clk(Clk),
        .Rst(Rst),
        .Wavetype(Wavetype),
        .Freqsel(Freqsel),
        .Phaseshift(Phaseshift),
        .Amplitude(Amplitude),
        .Sout(Sout),
        .Led(Led)
    );

    // Testbench initialization
    initial begin
        // Initialize all testbench signals to 0
        Clk = 0;
        Rst = 1;
        Wavetype = 0;
        Freqsel = 0;
        Phaseshift = 0;
        Amplitude = 0;

        // Print header for simulation output
        $display("Digital Signal Generator Testbench");
        $display("----------------------------------------");
        $display("Time (ns)\tClk\tRst\tWavetype\tFreqsel\tPhaseshift\tAmplitude\tSout\tLed");
    end

    // Reset the DUT at the beginning
    initial begin
        Rst = 1;
        #10ns;
        Rst = 0;
    end

    // Generate test cases
    always begin
        // Iterate through all possible Wavetype values (0 to 3)
        for (Wavetype = 0; Wavetype < 4; Wavetype++) {
            // Iterate through all possible Freqsel values (0 to 7)
            for (Freqsel = 0; Freqsel < 8; Freqsel++) {
                // Iterate through all possible Phaseshift values (0 to 15)
                for (Phaseshift = 0; Phaseshift < 16; Phaseshift++) {
                    // Iterate through all possible Amplitude values (0 to 15)
                    for (Amplitude = 0; Amplitude < 16; Amplitude++) {
                        // Wait for one clock cycle before changing inputs
                        #2ns;
                        
                        // Display current test case parameters and outputs
                        $display("Current Time: %t", $time);
                        $display("Clk: %b", Clk);
                        $display("Rst: %b", Rst);
                        $display("Wavetype: %b", Wavetype);
                        $display("Freqsel: %b", Freqsel);
                        $display("Phaseshift: %b", Phaseshift);
                        $display("Amplitude: %b", Amplitude);
                        $display("Sout: %b", Sout);
                        $display("Led: %b", Led);
                        
                        // Add a delay to allow for signal propagation
                        #10ns;
                    }
                }
            }
        }
    end

endmodule