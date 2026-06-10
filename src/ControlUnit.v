module control_unit (
    input [31:0] instr,
    output reg reg_en,
    output reg [1:0] regmux,
    output reg alumux1,
    output reg alumux2,
    output reg [3:0] alu_sel,
    output reg jump,
    output reg br_en,
    output reg jalr,
    output reg we,
    output reg sz,
    output reg [1:0] num_bytes
);
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    /* 
        Notice in docs/Control SIgnal Truth Table.pdf, 
        many of the ouputs of the control signals are don't cares. 
        In this design I decided to wire them to 0 to make them easier to debug, 
        though a fully correct implementation would use 
        the don't care to optimize for area/delay

        Defaults should never be used
    */

    always @(*) begin
        case(opcode)
            7'b0110011: begin //Register-Register AL
                reg_en = 1'b1; regmux = 2'b01;
                alumux1 = 1'b1; alumux2 = 1'b0;
                jump = 1'b0; br_en = 1'b0; jalr = 1'b0;
                we = 1'b0; sz = 1'b0; num_bytes = 2'b00;
                case(funct3)
                    3'd0: begin
                        case(funct7)
                            7'd0: alu_sel = 4'b0000;
                            7'd32: alu_sel = 4'b0001;
                            default: alu_sel = 4'b0000
                        endcase
                    end
                    3'd4: alu_sel = 4'b0010;
                    3'd6: alu_sel = 4'b0011;
                    3'd7: alu_sel = 4'b0100;
                    3'd1: alu_sel = 4'b0101;
                    3'd5: begin
                        case(funct7)
                            7'd0: alu_sel = 4'b0110;
                            7'd32: alu_sel = 4'b0111;
                            default: alu_sel = 4'b0000
                        endcase
                    end
                    3'd2: alu_sel = 4'b1000;
                    3'd3: alu_sel = 4'b1001;
                    default: alu_sel = 4'b0000;
                endcase
            end
            7'b0010011: begin //Register-Immediate AL
                reg_en = 1'b1; regmux = 2'b01;
                alumux1 = 1'b1; alumux2 = 1'b1;
                jump = 1'b0; br_en = 1'b0; jalr = 1'b0;
                we = 1'b0; sz = 1'b0; num_bytes = 2'b00;
                case(funct3)
                    3'd0: alu_sel = 4'b0000;
                    3'd4: alu_sel = 4'b0010;
                    3'd6: alu_sel = 4'b0011;
                    3'd7: alu_sel = 4'b0100;
                    3'd1: alu_sel = 4'b0101;
                    3'd5: begin
                        case(funct7)
                            7'd0: alu_sel = 4'b0110;
                            7'd32: alu_sel = 4'b0111;
                            default: alu_sel = 4'b0000
                        endcase
                    end
                    3'd2: alu_sel = 4'b1000;
                    3'd3: alu_sel = 4'b1001;
                    default: alu_sel = 4'b0000;
                endcase
            end
            7'b0000011: begin //Load
                reg_en = 1'b1; regmux = 2'b10;
                alumux1 = 1'b1; alumux2 = 1'b1; alu_sel = 4'b0000;
                jump = 1'b0; br_en = 1'b0; jalr = 1'b0;
                we = 1'b0;
                case(funct3)
                    3'd0: begin 
                        num_bytes = 2'b00;
                        sz = 1'b1;
                    end
                    3'd1: begin 
                        num_bytes = 2'b01;
                        sz = 1'b1;
                    end
                    3'd2: begin 
                        num_bytes = 2'b11;
                        sz = 1'b0;
                    end
                    3'd4: begin 
                        num_bytes = 2'b00;
                        sz = 1'b0;
                    end
                    3'd5: begin 
                        num_bytes = 2'b01;
                        sz = 1'b0;
                    end
                    default: begin 
                        num_bytes = 2'b11;
                        sz = 1'b0;
                    end
                endcase
            end
            7'b0100011: begin //Store
                reg_en = 1'b0; regmux = 2'b00;
                alumux1 = 1'b1; alumux2 = 1'b1; alu_sel = 4'b0000;
                jump = 1'b0; br_en = 1'b0; jalr = 1'b0;
                we = 1'b1; sz = 1'b0;
                case(funct3)
                    3'd0: num_bytes = 2'b00;
                    3'd1: num_bytes = 2'b01;
                    3'd2: num_bytes = 2'b11;
                    default: num_bytes = 2'b11;
                endcase
            end
            7'b1100011: begin //Branch
                reg_en = 1'b0; regmux = 2'b00;
                alumux1 = 1'b1; alumux2 = 1'b0;
                jump = 1'b0; br_en = 1'b1; jalr = 1'b0;
                we = 1'b0; sz = 1'b0; num_bytes = 2'b00;
                case(funct3)
                    3'd0: alu_sel = 4'b1010;
                    3'd1: alu_sel = 4'b1011;
                    3'd4: alu_sel = 4'b1000;
                    3'd5: alu_sel = 4'b1100;
                    3'd6: alu_sel = 4'b1001;
                    3'd7: alu_sel = 4'b1101;
                    default: alu_sel = 4'b0000;
                endcase

            end
            7'b1101111: begin //JAL
                reg_en = 1'b1; regmux = 2'b00;
                alumux1 = 1'b0; alumux2 = 1'b1; alu_sel = 4'b0000;
                jump = 1'b1; br_en = 1'b0; jalr = 1'b0;
                we = 1'b0; sz = 1'b0; num_bytes = 2'b00;
            end
            7'b1100111: begin //JALR
                reg_en = 1'b1; regmux = 2'b00;
                alumux1 = 1'b1; alumux2 = 1'b1; alu_sel = 4'b0000;
                jump = 1'b1; br_en = 1'b0; jalr = 1'b1;
                we = 1'b0; sz = 1'b0; num_bytes = 2'b00;
            end
            7'b0110111: begin //LUI
                reg_en = 1'b1; regmux = 2'b11;
                alumux1 = 1'b0; alumux2 = 1'b0; alu_sel = 4'b0000;
                jump = 1'b0; br_en = 1'b0; jalr = 1'b0;
                we = 1'b0; sz = 1'b0; num_bytes = 2'b00;
            end
            7'b0010111: begin //AUIPC
                reg_en = 1'b1; regmux = 2'b01;
                alumux1 = 1'b0; alumux2 = 1'b1; alu_sel = 4'b0000;
                jump = 1'b0; br_en = 1'b0; jalr = 1'b0;
                we = 1'b0; sz = 1'b0; num_bytes = 2'b00;
            end
            default: begin
                reg_en = 1'b0;
                regmux = 2'b00;
                alumux1 = 1'b0;
                alumux2 = 1'b0;
                alu_sel = 4'b0000;
                jump = 1'b0;
                br_en = 1'b0;
                jalr = 1'b0;
                we = 1'b0;
                sz = 1'b0;
                num_bytes = 2'b00;
            end
        endcase
    end

endmodule