module cmosnand(x,y,f);

	input x,y;
	output f;
	supply1 vdd;
	supply0 gnd;
	wire a;

	pmos p1(f,vdd,x);
	pmos p2(f,gnd,y);
	nmos n1(f,a,x);
	nmos n2(a,gnd,y);

endmodule