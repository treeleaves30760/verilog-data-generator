module DigitalSignalDemultiplexer (
    input data_in,
    input [1:0] sel,
    input clk,
    input rst,
    output data_out_0,
    output data_out_1,
    output data_out_2,
    output data_out_3
);

    always @(posedge clk) begin
        if (rst) begin
            data_out_0 <= 0;
            data_out_1 <= 0;
            data_out_2 <= 0;
            data_out_3 <= 0;
        end else begin
            case (sel)
                0: 
                    data_out_0 <= data_in;
                    data_out_1 <= 0;
                    data_out_2 <= 0;
                    data_out_3 <= 0;
                1:
                    data_out_0 <= 0;
                    data_out_1 <= data_in;
                    data_out_2 <= 0;
                    data_out_3 <= 0;
                2: 
                    data_out_0 <= 0;
                    data_out_1 <= 0;
                    data_out_2 <= data_in;
                    data_out_3 <= 0;
                3:
                    data_out_0 <= 0;
                    data_out_1 <= 0;
                    data_out_2 <= 0;
                    data_out_3 <= data_in;
                default: 
                    data_out_0 <= 0;
                    data_out_1 <= 0;
                    data_out_2 <= 0;
                    data_out_3 <= 0;
            endcase
        end
    end

endmodule