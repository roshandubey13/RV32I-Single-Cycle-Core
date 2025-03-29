module data_memory(
    input wire clk,              // Clock signal
    input wire [31:0] address,   // Memory address
    input wire mem_write,        // Write enable
    input wire mem_read,         // Read enable
    input wire [31:0] write_data, // Data to write
    output wire [31:0] read_data  // Data read
);
    // Memory array
    reg [31:0] memory [0:1023]; // 1K words of memory
    
    // Read data (combinational)
    assign read_data = mem_read ? memory[address[31:2]] : 32'h00000000;
    
    // Write data (sequential)
    always @(posedge clk) begin
        if (mem_write)
            memory[address[31:2]] <= write_data;
    end
endmodule
