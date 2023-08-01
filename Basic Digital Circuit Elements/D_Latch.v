primitive D_Latch(q,d,clk,clr);
	input d,clk,clr;
	output reg q;

	initial 
		q=0;

	table 
	//d clk clr q   q_new
		? ? 1 : ? : 0; // latch is cleared
		0 1 0 : ? : 0; // latch is reset
		1 1 0 : ? : 1; // latch is set
		? 0 0 : ? : -; // retains previous state
	endtable

endprimitive