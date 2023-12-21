module stall_control (
    input wire id_ex_readdmem,
    input wire [4:0] id_ex_rt,
    input wire [4:0] rs,rt,

    output wire stall,pc_write,if_id_write
);

wire x,y,z;

assign x = id_ex_readdmem == 1;
assign y = (id_ex_rt == rs) | (id_ex_rt == rt);
assign z = x & y;

assign {stall,pc_write,if_id_write} = (z==1) ? 3'b100 : 3'b011;

endmodule