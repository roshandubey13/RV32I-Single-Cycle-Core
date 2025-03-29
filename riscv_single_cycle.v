module riscv_single_cycle(
    input wire clk,          // Clock signal
    input wire reset,        // Reset signal
    output wire [31:0] pc,   // Program counter
    output wire [31:0] instruction, // Current instruction
    output wire [31:0] alu_result, // ALU result
    output wire [31:0] write_data,  // Data to be written to register
    output wire [31:0] read_data    // Data read from memory
);
    // Internal wires
    wire [31:0] pc_next;
    wire [31:0] pc_plus4;
    wire [31:0] pc_target;
    wire [31:0] immediate;
    wire [31:0] src_a, src_b;
    wire [31:0] result;
    wire [31:0] read_data1, read_data2;
    wire zero;
    
    // Control signals
    wire [1:0] pc_src;
    wire [1:0] result_src;
    wire mem_write;
    wire alu_src;
    wire reg_write;
    wire [3:0] alu_control;
    
    // Instruction fields
    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];
    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];
    wire [4:0] rd = instruction[11:7];
    
    // Program Counter
    PC pc_reg(
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );
    
    // PC Adder (PC + 4)
    assign pc_plus4 = pc + 4;
    
    // PC Target Adder (PC + Immediate)
    assign pc_target = pc + immediate;
    
    // PC Source Mux - REPLACE THE ALWAYS BLOCK WITH THIS CONTINUOUS ASSIGNMENT
    assign pc_next = (pc_src == 2'b00) ? pc_plus4 :
                    (pc_src == 2'b01) ? ((zero) ? pc_target : pc_plus4) :
                    (pc_src == 2'b10) ? pc_target :
                    (pc_src == 2'b11) ? (alu_result & ~32'h1) :
                    pc_plus4;
    
    // Instruction Memory
    instruction_memory instr_mem(
        .address(pc),
        .instruction(instruction)
    );
    
    // Immediate Generator
    immediate_gen imm_gen(
        .instruction(instruction),
        .immediate(immediate)
    );
    
    // Register File
    register_file reg_file(
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .reg_write(reg_write),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    
    // ALU Source Mux
    assign src_a = read_data1;
    assign src_b = alu_src ? immediate : read_data2;
    
    // ALU
    alu alu_unit(
        .src_a(src_a),
        .src_b(src_b),
        .alu_control(alu_control),
        .alu_result(alu_result),
        .zero(zero)
    );
    
    // Data Memory
    data_memory data_mem(
        .clk(clk),
        .address(alu_result),
        .mem_write(mem_write),
        .mem_read(1'b1), // Always read
        .write_data(read_data2),
        .read_data(read_data)
    );
    
    // Result Source Mux - REPLACE THE ALWAYS BLOCK WITH THIS CONTINUOUS ASSIGNMENT
    assign result = (result_src == 2'b00) ? alu_result :
                   (result_src == 2'b01) ? read_data :
                   (result_src == 2'b10) ? pc_plus4 :
                   (result_src == 2'b11) ? immediate :
                   alu_result;
    
    assign write_data = result;
    
    // Control Unit
    control_unit control(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .pc_src(pc_src),
        .result_src(result_src),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .alu_control(alu_control)
    );
endmodule
