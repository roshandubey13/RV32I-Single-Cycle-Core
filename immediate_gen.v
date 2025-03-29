module immediate_gen(
    input wire [31:0] instruction,  // Full instruction
    output reg [31:0] immediate    // Generated immediate value
);
    wire [6:0] opcode = instruction[6:0];
    
    always @(*) begin
        case (opcode)
            // I-type instructions
            7'b0010011, 7'b0000011, 7'b1100111: 
                immediate = {{20{instruction[31]}}, instruction[31:20]};
            
            // S-type instructions
            7'b0100011: 
                immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            
            // B-type instructions
            7'b1100011: 
                immediate = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            
            // U-type instructions
            7'b0110111, 7'b0010111: 
                immediate = {instruction[31:12], 12'h000};
            
            // J-type instructions
            7'b1101111: 
                immediate = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            
            default: immediate = 32'h00000000;
        endcase
    end
endmodule
