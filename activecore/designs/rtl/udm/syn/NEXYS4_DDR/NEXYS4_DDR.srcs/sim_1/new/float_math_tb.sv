`timescale 1ns / 1ps

module float_math_tb;

logic[31:0] float1;
logic[31:0] float2;
logic[31:0] result;

float_math float_math(
  .float1(float1),
  .float2(float2),
  .result(result)
);

initial begin 
    float1 = 32'b00000011101100000000000000000000;
    float2 = 32'b0_0111_1111_0000_0000_0000_0000_0000_000;
    #100;
end


endmodule
