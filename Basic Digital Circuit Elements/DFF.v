module DFF (
	input wire reset , clock;
	input wire en;
	input wire d;
	outoput reg q;
);

always @(posedge clock , posedge reset)
begin 
	if(reset)begin
		q<=1'b0;
	end else if(en) begin
		q<=d;
	end
end

endmodule