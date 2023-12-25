module forwarding_unit_id (
    input wire [4:0] rs,rt,
    input wire [4:0] dest,ex_mem_destadd,mem_wb_destadd,
    input wire id_ex_regwrite,ex_mem_readdmem,ex_mem_regwrite,ex_mem_memtoreg,mem_wb_regwrite,

    output wire [2:0] forwardA,forwardB
);
/*
forward A : 000 : read from register bank
forward A : 001 : read from data memory
forward A : 010 : read from ex_mem_result
forward A : 011 : read from result of ALU
forward A : 100 : read from wb_writedata

forward A
-----------
000 : default
001 : ex_mem_readdmem == 1 and ex_mem_destadd == rs and ex_mem_memtoreg == 1 and ex_mem_regwrite == 1
010 : (not of 01 condition) and (ex_mem_destadd == rs and ex_mem_memtoreg == 0 and ex_mem_regwrite == 1)
011 : (not of 01 condition) and (not of 10 condition) and (dest == rs and id_ex_regwrite == 1)
100 : (not of 01 condition) and (not of 10 condition) and  (not of 11 condition) and (mem_wb_regwrite == 1 and mem_wb_destadd == rs)

*/
reg [2:0] fA,fB;

assign forwardA = fA;
assign forwardB = fB;

always @* begin

  if (ex_mem_readdmem == 1 && ex_mem_destadd == rs && ex_mem_memtoreg == 1 && ex_mem_regwrite == 1) begin
    fA <= 3'b001;
  end
  else if (!(ex_mem_readdmem == 1 && ex_mem_destadd == rs && ex_mem_memtoreg == 1 && ex_mem_regwrite == 1) &&
           (ex_mem_destadd == rs && ex_mem_memtoreg == 0 && ex_mem_regwrite == 1)) begin
    fA <= 3'b010;
  end
  else if (!(ex_mem_readdmem == 1 && ex_mem_destadd == rs && ex_mem_memtoreg == 1 && ex_mem_regwrite == 1) &&
           !((ex_mem_destadd == rs && ex_mem_memtoreg == 0 && ex_mem_regwrite == 1)) &&
           (dest == rs && id_ex_regwrite == 1)) begin
    fA <= 3'b011;
  end
  else if (!(ex_mem_readdmem == 1 && ex_mem_destadd == rs && ex_mem_memtoreg == 1 && ex_mem_regwrite == 1) &&
           !((ex_mem_destadd == rs && ex_mem_memtoreg == 0 && ex_mem_regwrite == 1)) &&
           !((dest == rs && id_ex_regwrite == 1)) &&
           (mem_wb_regwrite == 1 && mem_wb_destadd == rs)) begin
    fA = 3'b100;
  end
  else 
    fA <= 3'b000;
end
always @* begin

  if (ex_mem_readdmem == 1 && ex_mem_destadd == rt && ex_mem_memtoreg == 1 && ex_mem_regwrite == 1) begin
    fB <= 3'b001;
  end
  else if (!(ex_mem_readdmem == 1 && ex_mem_destadd == rt && ex_mem_memtoreg == 1 && ex_mem_regwrite == 1) &&
           (ex_mem_destadd == rt && ex_mem_memtoreg == 0 && ex_mem_regwrite == 1)) begin
    fB <= 3'b010;
  end
  else if (!(ex_mem_readdmem == 1 && ex_mem_destadd == rt && ex_mem_memtoreg == 1 && ex_mem_regwrite == 1) &&
           !((ex_mem_destadd == rt && ex_mem_memtoreg == 0 && ex_mem_regwrite == 1)) &&
           (dest == rt && id_ex_regwrite == 1)) begin
    fB <= 3'b011;
  end
  else if (!(ex_mem_readdmem == 1 && ex_mem_destadd == rt && ex_mem_memtoreg == 1 && ex_mem_regwrite == 1) &&
           !((ex_mem_destadd == rt && ex_mem_memtoreg == 0 && ex_mem_regwrite == 1)) &&
           !((dest == rt && id_ex_regwrite == 1)) &&
           (mem_wb_regwrite == 1 && mem_wb_destadd == rt)) begin
    fB <= 3'b100;
  end
  else 
    fB <= 3'b000;
end

endmodule