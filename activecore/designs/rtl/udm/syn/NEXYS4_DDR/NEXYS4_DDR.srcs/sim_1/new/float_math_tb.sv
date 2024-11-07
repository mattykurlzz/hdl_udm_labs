`timescale 1ns / 1ps

module float_math_tb;

logic clk;
logic rst = 0;
logic[31:0] float1;
logic[31:0] float2;
logic[31:0] result;

float_math float_math(
  .rst_i(rst),
  .float1(float1),
  .float2(float2),
  .clk_i(clk),
  .result(result)
);

initial begin 
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin 
    rst = 1;
    #50 rst = 0;
    #5 float1 = 32'b11000000010010010000111001010110; // -3.14
    float2 = 32'b01000001110110010111000010100100; // 27.
    #50;
    float1 = 32'b01000001111011000110010001011010; // 29.54
    float2 = 32'b11000100100111001100100110011010; // - 1254.3
    #50;
    $stop;
end

endmodule
