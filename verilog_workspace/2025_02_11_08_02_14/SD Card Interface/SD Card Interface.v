module sd_card_interface (
    input wire clk,
    input wire rst_n,
    input wire [7:0] cmd,
    input wire [3:0] data,
    output wire ack,
    output wire data_valid,
    output wire ready,
    output wire write_protect,
    output wire bus_timeout
);
    
    // Internal signals and counters
    reg [7:0] command;
    reg [3:0] received_data;
    reg clock_counter;
    reg write Protect;
    reg bus_timeout_flag;

    // Clock generation at 25MHz (toggle every 40ns)
    always begin
        #40ns;
       clk = ~clk;
    end

    // Reset handling
    always @(posedge rst_n) begin
        command <= 8'hFF;  // Initialize with invalid command
        received_data <= 4'h0;
        clock_counter <= 0;
        write Protect <= 1;  // Assume write protect is active
        bus_timeout_flag <= 0;
    end

    // Command and data processing
    always @(posedge clk) begin
        if (!rst_n) begin
            command <= 8'hFF;
            received_data <= 4'h0;
            clock_counter <= 0;
            write Protect <= 1;
            bus_timeout_flag <= 0;
        end else begin
            // Command processing logic
            case (cmd)
                8'h00:  // Read operation
                    ack <= 1;
                    data_valid <= 1;
                8'h01:  // Write operation
                    if (!write Protect) begin
                        ack <= 1;
                        ready <= 1;
                    end else begin
                        ack <= 0;
                        ready <= 1;
                    end
                default:  // Invalid command
                    bus_timeout_flag <= 1;
            endcase

            // Data handling logic
            if (data != received_data) begin
                data_valid <= 0;
                write Protect <= 1;
            end else begin
                data_valid <= 1;
                write Protect <= 0;
            end

            // Bus timeout detection
            clock_counter <= clock_counter + 1;
            if (clock_counter >= 25 && bus_timeout_flag) begin
                bus_timeout <= 1;
                clock_counter <= 0;
            end else begin
                bus_timeout <= 0;
            end
        end
    end

    // Output connections
    assign write_protect = write Protect;
    assign bus_timeout = bus_timeout_flag;

endmodule