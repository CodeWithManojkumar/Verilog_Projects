module data_mem (
    input wire clk,reset,
    input wire write,read,
    input wire [31:0] addr,
    input wire [31:0] din,
    output wire [31:0] dout
);
    
reg signed [31:0] dmem[0:1023];
integer k;
always @(posedge clk) 
begin
    if(reset)
    begin
		for(k=0;k<1024;k=k+1)
		begin
			dmem[k]<=32'b0;
		end 
	end
    else if(write == 1)
       #1 dmem[addr[9:0]] <= din;
end

assign dout = (read)? dmem[addr[9:0]] : 32'bx;
endmodule