module mux5 (
    input wire [31:0] a,b,c,d,e,
    input wire [2:0] sel,
    output wire [31:0] out
);

wire [31:0] x,y,z;

mux #(32) ab(a,b,sel[0],x);
mux #(32) cd(c,d,sel[0],y);
mux #(32) abcd(x,y,sel[1],z);
mux #(32) abcde(z,e,sel[2],out);

endmodule