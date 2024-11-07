module float_math
(
  input wire rst_i,
  input reg[31:0] float1,
  input reg[31:0] float2,
  input wire clk_i,
  output reg[31:0] result
);
  reg signed[7:0] exp1_initial;
  reg signed[7:0] exp2_initial;
  reg signed[7:0] exp_2;
  reg signed[7:0] exp_3;

  reg signed[7:0] exp_out;
  
  reg signed[24:0] mant1_initial;
  reg signed[24:0] mant2_initial;
  reg signed[24:0] mant1_2;
  reg signed[24:0] mant2_2;
  reg signed[24:0] mant_sum_2;
  reg signed[24:0] mant_3;

  reg signed[24:0] mant_out;

  reg sign1_initial;
  reg sign2_initial;
  reg sign1_2;
  reg sign2_2;  
  reg sign_3;  
  reg sign_out;

  int shift;
  
  always @ (posedge clk_i) begin // one cycle logic
    if (rst_i) begin
      mant1_initial <= 0; 
      mant2_initial <= 0;
      exp1_initial <= 0;
      exp2_initial <= 0;
      sign1_initial <= 0;
      sign2_initial <= 0;
    end 
    else begin
      mant1_initial <= {2'b01, float1[22:0]}; 
      mant2_initial <= {2'b01, float2[22:0]};
      exp1_initial <= float1[30:23] - 127;
      exp2_initial <= float2[30:23] - 127;
      sign1_initial <= float1[31];
      sign2_initial <= float2[31];
    end
  end

  always @ (posedge clk_i) begin // one cycle logic
    if (rst_i) begin
      mant1_2 <= 0;
      mant2_2 <= 0;
      mant_sum_2 <= 0;
      exp_2 <= 0;
      exp_2 <= 0;
      sign1_2 <= 0;
      sign2_2 <= 0;
    end 
    else begin
    if (exp1_initial > exp2_initial) begin
      mant2_2 <= mant2_initial >> (exp1_initial - exp2_initial);
      mant1_2 <= mant1_initial;
      mant_sum_2 <= (mant1_initial + (mant2_initial >> (exp1_initial - exp2_initial)));
      exp_2 <= exp1_initial;
    end else begin
      mant1_2 <= mant1_initial >> (exp2_initial - exp1_initial);
      mant2_2 <= mant2_initial;
      mant_sum_2 <= ((mant1_initial >> (exp2_initial - exp1_initial)) + mant2_initial);
      exp_2 <= exp2_initial;
  	end
    sign1_2 <= sign1_initial;
    sign2_2 <= sign2_initial;
    end
  end
    
  always @ (posedge clk_i) begin // one cycle logic
    if (rst_i) begin
      mant_3 <= 0;
      sign_3 <= 0;
      exp_3 <= 0;
      shift <= 0;
    end
    else begin
    if (sign1_2 ^ sign2_2) // diff signs
      begin
      if (mant1_2 >= mant2_2) 
        begin 
        mant_3 <= mant1_2 - mant2_2;
        sign_3 <= sign1_2;
        exp_3 <= exp_2 + 127;
        end
      else /* (mant2 > mant1) */
        begin
        mant_3 <= mant2_2 - mant1_2;
        sign_3 <= sign2_2;
        exp_3 <= exp_2 + 127;
        end
    end else if (mant_sum_2[24] == 1)
      begin // overflow, same signs
      mant_3 <= mant_sum_2 >>> 1;
      exp_3 <= exp_2 + 127 + 1;
      sign_3 <= sign1_2;
    end else // no overflow, same signs
      begin
      mant_3 <= {mant1_2 + mant2_2};
      sign_3 <= sign1_2;
      exp_3 <= exp_2 + 127;
      end

    for (int i = 23; i >= 0; i--) 
      begin 
      if(mant_3[i] == 1) begin
        shift <= 23 - i;
        break;
      end
      // if((i == 23) && (mant_3[i] == 0)) exp_o <= 23;
      end
    end
  end

  always @ (posedge clk_i) begin // one cycle logic
  if (rst_i) begin
    mant_out <= 0;
    exp_out <= 0;
    sign_out <= 0;
  end
  else begin
    sign_out = sign_3;
    if((shift == 23) && (mant_3[shift] == 0)) begin 
      mant_out <= 0;
      exp_out <= 0;
    end else begin
      mant_out <= mant_3 << shift;
      exp_out <= exp_3 - shift;
    end
  end
  end

  always @ (posedge clk_i) begin // one cycle logic
    result[31] <= sign_out;
    result[30:23] <= exp_out;
    result[22:0] <= mant_out[22:0];
  end
endmodule

    