module Register (
	input wire reset , clock;
	input wire en;
	input wire [7:0] d;
	outoput reg [7:0] q;
);

always @(posedge clock , posedge reset)
begin 
	if(reset)begin
		q<=0;
	end else if(en) begin
		q<=d;
	end
end

endmodule