module Universal_shift_register 
#(parameter N=8)
(
	input wire clock,reset;
	input [1:0] ctrl;
	input [N-1:0] d;
	output [N-1:0] q;
);

reg [N-1:0] r_reg,r_next;

always @(posedge clock,posedge reset)
	if(reset)
		r_reg<=0;
	else 
		r_reg<=r_next;
		
	// Next state Logic
	always @*
		case(ctrl)
			2'b00: r_next = r_reg;// No change
			2'b01: r_next = {r_reg[N-2:0],d[0]};// Left Shift
			2'b10: r_next = {d[N-1],r_reg[N-1:1]};// Right Shift
			2'b11: r_next = d;// Parallel load
		endcase
	
	assign q=r_reg;
endmodule