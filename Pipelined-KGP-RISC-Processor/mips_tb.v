`include "mips.v"
module mips_tb;
  reg clk,clkbar, reset;
  integer k;

  // Instantiate the module under test
  mips dut (
    .clk(clk),
    .clkbar(clkbar),
    .reset(reset)
  );

  // Provide a clock signal
  always #5 clk = ~clk;
  always #5 clkbar = ~clkbar;

  // Initialize signals
  initial begin
    clk = 0;
    clkbar = 1;
    reset = 1;
    #15 reset = 0;

  // $readmemh("instr_test.txt", dut.imem.imem); // Basic Instructions
  $readmemh("gcd_test.txt", dut.imem.imem);     // GCD instructions
  // $readmemh("sorting_test.txt", dut.dpath.imem.imem);    // Sorting instructions

  
  end

  // Monitor the output
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, mips_tb);

    // uncomment the codes and run the instructions

    // Basic Instructions Results
    // $monitor($time," register values : %d  %d  %d  %d  %d",
    // dut.rbank.regfile[1],dut.rbank.regfile[2],dut.rbank.regfile[3],dut.rbank.regfile[4],dut.rbank.regfile[5],dut.dmem.dmem[7],dut.dmem.dmem[8]);


    // GCD Results
    $monitor($time," register values : %d  %d  %d data_memory:  %d  %d  %d",
    dut.rbank.regfile[1],dut.rbank.regfile[2],dut.rbank.regfile[3],dut.dmem.dmem[0],dut.dmem.dmem[1],dut.dmem.dmem[2]);


    // Sorting Results
    // #20;
    // dut.dpath.dmem.dmem[100] = 20;
    // dut.dpath.dmem.dmem[101] = 50;
    // dut.dpath.dmem.dmem[102] = 10;
    // dut.dpath.dmem.dmem[103] = 30;
    // dut.dpath.dmem.dmem[104] = 70;
    // dut.dpath.dmem.dmem[105] = 40;
    // dut.dpath.dmem.dmem[106] = 60;
    // dut.dpath.dmem.dmem[107] = 80;
    // dut.dpath.dmem.dmem[108] = 100;
    // dut.dpath.dmem.dmem[109] = 90;

    // $monitor($time," Array: %d %d %d %d %d %d %d %d %d %d ",dut.dpath.dmem.dmem[100],
    // dut.dpath.dmem.dmem[101],dut.dpath.dmem.dmem[102],dut.dpath.dmem.dmem[103],
    // dut.dpath.dmem.dmem[104],dut.dpath.dmem.dmem[105],dut.dpath.dmem.dmem[106],
    // dut.dpath.dmem.dmem[107],dut.dpath.dmem.dmem[108],dut.dpath.dmem.dmem[109]);

    
    #10000 $finish; // Finish the simulation after 10000 time units
  end
endmodule