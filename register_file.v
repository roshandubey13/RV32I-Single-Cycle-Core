module register_file(
    input wire clk,              // Clock signal
    input wire [4:0] rs1,        // Source register 1 address
    input wire [4:0] rs2,        // Source register 2 address
    input wire [4:0] rd,         // Destination register address
    input wire reg_write,        // Register write enable
    input wire [31:0] write_data, // Data to write
    output wire [31:0] read_data1, // Data from rs1
    output wire [31:0] read_data2  // Data from rs2
);
    // Register array
    reg [31:0] registers [0:31];
    
    // Initialize registers
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'h00000000;
    end
    
    // Read data (combinational)
    assign read_data1 = (rs1 != 5'b00000) ? registers[rs1] : 32'h00000000;
    assign read_data2 = (rs2 != 5'b00000) ? registers[rs2] : 32'h00000000;
    
    // Write data (sequential)
    always @(posedge clk) begin
        if (reg_write && (rd != 5'b00000)) // Cannot write to x0
            registers[rd] <= write_data;
    end
endmodule
