module pseudonor(x,y,f);

	input x,y;
	output f;
	supply0 gnd;

	nmos n1(f,gnd,x);
	nmos n2(f,gnd,y);
	pullup(f);
endmodule