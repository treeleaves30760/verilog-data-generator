// 2-to-1 Multiplexer Module
// This module selects between two input signals based on the selection control signal
module mux_2to1 (
    input wire sel,   // Selection control (0: in0, 1: in1)
    input wire in0,   // First data input
    input wire in1,   // Second data input
    output wire out   // Output selected from in0 or in1
);

    always @ (sel) begin
        case (sel)
            0: out = in0;  // When sel is 0, output in0
            1: out = in1;  // When sel is 1, output in1
        endcase
    end

endmodule