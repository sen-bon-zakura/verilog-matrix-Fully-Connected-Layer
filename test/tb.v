`timescale 1ns/10ps
`define CYCLE 10.0
`define FILE_ANS "C:/Users/wei/Desktop/code/ans.txt"
module testbench();
    reg CLK = 0;
    reg RST = 0;
    reg [31:0] DATA1;
    reg [31:0] DATA2;
    reg [31:0] DATA3;

    wire [15:0] outcome1,outcome2,outcome3,outcome4;
    reg [31:0] data1_set [0:3];
    reg [31:0] data2_set [0:256];
    reg [31:0] data3_set [0:63];

    integer file_ans,i,temp;
    accelerate_matrix accelerate_matrix(
        .clk(CLK),
        .rst(RST),
        .wmatrix(DATA1),
        .xmatrix(DATA2),
        .bias(DATA3),
        .out1(outcome1),
        .out2(outcome2),
        .out3(outcome3),
        .out4(outcome4)
    );

    always begin #(`CYCLE/2) CLK = ~CLK; end


    initial begin

        file_ans = $fopen(`FILE_ANS, "w");

        data1_set[0] = 32'b00000000_00000001_00000010_00000011;
        data1_set[1] = 32'b00000100_00000101_00000110_00000111;
        data1_set[2] = 32'b00001000_00001001_00001010_00001011;
        data1_set[3] = 32'b00001100_00001101_00001110_00001111;
        
        for (i = 0; i < 256; i = i + 1) begin
            data2_set[i*4 + 0] = {8'h01, 8'h00 + i[3:0], 8'h10 - i[3:0], i[7:0]};
            data2_set[i*4 + 1] = {8'h01, 8'h01 ^ i[4:0], i[7:0], 8'h00};
            data2_set[i*4 + 2] = {8'h00, 8'hFF - i[5:0], 8'h00 + i[2:0], 8'h01};
            data2_set[i*4 + 3] = {8'h00, i[7:0], 8'h01 ^ i[1:0], 8'h00};
        end

        for (i = 0; i < 64; i = i + 1) begin
            data3_set[i] = {8'd0, i[7:0] ^ 8'hA5, 8'd3 + i[1:0], i[7:0] + 8'h11};
        end


        $display("----------------------------------------\n");
        $display("-        accelerate_matrix run         -\n");
        $display("----------------------------------------\n");

        RST = 1;
        CLK = 0;
        #(`CYCLE);
        RST = 0;
        CLK = 1;
        #(`CYCLE);
        for(i=0;i<64;i=i+1)begin
            DATA1 = data1_set[0];
            DATA2 = data2_set[i*4+0];
            DATA3 = data3_set[i];
            #(`CYCLE);
            DATA1 = data1_set[1];
            DATA2 = data2_set[i*4+1];
            #(`CYCLE);
            DATA1 = data1_set[2];
            DATA2 = data2_set[i*4+2];
            #(`CYCLE);
            DATA1 = data1_set[3];
            DATA2 = data2_set[i*4+3];
            #(`CYCLE*5);
            $fwrite(file_ans, "first row:\n");
            $fwrite(file_ans, "-->%x\n", outcome1);
            $fwrite(file_ans, "-->%x\n", outcome2);
            $fwrite(file_ans, "-->%x\n", outcome3);
            $fwrite(file_ans, "-->%x\n", outcome4);
            $fwrite(file_ans, "----------\n");
            #(`CYCLE);

            $fwrite(file_ans, "second row:\n");
            $fwrite(file_ans, "-->%x\n", outcome1);
            $fwrite(file_ans, "-->%x\n", outcome2);
            $fwrite(file_ans, "-->%x\n", outcome3);
            $fwrite(file_ans, "-->%x\n", outcome4);
            $fwrite(file_ans, "----------\n");
            #(`CYCLE);

            $fwrite(file_ans, "third row:\n");
            $fwrite(file_ans, "-->%x\n", outcome1);
            $fwrite(file_ans, "-->%x\n", outcome2);
            $fwrite(file_ans, "-->%x\n", outcome3);
            $fwrite(file_ans, "-->%x\n", outcome4);
            $fwrite(file_ans, "----------\n");
            #(`CYCLE);

            $fwrite(file_ans, "fourth row:\n");
            $fwrite(file_ans, "-->%x\n", outcome1);
            $fwrite(file_ans, "-->%x\n", outcome2);
            $fwrite(file_ans, "-->%x\n", outcome3);
            $fwrite(file_ans, "-->%x\n", outcome4);
            $fwrite(file_ans, "----------\n");
            #(`CYCLE*2);
        end

        $fclose(file_ans);
        $finish;
    end
endmodule

