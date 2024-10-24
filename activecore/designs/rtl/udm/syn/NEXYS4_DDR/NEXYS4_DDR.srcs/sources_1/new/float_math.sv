module float_math
(
  input logic[31:0] float1,
  input logic[31:0] float2,
  output logic[31:0] result
);
  logic[1:0]implicit_bit1 = 2'b01;
  logic[1:0]implicit_bit2 = 2'b01;
  
//   a = b ? c : d;
  
  logic signed[7:0] exp1;// = float1[30:23];
  logic signed[7:0] exp2;// = float2[30:23];
  
  logic signed[25:0] mant1;// = {float1[31], implicit_bit1, float1[22:0]};
  logic signed[25:0] mant2;// = {float2[31], implicit_bit2, float2[22:0]};
  logic signed[25:0] mant1_sum_mant2;// = mant1 + mant2;
  logic signed[25:0] mant1_sum_mant2_shift;// = mant1_sum_mant2 >>> 1;

  logic sign_o;// = result[31];
  logic signed[7:0] exp_o;// = result[30:23];
  logic[22:0] mant_o;// = result[22:0];
  
//  assign exp1 = float1[30:23];
//  assign exp2 = float2[30:23];
//  assign mant1 = {float1[31], implicit_bit1, float1[22:0]};
//  assign mant2 = {float2[31], implicit_bit2, float2[22:0]};
//  assign mant1_sum_mant2 = mant1 + mant2;
//  assign mant1_sum_mant2_shift = mant1_sum_mant2 >>> 1;
  
  assign result[31] = sign_o;
  assign result[30:23] = exp_o;
  assign result[22:0] = mant_o[22:0];
  
  
  always_comb begin 
    mant1 = {float1[31], implicit_bit1, float1[22:0]};
    mant2 = {float2[31], implicit_bit2, float2[22:0]};
    mant1_sum_mant2 = mant1 + mant2;
    mant1_sum_mant2_shift = mant1_sum_mant2 >>> 1;
  
    exp1 = float1[30:23];
    exp2 = float2[30:23];
    
    if (exp1 >= exp2) begin
      mant2 = mant2 >>> (exp1 - exp2);
      exp2 = exp1;
    end else begin
      mant1 = mant1 >>> (exp2 - exp1);
      exp1 = exp2;
  	end
    exp_o = exp1;
    
    if (mant1_sum_mant2[24] == 1) begin // overfloat
      mant_o = mant1_sum_mant2_shift[22:0];
      exp_o = exp_o + 1;
    end else begin
      mant_o = mant1_sum_mant2[22:0];
    end
    sign_o = mant1_sum_mant2[25];
  end
endmodule

    