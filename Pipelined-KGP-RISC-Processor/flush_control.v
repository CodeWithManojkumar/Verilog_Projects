module flush_control (
    input wire alusrc,
    input wire [3:0] alufunc,
    input wire regdest,readdmem,writedmem,regwrite,memtoreg,
    input wire flush,
    output wire id_alusrc,
    output wire [3:0] id_alufunc,
    output wire id_regdest,id_readdmem,id_writedmem,id_regwrite,id_memtoreg
);

assign id_alusrc = (flush) ? 1'b0 :alusrc; 
assign id_alufunc[0] = (flush) ? 1'b0 :alufunc[0]; 
assign id_alufunc[1] = (flush) ? 1'b0 :alufunc[1]; 
assign id_alufunc[2] = (flush) ? 1'b0 :alufunc[2]; 
assign id_alufunc[3] = (flush) ? 1'b0 :alufunc[3]; 
assign id_regdest = (flush) ? 1'b0 :regdest; 
assign id_readdmem = (flush) ? 1'b0 :readdmem; 
assign id_writedmem = (flush) ? 1'b0 :writedmem; 
assign id_regwrite = (flush) ? 1'b0 :regwrite; 
assign id_memtoreg = (flush) ? 1'b0 :memtoreg; 

endmodule