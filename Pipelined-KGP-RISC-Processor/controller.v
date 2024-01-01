module controller (
    input wire clk,reset,
    input wire [31:0] instr,
    input wire branch_condition,
    output wire alusrc,
    output wire [3:0] alufunc,
    output wire regdest,
    output wire readdmem,writedmem,
    output wire regwrite,memtoreg,
    output wire jump,pcsrc
);

reg [11:0] control_signals;
wire branch;
assign {alusrc,alufunc,regdest,
    readdmem,writedmem,regwrite,memtoreg,jump,branch} = control_signals;

always @(negedge clk or negedge reset)
begin
    if(reset) begin
        control_signals <= 12'b0;
    end
    else if(instr == 32'b0)
        control_signals <= 12'b0;
    else #1 begin
        case (instr[31:30])
            2'b00 : begin
                {control_signals[11],control_signals[6:0]} <= 8'b01001000;
                case (instr[5:0])
                    6'b000001 : control_signals[10:7] <= 4'b0000; // ADD
                    6'b000010 : control_signals[10:7] <= 4'b0001; // SUB
                    6'b000011 : control_signals[10:7] <= 4'b0010; // AND
                    6'b000100 : control_signals[10:7] <= 4'b0011; // OR
                    6'b000101 : control_signals[10:7] <= 4'b0100; // XOR
                    6'b000110 : control_signals[10:7] <= 4'b0101; // NOT
                    6'b000111 : control_signals[10:7] <= 4'b0110; // SLA
                    6'b001000 : control_signals[10:7] <= 4'b0111; // SLL
                    6'b001001 : control_signals[10:7] <= 4'b1000; // SRA
                    6'b001010 : control_signals[10:7] <= 4'b1001; // SRL
                endcase
            end
            2'b01 : begin
                {control_signals[11],control_signals[6:0]} <= 8'b10001000;
                case (instr[31:26])
                    6'b010000 : control_signals[10:7] <= 4'b0000; // ADDI
                    6'b010001 : control_signals[10:7] <= 4'b0001; // SUBI
                    6'b010010 : control_signals[10:7] <= 4'b0010; // ANDI
                    6'b010011 : control_signals[10:7] <= 4'b0011; // ORI
                    6'b010100 : control_signals[10:7] <= 4'b0100; // XORI
                    6'b010101 : control_signals[10:7] <= 4'b0101; // NOTI
                    6'b010110 : control_signals[10:7] <= 4'b0110; // SLAI
                    6'b010111 : control_signals[10:7] <= 4'b0111; // SLLI
                    6'b011000 : control_signals[10:7] <= 4'b1000; // SRAI
                    6'b011001 : control_signals[10:7] <= 4'b1001; // SRLI
                    6'b011010 : control_signals[10:7] <= 4'b0000; // MOVE
                endcase
            end
            2'b10 : begin
                case (instr[31:26])
                    6'b100001 : control_signals <= 12'b100000101100; // LD
                    6'b100010 : control_signals <= 12'b100000010000; // ST
                endcase
            end
            2'b11 : begin
                case (instr[31:26])
                    6'b110000 : control_signals <= 12'b000000000001; // BLT
                    6'b110001 : control_signals <= 12'b000000000001; // BGT
                    6'b110010 : control_signals <= 12'b000000000001; // BEQ
                    6'b110011 : control_signals <= 12'b000000000001; // BNE
                    6'b110100 : control_signals <= 12'b000000000010; // BR
                endcase
            end
        endcase
    end
end

assign pcsrc = jump | (branch & branch_condition);

endmodule