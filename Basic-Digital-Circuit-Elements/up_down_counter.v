module up_down_counter (
	input wire clk,
	input wire reset,
	input wire en,
	input wire ctrl,
	output reg [4:0] counter_out
);

always @(posedge clk)
begin
	if(reset==1'b1)begin
		counter_out <= 4'b0000;
	end
	else if (en==1'b1)begin
		if(ctrl==1'b0) begin
			counter_out<= counter_out+1;
		end else begin 
			counter_out<=counter_out-1;
		end
	end
end
endmodule