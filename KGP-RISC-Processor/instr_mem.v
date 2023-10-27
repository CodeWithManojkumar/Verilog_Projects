module instr_mem (
    input read,
    input wire [5:0] addr,
    output wire [31:0] I
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

assign I = (read)? imem[addr] : 32'bx;
endmodule