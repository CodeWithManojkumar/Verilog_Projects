module mux2to1(out,s,i0,i1);

	input s,i0,i1;
	output out;
	wire sbar;

	not(sbar,s);
	cmos a(out,i0,sbar,s);
	cmos b(out,i1,s,sbar);

endmodule