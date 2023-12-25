module instr_mem (
    input wire clk,
    input wire read,
    input wire [5:0] addr,
    output wire [31:0] instr,
    output wire pc_en
);
    
reg [31:0] imem[0:63];

// initial
//       $readmemh("instr.txt", imem);
/*
integer i;
initial begin
    for (i = 0 ;i<18 ;i=i+1 ) begin
        $display("mem[%0d] = %h ", i,imem[i]);
    end
end
*/

assign instr = (imem[addr] != 32'hffffffff) ? imem[addr] : 32'bx;
assign pc_en = (imem[addr] != 32'hffffffff) ? 1'b1 : 1'b0;
endmodule