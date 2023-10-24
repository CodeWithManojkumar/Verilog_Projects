module controller (
    input wire clk,reset,
    input wire [31:0] irout,

    output wire readim,ldir,ldnpc,
    output wire ldA,ldB,ldimm,
    output wire [1:0] opcond,
    output wire alusel1,alusel2,aluen,ldaluout,
    output wire [3:0] alufunc,
    output wire regwrite,writedmem,readdmem,ldlmd,
    output wire selwb,branch,ldpc
);

reg [22:0] control_signals;
assign {readim,ldir,ldnpc,ldA,ldB,ldimm,opcond,alusel1,alusel2,aluen,ldaluout,alufunc,regwrite,writedmem,readdmem,ldlmd,selwb,branch,ldpc} = control_signals;
    
always @(posedge clk, posedge reset) begin
    
    if(reset)
        control_signals <= 23'b0;
    else
        begin
            control_signals[22:20] <= 3'b111;
            case (irout[31:30])
                2'b00 : #2 // R-type
                        control_signals[19:11] <= 9'b110_11_101_1;
                        control_signals[6:0]   <= 7'b100_01_0_1;
                        begin
                            case (irout[5:0])
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
                2'b01 : #2 // I-type
                        begin
                            control_signals[19:11] <= 9'b101_11_111_1;
                            control_signals[6:0]   <= 7'b100_01_0_1;
                            case (irout[31:26])
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
                2'b10 : #2 // Load, Store
                        begin
                            case (irout[31:26])
                                6'b100001 : control_signals[19:0] <= 20'b101_11_111_1_0000_10110_0_1; // LD
                                6'b100010 : control_signals[19:0] <= 20'b101_11_111_1_0000_01001_0_1; // ST 
                            endcase
                        end
                2'b11 : #2// Branch
                        begin
                            case (irout[31:26])
                                6'b110000 : control_signals[19:0] <= 20'b000_00_000_0_0000_00000_1_1; // BR
                                6'b110001 : control_signals[19:0] <= 20'b001_01_011_1_1010_00000_0_1; // BMI
                                6'b110010 : control_signals[19:0] <= 20'b001_00_011_1_1010_00000_0_1; // BPL
                                6'b110011 : control_signals[19:0] <= 20'b001_10_011_1_1010_00000_0_1; // BZ 
                            endcase
                        end
                default: 
            endcase
        end
end
endmodule