module spi_master (
    input wire clk,
    input wire rst_n,
    input wire cs_width,
    input wire [7:0] sck_freq_div,
    input wire cpol,
    input wire cpha,
    input wire start,
    input wire [cs_width-1:0] cs_addr,
    input wire [7:0] tx_data,
    input wire [15:0] tx_length,
    input wire enable,
    input wire done,
    output reg sck_out,
    output reg cs_out,
    output reg mosi_out
);