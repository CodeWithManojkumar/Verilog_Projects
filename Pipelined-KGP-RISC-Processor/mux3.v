module mux3 (
    input wire [31:0] a,b,c,
    input wire [1:0] sel,
    output wire [31:0] out
);

wire [31:0] x,y;

mux #(32) ab(a,b,sel[0],x);
mux #(32) bc(c,b,sel[0],y);
mux #(32) abc(x,y,sel[1],out);

endmodule