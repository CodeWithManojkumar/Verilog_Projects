`include "mips.v"
module mips_tb;
  reg clk, reset;
  wire [31:0] writedata;

  // Instantiate the module under test
  mips dut (
    .clk(clk),
    .reset(reset),
    .writedata(writedata)
  );

  // Provide a clock signal
  always #5 clk = ~clk;

  // Initialize signals
  initial begin
    clk = 0;
    reset = 1;
    #15 reset = 0;

  $readmemh("instr_test.txt", dut.dpath.imem.imem); // Load instructions from a file
  end

  // Monitor the output
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, mips_tb);

    $monitor($time," register values : %d  %d  %d %d %d",dut.dpath.rbank.regfile[1],dut.dpath.rbank.regfile[2],dut.dpath.rbank.regfile[3],dut.dpath.rbank.regfile[4],dut.dpath.dmem.dmem[7]);

    #1000 $finish; // Finish the simulation after 1000 time units
  end
endmodule