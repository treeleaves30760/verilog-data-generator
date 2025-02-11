// 4-to-1 Multiplexer Module
// Inputs: D0, D1, D2, D3
// Control inputs: S0, S1 (binary address to select input)
// Output: Y
module mux_4to1 (
    input logic D0,
    input logic D1,
    input logic D2,
    input logic D3,
    input logic S0,
    input logic S1,
    output logic Y
) 
{
    // When S is "00", output D0; when "01", output D1;
    // when "10", output D2; when "11", output D3
    always_comb begin
        case ({S1, S0})  // Combine S1 and S0 into a 2-bit address
            00: Y = D0;
            01: Y = D1;
            10: Y = D2;
            default: Y = D3;  // Default case for "11"
        endcase
    end
}