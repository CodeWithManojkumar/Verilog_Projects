module controller (
    input wire clk,reset,
    input wire [31:0] irout,

    output wire readim,ldir,ldnpc,
    output wire ldA,ldB,ldimm,
    output wire [1:0] opcond,
    output wire alusel1,alusel2,aluen,ldaluout,
    output wire [3:0] alufunc,
    output wire seldest,regwrite,writedmem,readdmem,ldlmd,
    output wire selwb,branch,ldpc
);

parameter IF = 3'b000, ID = 3'b001, EX = 3'b010, MEM = 3'b011, WB = 3'b100, HLT = 3'b101;
reg [2:0] state;
reg [23:0] control_signals;
assign {readim,ldir,ldnpc,ldA,ldB,ldimm,opcond,alusel1,alusel2,aluen,ldaluout,
        alufunc,seldest,regwrite,writedmem,readdmem,ldlmd,selwb,branch,ldpc} = control_signals;

always @(posedge clk, negedge reset) begin
    
    if(reset)
        control_signals <= 24'b0;
    else
        begin
            case (state)
                IF: begin
                    #1 
                    if(irout == 32'hffffffff)
                    begin
                        control_signals <= 24'b0;
                        state <= HLT;
                    end
                    else
                        begin
                            control_signals[23:21] <= 3'b111;
                            control_signals[20:0]  <= 21'b0;
                            state <= ID;
                        end
                    end
                ID: begin
                    #1  
                        control_signals[20:18] <= 3'b111;
                        state <= EX;
                    end
                EX: begin
                    #1  
                        case (irout[31:30])
                            2'b00 :
                                begin
                                    control_signals[17:16] <= 2'b11;
                                    control_signals[15:13] <= 3'b101;
                                    case (irout[5:0])
                                        6'b000001 : control_signals[11:8] <= 4'b0000; // ADD
                                        6'b000010 : control_signals[11:8] <= 4'b0001; // SUB
                                        6'b000011 : control_signals[11:8] <= 4'b0010; // AND
                                        6'b000100 : control_signals[11:8] <= 4'b0011; // OR
                                        6'b000101 : control_signals[11:8] <= 4'b0100; // XOR
                                        6'b000110 : control_signals[11:8] <= 4'b0101; // NOT
                                        6'b000111 : control_signals[11:8] <= 4'b0110; // SLA
                                        6'b001000 : control_signals[11:8] <= 4'b0111; // SLL
                                        6'b001001 : control_signals[11:8] <= 4'b1000; // SRA
                                        6'b001010 : control_signals[11:8] <= 4'b1001; // SRL 
                                    endcase
                                end
                            2'b01 :
                                begin
                                    control_signals[17:16] <= 2'b11;
                                    control_signals[15:13] <= 3'b111;
                                    case (irout[31:26])
                                        6'b010000 : control_signals[11:8] <= 4'b0000; // ADDI
                                        6'b010001 : control_signals[11:8] <= 4'b0001; // SUBI
                                        6'b010010 : control_signals[11:8] <= 4'b0010; // ANDI
                                        6'b010011 : control_signals[11:8] <= 4'b0011; // ORI
                                        6'b010100 : control_signals[11:8] <= 4'b0100; // XORI
                                        6'b010101 : control_signals[11:8] <= 4'b0101; // NOTI
                                        6'b010110 : control_signals[11:8] <= 4'b0110; // SLAI
                                        6'b010111 : control_signals[11:8] <= 4'b0111; // SLLI
                                        6'b011000 : control_signals[11:8] <= 4'b1000; // SRAI
                                        6'b011001 : control_signals[11:8] <= 4'b1001; // SRLI
                                        6'b011010 : control_signals[11:8] <= 4'b0000; // MOVE 
                                    endcase    
                                end
                            2'b10 :
                                begin
                                    control_signals[17:16] <= 2'b11;
                                    control_signals[15:13] <= 3'b111;
                                    case (irout[31:26])
                                        6'b100001 : control_signals[11:8] <= 4'b0000; // LD
                                        6'b100010 : control_signals[11:8] <= 4'b0000; // ST
                                    endcase
                                end
                            2'b11 :
                                begin
                                    control_signals[15:13] <= 3'b011;
                                    case (irout[31:26])
                                        6'b110000 : {control_signals[17:16],control_signals[11:8]} <= {2'b11,4'b1010}; // BR
                                        6'b110001 : {control_signals[17:16],control_signals[11:8]} <= {2'b01,4'b1010}; // BMI
                                        6'b110010 : {control_signals[17:16],control_signals[11:8]} <= {2'b00,4'b1010}; // BPL
                                        6'b110011 : {control_signals[17:16],control_signals[11:8]} <= {2'b10,4'b1010};  // BZ 
                                    endcase  
                                end 
                        endcase
                        #2 control_signals[12] <= 1'b1;
                        state <= MEM;
                    end
                MEM:begin
                    #1 
                        case (irout[31:26])
                            6'b100001 : control_signals[5:3] <= 3'b011; // LD
                            6'b100010 : control_signals[5:3] <= 3'b100; // ST
                        endcase
                        if(irout[31:26] == 6'b110000)
                            control_signals[1:0] <= 2'b11;
                        else
                            control_signals[1:0] <= 2'b01;
                        state <= WB;
                    end
                WB: begin
                    #1
                        case (irout[31:30])
                            2'b00 : {control_signals[7:6],control_signals[2]} <= 3'b011;
                            2'b01 : {control_signals[7:6],control_signals[2]} <= 3'b111;
                            2'b10 : 
                                begin
                                    case (irout[31:26])
                                        6'b100001 : {control_signals[7:6],control_signals[2]} <= 3'b110; // LD
                                        6'b100010 : {control_signals[7:6],control_signals[2]} <= 3'b001; // ST
                                    endcase
                                end
                            2'b11 : {control_signals[7:6],control_signals[2]} <= 3'b000;
                            default: {control_signals[7:6],control_signals[2]} <= 3'b000;
                        endcase
                        state <= IF;
                    end
                HLT:begin
                        #1  control_signals <= 24'b0;
                            state <= HLT;
                    end
                default: state <= IF;
            endcase
        end
end
endmodule