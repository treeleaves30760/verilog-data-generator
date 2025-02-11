module mux4to1 (
    input D0, D1, D2, D3,
    input S0, S1,
    output Y
);
    
    // This module selects one of four inputs based on 2-bit control signals S1 and S0
    always @(*) begin
        case ({S1, S0})  // Combine S1 (MSB) and S0 (LSB) into a 2-bit address
            2'b00: Y = D0;  // Select D0 when S1=0, S0=0
            2'b01: Y = D1;  // Select D1 when S1=0, S0=1
            2'b10: Y = D2;  // Select D2 when S1=1, S0=0
            2'b11: Y = D3;  // Select D3 when S1=1, S0=1
        endcase
    end
    
endmodule