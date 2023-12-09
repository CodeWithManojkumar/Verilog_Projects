primitive TFF(q,clk,clr);
	input clk,clr;
	output reg q;

	table 
	//clk clr q q_new
		?   1  : ? : 0; // FF is cleared
		? (10) : ? : -; // ignore -ve edge of clr
		(10) 0 : 1 : 0; // FF toggles at -ve edge of clk
		(10) 0 : 0 : 1; // -do-
		(0?) 0 : ? : -; // ignore +ve edge of clk
	endtable

endprimitive