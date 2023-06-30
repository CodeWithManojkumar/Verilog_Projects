module barrel_shifter(
	input wire [7:0] a;
	output reg [7:0] y;
	input wire [2:0] amt;
);
always_comb
	case(amt)
		3'b000: y=a;
		3'b001: y={a[0],a[7:1]};
		3'b010: y={a[1:0],a[7:2]};
		3'b011: y={a[2:0],a[7:3]};
		3'b100: y={a[3:0],a[7:4]};
		3'b101: y={a[4:0],a[7:5]};
		3'b110: y={a[5:0],a[7:6]};
		3'b111: y={a[6:0],a[7]};
		default: y=a;
	endcase
endmodule