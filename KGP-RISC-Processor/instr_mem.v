module instr_mem (
    // input wire clk,
    input read,
    input wire [5:0] addr,
    output wire [31:0] I;
);
    
reg [31:0] imem[63:0];

assign I = (read)? imem[addr] : 32'bx;
endmodule