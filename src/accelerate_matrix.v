`timescale 1ns/10ps
module accelerate_matrix (
    input clk,
    input rst,
    input [31:0]wmatrix,
    input [31:0]xmatrix,
    input [31:0]bias,
    output reg [15:0]out1,
    output reg [15:0]out2,
    output reg [15:0]out3,
    output reg [15:0]out4
);
    wire enb_dff8,enb_dffb,enb_m4,enb_out;
    wire [1:0]sel_dff8,sel_out;
    wire [7:0] wire_w [0:15];
    wire [7:0] wire_x [0:15];
    wire [7:0] wire_b [0:3];
    wire [15:0] wire_m4 [0:15];
    
    DFF8 D1(
        .clk(clk),
        .rst(rst),
        .enb(enb_dff8),
        .sel(sel_dff8),
        .in_data(wmatrix),
        .out0(wire_w[0]),
        .out1(wire_w[1]),
        .out2(wire_w[2]),
        .out3(wire_w[3]),
        .out4(wire_w[4]),
        .out5(wire_w[5]),
        .out6(wire_w[6]),
        .out7(wire_w[7]),
        .out8(wire_w[8]),
        .out9(wire_w[9]),
        .out10(wire_w[10]),
        .out11(wire_w[11]),
        .out12(wire_w[12]),
        .out13(wire_w[13]),
        .out14(wire_w[14]),
        .out15(wire_w[15])
    );

    DFF8 D2(
        .clk(clk),
        .rst(rst),
        .enb(enb_dff8),
        .sel(sel_dff8),
        .in_data(xmatrix),
        .out0(wire_x[0]),
        .out1(wire_x[1]),
        .out2(wire_x[2]),
        .out3(wire_x[3]),
        .out4(wire_x[4]),
        .out5(wire_x[5]),
        .out6(wire_x[6]),
        .out7(wire_x[7]),
        .out8(wire_x[8]),
        .out9(wire_x[9]),
        .out10(wire_x[10]),
        .out11(wire_x[11]),
        .out12(wire_x[12]),
        .out13(wire_x[13]),
        .out14(wire_x[14]),
        .out15(wire_x[15])
    );

    DFFb D3(
        .clk(clk),
        .rst(rst),
        .enb(enb_dffb),
        .in_data(bias),
        .out0(wire_b[0]),
        .out1(wire_b[1]),
        .out2(wire_b[2]),
        .out3(wire_b[3])
    );

    genvar i, j;
    generate
        for (i = 0; i < 4; i = i + 1) begin : row_loop
            for (j = 0; j < 4; j = j + 1) begin : col_loop
                m4 a_inst (
                    .clk(clk),
                    .rst(rst),
                    .enb(enb_m4),
                    .a0(wire_w[i * 4 + 0]),
                    .a1(wire_w[i * 4 + 1]),
                    .a2(wire_w[i * 4 + 2]),
                    .a3(wire_w[i * 4 + 3]),
                    .b0(wire_x[i * 4 + 0]),
                    .b1(wire_x[i * 4 + 1]),
                    .b2(wire_x[i * 4 + 2]),
                    .b3(wire_x[i * 4 + 3]),
                    .bias(wire_b[i]),
                    .out_data(wire_m4[i * 4 + j])
                );
            end
        end
    endgenerate

    always @(*) begin
        if(enb_out)begin
            case(sel_out)
                2'b00:begin
                    out1 = wire_m4[0];
                    out2 = wire_m4[1];
                    out3 = wire_m4[2];
                    out4 = wire_m4[3];
                end
                2'b01:begin
                    out1 = wire_m4[4];
                    out2 = wire_m4[5];
                    out3 = wire_m4[6];
                    out4 = wire_m4[7];
                end
                2'b10:begin
                    out1 = wire_m4[8];
                    out2 = wire_m4[9];
                    out3 = wire_m4[10];
                    out4 = wire_m4[11];
                end
                2'b11:begin
                    out1 = wire_m4[12];
                    out2 = wire_m4[13];
                    out3 = wire_m4[14];
                    out4 = wire_m4[15];
                end
            endcase
        end
    end

    control c1(
        .clk(clk),
        .rst(rst),
        .enb_dff8(enb_dff8),
        .sel_dff8(sel_dff8),
        .enb_dffb(enb_dffb),
        .enb_m4(enb_m4),
        .enb_out(enb_out),
        .sel_out(sel_out)
    );

endmodule

//module DFF8--------------------------------------------------------------------------------------
module DFF8 (
    input clk,
    input rst,
    input enb,
    input [1:0]sel,
    input [31:0]in_data,
    output reg [7:0]out0,
    output reg [7:0]out1,
    output reg [7:0]out2,
    output reg [7:0]out3,
    output reg [7:0]out4,
    output reg [7:0]out5,
    output reg [7:0]out6,
    output reg [7:0]out7,
    output reg [7:0]out8,
    output reg [7:0]out9,
    output reg [7:0]out10,
    output reg [7:0]out11,
    output reg [7:0]out12,
    output reg [7:0]out13,
    output reg [7:0]out14,
    output reg [7:0]out15
);
    always @(posedge clk or posedge rst) begin
        if(rst)begin
            out0 <= 8'd0;
            out1 <= 8'd0;
            out2 <= 8'd0;
            out3 <= 8'd0;
            out4 <= 8'd0;
            out5 <= 8'd0;
            out6 <= 8'd0;
            out7 <= 8'd0;
            out8 <= 8'd0;
            out9 <= 8'd0;
            out10 <= 8'd0;
            out11 <= 8'd0;
            out12 <= 8'd0;
            out13 <= 8'd0;
            out14 <= 8'd0;
            out15 <= 8'd0; 
        end
        else begin
            if(enb)begin
                case(sel)
                2'b00:begin
                    out0 <= in_data[31:24];
                    out1 <= in_data[23:16];
                    out2 <= in_data[15:8];
                    out3 <= in_data[7:0];
                end
                2'b01:begin
                    out4 <= in_data[31:24];
                    out5 <= in_data[23:16];
                    out6 <= in_data[15:8];
                    out7 <= in_data[7:0];
                end
                2'b10:begin
                    out8 <= in_data[31:24];
                    out9 <= in_data[23:16];
                    out10 <= in_data[15:8];
                    out11 <= in_data[7:0];
                end
                2'b11:begin
                    out12 <= in_data[31:24];
                    out13 <= in_data[23:16];
                    out14 <= in_data[15:8];
                    out15 <= in_data[7:0];
                end
                endcase
            end
        end
    end
endmodule

//module DFFb--------------------------------------------------------------------------------------
module DFFb (
    input clk,
    input rst,
    input enb,
    input [31:0]in_data,
    output reg [7:0]out0,
    output reg [7:0]out1,
    output reg [7:0]out2,
    output reg [7:0]out3
);
    always @(posedge clk or posedge rst) begin
        if(rst)begin
            out0 <= 8'd0;
            out1 <= 8'd0;
            out2 <= 8'd0;
            out3 <= 8'd0;
        end
        else begin
            if(enb)begin
                out0 <= in_data[31:24];
                out1 <= in_data[23:16];
                out2 <= in_data[15:8];
                out3 <= in_data[7:0];
            end
        end
    end
endmodule

//module m4----------------------------------------------------------------------------------------
module m4 (
    input clk,
    input rst,
    input enb,
    input [7:0]a0,
    input [7:0]a1,
    input [7:0]a2,
    input [7:0]a3,
    input [7:0]b0,
    input [7:0]b1,
    input [7:0]b2,
    input [7:0]b3,
    input [7:0]bias,
    output reg [15:0] out_data
);
    reg [15:0]p0,p1,p2,p3;
    reg [17:0]sum1,sum2,temp_out;
    always @(posedge clk or posedge rst) begin
        if(rst)begin
            p0 <= 16'd0;
            p1 <= 16'd0;
            p2 <= 16'd0;
            p3 <= 16'd0;
            sum1 <= 18'd0;
            sum2 <= 18'd0;
            out_data <= 18'd0;
        end
        else if (enb)begin
            p0 <= a0 * b0;
            p1 <= a1 * b1;
            p2 <= a2 * b2;
            p3 <= a3 * b3;
            sum1 <= p0 + p1;
            sum2 <= p2 + p3;
            temp_out <= sum1 + sum2 +bias;
            out_data <= (temp_out[15])?16'd0:temp_out[15:0];
        end
    end
endmodule

//module control-----------------------------------------------------------------------------------
module control (
    input clk,
    input rst,
    output reg enb_dff8,
    output reg [1:0]sel_dff8,
    output reg enb_dffb,
    output reg enb_m4,
    output reg enb_out,
    output reg [1:0]sel_out
);
    reg [3:0]state;      //current state
    reg [3:0]next_state; //next state

    //state
    parameter s0 = 4'd0;
    parameter s1 = 4'd1;
    parameter s2 = 4'd2;
    parameter s3 = 4'd3;
    parameter s4 = 4'd4;
    parameter s5 = 4'd5;
    parameter s6 = 4'd6;
    parameter s7 = 4'd7;
    parameter s8 = 4'd8;
    parameter s9 = 4'd9;
    parameter s10 = 4'd10;
    parameter s11 = 4'd11;
    parameter s12 = 4'd12;

    always @(posedge clk or posedge rst) begin
        if(rst)begin
            state <= s0;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case(state)
            s0: next_state = s1;
            s1: next_state = s2;
            s2: next_state = s3;
            s3: next_state = s4;
            s4: next_state = s5;
            s5: next_state = s6;
            s6: next_state = s7;
            s7: next_state = s8;
            s8: next_state = s9;
            s9: next_state = s10;
            s10: next_state = s11;
            s11: next_state = s12;
            s12: next_state = s0;
            default: next_state = s0;
        endcase
    end

    always @(*)begin
        case(state)
            s0:begin
                enb_dff8 = 1'b0;
                sel_dff8 = 2'b00;
                enb_dffb = 1'b0;
                enb_m4 = 1'b0;
                enb_out = 1'b0;
                sel_out = 2'b00;
            end
            s1:begin
                enb_dff8 = 1'b1;
                sel_dff8 = 2'b00;
                enb_dffb = 1'b1;
                enb_m4 = 1'b0;
                enb_out = 1'b0;
                sel_out = 2'b00;
            end
            s2:begin
                enb_dff8 = 1'b1;
                sel_dff8 = 2'b01;
                enb_dffb = 1'b0;
                enb_m4 = 1'b0;
                enb_out = 1'b0;
                sel_out = 2'b00;
            end
            s3:begin
                enb_dff8 = 1'b1;
                sel_dff8 = 2'b10;
                enb_dffb = 1'b0;
                enb_m4 = 1'b0;
                enb_out = 1'b0;
                sel_out = 2'b00;
            end
            s4:begin
                enb_dff8 = 1'b1;
                sel_dff8 = 2'b11;
                enb_dffb = 1'b0;
                enb_m4 = 1'b0;
                enb_out = 1'b0;
                sel_out = 2'b00;
            end
            s5:begin
                enb_dff8 = 1'b0;
                sel_dff8 = 2'b00;
                enb_dffb = 1'b0;
                enb_m4 = 1'b1;
                enb_out = 1'b0;
                sel_out = 2'b00;
            end
            s6:begin
                enb_dff8 = 1'b0;
                sel_dff8 = 2'b00;
                enb_dffb = 1'b0;
                enb_m4 = 1'b1;
                enb_out = 1'b0;
                sel_out = 2'b00;
            end
            s7:begin
                enb_dff8 = 1'b0;
                sel_dff8 = 2'b00;
                enb_dffb = 1'b0;
                enb_m4 = 1'b1;
                enb_out = 1'b0;
                sel_out = 2'b00;
            end
            s8:begin
                enb_dff8 = 1'b0;
                sel_dff8 = 2'b00;
                enb_dffb = 1'b0;
                enb_m4 = 1'b1;
                enb_out = 1'b0;
                sel_out = 2'b00;
            end
            s9:begin
                enb_dff8 = 1'b0;
                sel_dff8 = 2'b00;
                enb_dffb = 1'b0;
                enb_m4 = 1'b0;
                enb_out = 1'b1;
                sel_out = 2'b00;
            end
            s10:begin
                enb_dff8 = 1'b0;
                sel_dff8 = 2'b00;
                enb_dffb = 1'b0;
                enb_m4 = 1'b0;
                enb_out = 1'b1;
                sel_out = 2'b01;
            end
            s11:begin
                enb_dff8 = 1'b0;
                sel_dff8 = 2'b00;
                enb_dffb = 1'b0;
                enb_m4 = 1'b0;
                enb_out = 1'b1;
                sel_out = 2'b10;
            end
            s12:begin
                enb_dff8 = 1'b0;
                sel_dff8 = 2'b00;
                enb_dffb = 1'b0;
                enb_m4 = 1'b0;
                enb_out = 1'b1;
                sel_out = 2'b11;
            end
            default:begin
                enb_dff8 = 1'b0;
                sel_dff8 = 2'b00;
                enb_dffb = 1'b0;
                enb_m4 = 1'b0;
                enb_out = 1'b0;
                sel_out = 2'b00;
            end
        endcase
    end
endmodule
