module PC(
    input wire clk,           // Clock input
    input wire reset,         // Reset signal
    input wire [31:0] pc_next, // Next PC value
    output reg [31:0] pc      // Current PC value
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'h00000000; // Reset to beginning of program memory
        else
            pc <= pc_next;      // Update to next instruction address
    end
endmodule
