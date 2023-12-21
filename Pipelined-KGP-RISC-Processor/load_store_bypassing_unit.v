module load_store_bypassing_unit (
    input wire mem_wb_memtoreg,ex_mem_writedmem,
    input wire [4:0] ex_mem_destadd,mem_wb_destadd,

    output wire forwarddatamem
);

wire x,y;

assign x = ex_mem_destadd == mem_wb_destadd;
assign y = mem_wb_memtoreg & ex_mem_writedmem;

assign forwarddatamem = x & y;
    
endmodule