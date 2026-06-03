module immediate_generator (
    input [31:0] data_in,
    output reg [31:0] data_out
);

always @(*) begin
    data_out = 32'd0;
    case(data_in[6:0])
        //I-type
        7'b0010011, 7'b0000011, 7'b1100111: begin
            data_out = {{21{data_in[31]}}, data_in[30:20]};
        end
        //S-Type
        7'b0100011: begin
            data_out = {{21{data_in[31]}}, data_in[30:25], data_in[11:7]};
        end
        //B-Type
        7'b1100011: begin
            data_out = {{20{data_in[31]}}, data_in[7], data_in[30:25], data_in[11:8], 1'b0};
        end
        //U-Type
        7'b0110111, 7'b0010111: begin
            data_out = {data_in[31:12], 12'd0};
        end
        //J-Type
        7'b1101111: begin
            data_out = {{12{data_in[31]}}, data_in[19:12], data_in[20], data_in[30:21], 1'b0};
        end

        default: data_out = 32'd0;
    endcase
end


endmodule