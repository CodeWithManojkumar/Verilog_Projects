module ALU(
    input wire [31:0] operand1,
    input wire [31:0] operand2,
    input wire [3:0] mode,
    input wire en,
    output wire [31:0] out
);

    reg [31:0] ALUout;

    always @*
    begin
        if(en)
            begin
                case (mode)
                    4'b0000  :  ALUout = operand1 + operand2;
                    4'b0001  :  ALUout = operand1 - operand2;
                    4'b0010  :  ALUout = operand1 & operand2;
                    4'b0011  :  ALUout = operand1 | operand2;
                    4'b0100  :  ALUout = operand1 ^ operand2;
                    4'b0101  :  ALUout = ~operand1;
                    4'b0110  :  ALUout = operand1 << operand2;
                    4'b0111  :  ALUout = operand1 <<< operand2;
                    4'b1000  :  ALUout = operand1 >> operand2;
                    4'b1001  :  ALUout = operand1 >>> operand2;
                endcase
            end
    end

    assign out = ALUout;

    // tested successfully


endmodule