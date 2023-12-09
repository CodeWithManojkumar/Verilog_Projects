//Store the Factorial of a number in memory location 198
//which is stored in memory location 200
`include "pipe_MIPS32.v"
module pipe_MIPS32_tb;

reg clk1,clk2;
integer k;

pipe_MIPS32 mips(clk1,clk2);

initial 
	begin
		clk1=0;clk2=0;
		repeat (50)
			begin
				#5 clk1=1; #5 clk1=0;
				#5 clk2=1; #5 clk2=0;
			end
	end

initial
	begin
		for(k=0;k<31;k++)
			mips.Reg[k]=k;
			
		mips.Mem[0] = 32'h280a00c8; // ADDI R1,R0,200
		mips.Mem[1] = 32'h28020001; // ADDI R1,R0,120
		mips.Mem[2] = 32'h0e94a000; // OR R20,R20,R20 // DUMMY INSTR.
		mips.Mem[3] = 32'h21430000; // LW R3,0(R10)
		mips.Mem[4] = 32'h0e94a000; // OR R20,R20,R20 // DUMMY INSTR.
		mips.Mem[5] = 32'h14431000; // LOOP: MUL R2,R2,R3
		mips.Mem[6] = 32'h2c630001; // SUBI R3,R3,1
		mips.Mem[7] = 32'h0e94a000; // OR R20,R20,R20 // DUMMY INSTR.
		mips.Mem[8] = 32'h3460fffc; // BENQZ R3,LOOP
		mips.Mem[9] = 32'h2542fffe; // SW R2,-2(R10)
		mips.Mem[10] = 32'hfc000000; // HLT
		
		
		mips.Mem[200]=7;
		mips.HALTED=0;
		mips.PC=0;
		mips.TAKEN_BRANCH=0;
		
		$monitor("R2: %4d",mips.Reg[2]);
		#5000 $display("Mem[200]: %2d \nMem[198]: %2d",mips.Mem[200],mips.Mem[198]);
		#8000 $finish;
	end
endmodule