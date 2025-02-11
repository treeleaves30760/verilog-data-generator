module mux_4to1 (
    input wire D0,
    input wire D1,
    input wire D2,
    input wire D3,
    input wire S0,
    input wire S1,
    output wire Y
);

    // Case statement to select one of four inputs based on control signals S1 and S0
    assign Y = (S1 == 0 && S0 == 0) ? D0 :
               (S1 == 0 && S0 == 1) ? D1 :
               (S1 == 1 && S0 == 0) ? D2 :
               D3;

endmodule