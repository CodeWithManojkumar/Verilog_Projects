module ALU(
    input wire signed [31:0] operand1,
    input wire signed [31:0] operand2,
    input wire [3:0] mode,
    input wire en,
    output wire zero,
    output wire signed [31:0] out
);

    reg signed [31:0] ALUout;

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
                    4'b0110  :  ALUout = operand1 <<< operand2;
                    4'b0111  :  ALUout = operand1 << operand2;
                    4'b1000  :  ALUout = operand1 >>> operand2;
                    4'b1001  :  ALUout = operand1 >> operand2;
                    4'b1010  :  ALUout = operand1 + {operand2[29:0],2'b00};
                endcase
            end
    end

    assign out = ALUout;
    assign zero = (ALUout == 0)? 1 : 0;

    // tested successfully


endmodule