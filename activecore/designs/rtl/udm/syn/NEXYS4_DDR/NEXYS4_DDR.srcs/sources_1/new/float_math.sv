module float_math
(
  input logic[31:0] float1,
  input logic[31:0] float2,
  output logic[31:0] result
);
  logic signed[7:0] exp1;
  logic signed[7:0] exp2;
  
  logic signed[24:0] mant1;
  logic signed[24:0] mant2;
  logic signed[24:0] mant1_sum_mant2;
  logic signed[24:0] mant1_diff_mant2;
  logic signed[24:0] mant1_sum_mant2_shift;

  logic sign_o;
  logic signed[7:0] exp_o;
  logic[22:0] mant_o;
  
  assign result[31] = sign_o;
  assign result[30:23] = exp_o;
  assign result[22:0] = mant_o[22:0];
  assign mant1_sum_mant2 = mant1 + mant2;
//  assign mant1_sum_mant2_shift = mant1_sum_mant2 >>> 1;
  
  logic signed [7:0] test;
//  assign test = {float2[31], 2'b01, float2[22:0]};
  
  always_comb begin 
    mant1 = {2'b01, float1[22:0]};
    mant2 = {2'b01, float2[22:0]};
  
    exp1 = float1[30:23] - 127;
    exp2 = float2[30:23] - 127;
    
    test = exp2;
    
    if (exp1 > exp2) begin
      mant2 = mant2 >> (exp1 - exp2);
//      exp2 = exp1;
    end else if(exp1 < exp2) begin
      mant1 = mant1 >> (exp2 - exp1);
      exp1 = exp2;
  	end
    exp_o = exp1 + 127;
    
    if (float1[31] ^ float2[31]) // diff signs
      begin
      if (mant1 >= mant2) 
        begin 
        mant1_diff_mant2 = mant1 - mant2;
        sign_o = float1[31];
        end
      else  // (mant2 > mant1) 
        begin
        mant1_diff_mant2 = mant2 - mant1;
        sign_o = float2[31];
        end
      for (int i = 0; i < 23; i++) 
        begin 
        if(mant1_diff_mant2[23] == 1) break;
        mant1_diff_mant2 = mant1_diff_mant2 << 1;
        exp_o = exp_o - 1;
        if((i == 23) && (mant1_diff_mant2[23] == 0)) exp_o = 'b0;
        end
      mant_o = mant1_diff_mant2[22:0];
    end else if (mant1_sum_mant2[24] == 1)
      begin // overflow, same signs
      mant_o = mant1_sum_mant2_shift[22:0];
      exp_o = exp_o + 1;
      sign_o = float1[31];
    end else // no overflow, same signs
      begin
      mant_o = mant1_sum_mant2[22:0];
      sign_o = float1[31];
      end
  end
endmodule

    