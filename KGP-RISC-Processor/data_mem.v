module data_mem (
    input wire clk,
    input wire write,read,
    input wire [31:0] addr,
    input wire [31:0] din,
    output wire [31:0] dout;
);
    
reg [31:0] dmem[0:1023];

always @(posedge clk) 
begin
    if(write == 1)
        dmem[addr[9:0]] <= din;
end

assign dout = (read)? dmem[addr[9:0]] : 32'bx;
endmodule