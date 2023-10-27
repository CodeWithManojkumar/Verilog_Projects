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

  // $readmemh("instr_test.txt", dut.dpath.imem.imem); // Basic Instructions
  $readmemh("gcd_test.txt", dut.dpath.imem.imem);     // GCD instructions

  end

  // Monitor the output
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, mips_tb);

    // Basic Instructions Results
    // $monitor($time," register values : %d  %d  %d  %d  %d",
    // dut.dpath.rbank.regfile[1],dut.dpath.rbank.regfile[2],dut.dpath.rbank.regfile[3],dut.dpath.rbank.regfile[4],dut.dpath.dmem.dmem[7]);


    // GCD Results
    $monitor($time," register values : %d  %d  %d data_memory:  %d  %d  %d",
    dut.dpath.rbank.regfile[1],dut.dpath.rbank.regfile[2],dut.dpath.rbank.regfile[3],dut.dpath.dmem.dmem[0],dut.dpath.dmem.dmem[1],dut.dpath.dmem.dmem[2]);

    #5000 $finish; // Finish the simulation after 5000 time units
  end
endmodule