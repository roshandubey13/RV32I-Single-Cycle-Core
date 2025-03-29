module control_unit(
    input wire [6:0] opcode,       // Instruction opcode
    input wire [2:0] funct3,       // Function field (funct3)
    input wire [6:0] funct7,       // Function field (funct7)
    output reg [1:0] pc_src,       // PC source control
    output reg [1:0] result_src,   // Result source control
    output reg mem_write,          // Memory write enable
    output reg alu_src,            // ALU source B control
    output reg reg_write,          // Register write enable
    output reg [3:0] alu_control   // ALU operation control
);
    // Main decoder
    always @(*) begin
        // Default values
        pc_src = 2'b00;       // PC + 4
        result_src = 2'b00;   // ALU result
        mem_write = 1'b0;     // No memory write
        alu_src = 1'b0;       // Register file for ALU source B
        reg_write = 1'b0;     // No register write
        
        case (opcode)
            // R-type instructions
            7'b0110011: begin
                reg_write = 1'b1;
                
                // ALU operation based on funct3 and funct7
                case (funct3)
                    3'b000: alu_control = (funct7[5]) ? 4'b0001 : 4'b0000; // SUB or ADD
                    3'b001: alu_control = 4'b0110; // SLL
                    3'b010: alu_control = 4'b0101; // SLT
                    3'b100: alu_control = 4'b0100; // XOR
                    3'b101: alu_control = (funct7[5]) ? 4'b1000 : 4'b0111; // SRA or SRL
                    3'b110: alu_control = 4'b0011; // OR
                    3'b111: alu_control = 4'b0010; // AND
                    default: alu_control = 4'b0000;
                endcase
            end
            
            // I-type instructions (immediate arithmetic)
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src = 1'b1; // Use immediate as ALU source B
                
                case (funct3)
                    3'b000: alu_control = 4'b0000; // ADDI
                    3'b001: alu_control = 4'b0110; // SLLI
                    3'b010: alu_control = 4'b0101; // SLTI
                    3'b100: alu_control = 4'b0100; // XORI
                    3'b101: alu_control = (funct7[5]) ? 4'b1000 : 4'b0111; // SRAI or SRLI
                    3'b110: alu_control = 4'b0011; // ORI
                    3'b111: alu_control = 4'b0010; // ANDI
                    default: alu_control = 4'b0000;
                endcase
            end
            
            // Load instructions
            7'b0000011: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                result_src = 2'b01; // Memory read result
                alu_control = 4'b0000; // ADD for address calculation
            end
            
            // Store instructions
            7'b0100011: begin
                mem_write = 1'b1;
                alu_src = 1'b1;
                alu_control = 4'b0000; // ADD for address calculation
            end
            
            // Branch instructions
            7'b1100011: begin
                pc_src = 2'b01; // Branch target
                alu_control = 4'b0001; // SUB for comparison
            end
            
            // JAL instruction
            7'b1101111: begin
                reg_write = 1'b1;
                pc_src = 2'b10; // Jump target
                result_src = 2'b10; // PC + 4 for return address
            end
            
            // JALR instruction
            7'b1100111: begin
                reg_write = 1'b1;
                pc_src = 2'b11; // Jump register target
                result_src = 2'b10; // PC + 4 for return address
                alu_src = 1'b1;
                alu_control = 4'b0000; // ADD for address calculation
            end
            
            // LUI instruction
            7'b0110111: begin
                reg_write = 1'b1;
                result_src = 2'b11; // Immediate
            end
            
            // AUIPC instruction
            7'b0010111: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                alu_control = 4'b0000; // ADD for PC + immediate
            end
            
            default: begin
                // Default values already set
            end
        endcase
    end
endmodule
