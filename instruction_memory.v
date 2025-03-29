module instruction_memory(
    input wire [31:0] address, // Instruction address (PC)
    output wire [31:0] instruction // Fetched instruction
);
    // Memory array (ROM)
    reg [31:0] memory [0:1023]; // 1K words of memory
    
    // Initialize with instructions (can be loaded from file)
    initial begin
        $readmemh("program.mem", memory); // Load program from hex file
    end
    
    // Fetch instruction (combinational read)
    assign instruction = memory[address[31:2]]; // Word-aligned addressing
endmodule
