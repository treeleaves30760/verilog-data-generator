// Comprehensive Testbench for HDMI Transmitter Module

module tb_hdmi_transmitter;

    // Clock Generation
    wire pixel_clock;
    wire tmds_clock;

    // Reset Signal
    wire reset_n;

    // RGB Data Input (24 bits)
    wire [7:0] rgb_data_r, rgb_data_g, rgb_data_b;
    wire [23:0] rgb_data;

    // Sync Signals
    wire hsync, vsync;

    // Audio Data Input (16 bits)
    wire [15:0] audio_data;

    // TMDS Output Differential Pairs
    wire tmds_a_p, tmds_a_n,
         tmds_b_p, tmds_b_n,
         tmds_c_p, tmds_c_n,
         tmds_d_p, tmds_d_n;

    // DUT Instance
    hdmi_transmitter #(
        .PIXEL_CLOCK_FREQ(120),
        .TMDSCLOCK_FREQ(270)
    ) dut (
        .pixel_clock(pixel_clock),
        .reset_n(reset_n),
        .rgb_data_r(rgb_data_r),
        .rgb_data_g(rgb_data_g),
        .rgb_data_b(rgb_data_b),
        .hsync(hsync),
        .vsync(vsync),
        .audio_data(audio_data),
        .tmds_a_p(tmds_a_p), .tmds_a_n(tmds_a_n),
        .tmds_b_p(tmds_b_p), .tmds_b_n(tmds_b_n),
        .tmds_c_p(tmds_c_p), .tmds_c_n(tmds_c_n),
        .tmds_d_p(tmds_d_p), .tmds_d_n(tmds_d_n)
    );

    // Clock Generation
    always begin
        pixel_clock = 0;
        #5ns;
        pixel_clock = 1;
        #5ns;
    end

    always begin
        tmds_clock = 0;
        #2.777ns; // Approximately 360 MHz (for 270 MHz)
        tmds_clock = 1;
        #2.777ns;
    end

    initial begin
        reset_n = 0;
        #10ns;
        reset_n = 1;
    end

    // RGB Data Generation
    integer rgb_r, rgb_g, rgb_b;
    initial begin
        rgb_r = 0;
        rgb_g = 0;
        rgb_b = 0;
        forever begin
            #10ns;
            rgb_r = (rgb_r == 7) ? 0 : rgb_r + 1;
            rgb_g = (rgb_g == 7) ? 0 : rgb_g + 1;
            rgb_b = (rgb_b == 7) ? 0 : rgb_b + 1;
            rgb_data_r = rgb_r;
            rgb_data_g = rgb_g;
            rgb_data_b = rgb_b;
        end
    end

    // Sync Signals Generation
    wire hsync_out, vsync_out;
    initial begin
        hsync_out = 0;
        vsync_out = 0;
        forever begin
            #10ns;
            hsync_out = !hsync_out;
            vsync_out = !vsync_out;
        end
    end

    assign hsync = hsync_out;
    assign vsync = vsync_out;

    // Audio Data Generation
    integer audio_sample;
    initial begin
        audio_sample = 0;
        forever begin
            #10ns;
            audio_sample = (audio_sample == 31) ? 0 : audio_sample + 1;
            audio_data = audio_sample;
        end
    end

    // TMDS Output Monitoring
    // Add logic to monitor and verify the tmds outputs here

endmodule