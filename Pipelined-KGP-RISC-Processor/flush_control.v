module flush_control (
    input wire alusrc,
    input wire [3:0] alufunc,
    input wire regdest,branch,readdmem,writedmem,pcsrc,regwrite,memtoreg,
    input wire flush,
    output wire id_alusrc,
    output wire [3:0] id_alufunc,
    output wire id_regdest,id_branch,id_readdmem,id_writedmem,id_pcsrc,id_regwrite,id_memtoreg,
);

wire notflush;
assign notflush = ~flush;

assign id_alusrc = alusrc & notflush; 
assign id_alufunc[0] = alufunc[0] & notflush; 
assign id_alufunc[1] = alufunc[1] & notflush; 
assign id_alufunc[2] = alufunc[2] & notflush; 
assign id_alufunc[3] = alufunc[3] & notflush; 
assign id_regdest = regdest & notflush; 
assign id_branch = branch & notflush; 
assign id_readdmem = readdmem & notflush; 
assign id_writedmem = writedmem & notflush; 
assign id_pcsrc = pcsrc & notflush; 
assign id_regwrite = regwrite & notflush; 
assign id_memtoreg = memtoreg & notflush;


endmodule