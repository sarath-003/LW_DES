module subkey_generator(skey,key,clk);
  
  output [1:48*16]skey; 
  reg [1:48*16] skey;
  input [1:64]key;
  input clk;
  parameter [1:16]R={1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1};
  reg [1:56]pc1key;
  reg [1:28]C;
  reg [1:28]D;
  reg [1:56]CD;
  integer round_no;
  
  function [1:56]permutation_choice1;
    input [1:64]key;
    integer i;
    parameter [1:56*6]PC1 = {6'd57, 6'd49, 6'd41, 6'd33, 6'd25, 6'd17, 6'd9, 6'd1, 6'd58,6'd50,6'd42,6'd34,6'd26,6'd18,6'd10,6'd2,6'd59,6'd51,6'd43,6'd35,6'd27,6'd19,6'd11,6'd3,6'd60,6'd52,6'd44,6'd36,6'd63,6'd55,6'd47,6'd39,6'd31,6'd23,6'd15,6'd7,6'd62,6'd54,6'd46,6'd38,6'd30,6'd22,6'd14,6'd6,6'd61,6'd53,6'd45,6'd37,6'd29,6'd21,6'd13,6'd5,6'd28,6'd20,6'd12,6'd4};
    begin
      for(i=1;i<=56;i=i+1) begin
        permutation_choice1[i] = key[PC1[6*i -: 6]];
      end
    end
  endfunction
  
  function [1:28]right_circular_shift;
    input [1:28]Cin;
    input n;
   begin
     if(n==0) right_circular_shift = {Cin[27:28],Cin[1:26]};
     else if(n==1) right_circular_shift = {Cin[28],Cin[1:27]};
   end
  endfunction
  
  function [1:48]permutation_choice2;
    input [1:56]CD;
    integer i;
    parameter [1:48*6]PC2={6'd14,6'd17,6'd11,6'd24,6'd1,6'd5,6'd3,6'd28,6'd15,6'd6,6'd21,6'd10,6'd23,6'd19,6'd12,6'd4,6'd26, 6'd8,6'd16,6'd7,6'd27,6'd20,6'd13,6'd2,6'd41,6'd52,6'd31,6'd37,6'd47,6'd55,6'd30,6'd40,6'd51,6'd45,6'd33,6'd48,6'd44,6'd49,6'd39,6'd56,6'd34,6'd53,6'd46,6'd42,6'd50,6'd36,6'd29,6'd32};
     begin
       for(i=1;i<=48;i=i+1) begin
         permutation_choice2[i]=CD[PC2[6*i -: 6]];
       end
     end
  endfunction
  
  always @(key) begin
    pc1key = permutation_choice1(key);
    C = pc1key[1:28];
    D = pc1key[29:56];
    round_no=1;
  end 

   always @(posedge clk) begin
     if (round_no<=16) begin
      C = right_circular_shift(C,R[round_no]);
      D = right_circular_shift(D,R[round_no]);
      CD = {C,D};
      skey[48*round_no -: 48] = permutation_choice2(CD);
      round_no=round_no+1;
     end
   end
endmodule
