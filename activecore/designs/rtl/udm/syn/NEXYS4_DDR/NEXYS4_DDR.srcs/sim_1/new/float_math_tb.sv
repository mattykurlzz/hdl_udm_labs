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
    float1 = 32'b11000000010010010000111001010110;
    float2 = 32'b01000001110110010111000010100100;
    #100;
    $display("sum = %b", result);
end

endmodule
