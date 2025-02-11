module mux4to1 (
    input wire data_in0,
    input wire data_in1,
    input wire data_in2,
    input wire data_in3,
    input wire sel0,
    input wire sel1,
    output wire y
);

    // This module selects between four input lines based on the two control signals sel1 and sel0
    case ({sel1, sel0}) // Combining both control signals into a 2-bit selector
        0:   y = data_in0;     // When sel is 00, output data_in0
        1:   y = data_in1;     // When sel is 01, output data_in1
        2:   y = data_in2;     // When sel is 10, output data_in2
        default: y = data_in3;  // All other cases (sel is 11), output data_in3
    endcase

endmodule