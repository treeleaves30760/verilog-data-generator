module comparator_4bit (
    input wire [3:0] A,
    input wire [3:0] B,
    input wire clk,
    input wire rst,
    output reg E,
    output reg G,
    output reg L
);

    // Reset signals
    always @(posedge rst) begin
        E <= 0;
        G <= 0;
        L <= 0;
    end

    // Clocking process for comparison logic
    always @(posedge clk) begin
        if (rst == 1) begin
            E <= 0;
            G <= 0;
            L <= 0;
        end else begin
            E <= 0;
            G <= 0;
            L <= 0;

            // Compare each bit from MSB to LSB
            if (A[3] > B[3]) begin
                G <= 1;
            elsif (A[3] < B[3]) begin
                L <= 1;
            end else begin
                // If MSBs are equal, move to next bit
                if (A[2] > B[2]) begin
                    G <= 1;
                elsif (A[2] < B[2]) begin
                    L <= 1;
                end else begin
                    if (A[1] > B[1]) begin
                        G <= 1;
                    elsif (A[1] < B[1]) begin
                        L <= 1;
                    end else begin
                        if (A[0] > B[0]) begin
                            G <= 1;
                        elsif (A[0] < B[0]) begin
                            L <= 1;
                        end else begin
                            E <= 1;
                        end
                    end
                end
            end
        end
    end

endmodule