module alu(
    input wire [31:0] src_a,     // First operand
    input wire [31:0] src_b,     // Second operand
    input wire [3:0] alu_control, // Operation control
    output reg [31:0] alu_result, // Result
    output wire zero            // Zero flag
);
    // ALU operations
    parameter ALU_ADD = 4'b0000;
    parameter ALU_SUB = 4'b0001;
    parameter ALU_AND = 4'b0010;
    parameter ALU_OR  = 4'b0011;
    parameter ALU_XOR = 4'b0100;
    parameter ALU_SLT = 4'b0101;
    parameter ALU_SLL = 4'b0110;
    parameter ALU_SRL = 4'b0111;
    parameter ALU_SRA = 4'b1000;
    
    // ALU operation
    always @(*) begin
        case (alu_control)
            ALU_ADD: alu_result = src_a + src_b;
            ALU_SUB: alu_result = src_a - src_b;
            ALU_AND: alu_result = src_a & src_b;
            ALU_OR:  alu_result = src_a | src_b;
            ALU_XOR: alu_result = src_a ^ src_b;
            ALU_SLT: alu_result = ($signed(src_a) < $signed(src_b)) ? 32'h1 : 32'h0;
            ALU_SLL: alu_result = src_a << src_b[4:0];
            ALU_SRL: alu_result = src_a >> src_b[4:0];
            ALU_SRA: alu_result = $signed(src_a) >>> src_b[4:0];
            default: alu_result = 32'h00000000;
        endcase
    end
    
    // Zero flag
    assign zero = (alu_result == 32'h00000000);
endmodule
