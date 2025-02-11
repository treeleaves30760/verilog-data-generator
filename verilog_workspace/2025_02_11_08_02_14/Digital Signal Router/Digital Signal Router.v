module router (
    input wire [15:0] data_in,
    input wire        clk,
    input wire        rst,
    input wire [2:0]  dest_addr,
    output reg [15:0] data_out_0,
    output reg [15:0] data_out_1,
    output reg [15:0] data_out_2,
    output reg [15:0] data_out_3
);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        case (dest_addr)
            0: data_out_0 = data_in;
            1: data_out_1 = data_in;
            2: data_out_2 = data_in;
            3: data_out_3 = data_in;
            default: 
                data_out_0 <= 0;
                data_out_1 <= 0;
                data_out_2 <= 0;
                data_out_3 <= 0;
        endcase
    end else begin
        data_out_0 <= 0;
        data_out_1 <= 0;
        data_out_2 <= 0;
        data_out_3 <= 0;
    end
end

endmodule