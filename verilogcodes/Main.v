module DES_Main (ptext, ctext, key, clock);

input clock;
input [64:1] ctext;
input [64:1] key;
output [64:1] ptext;

reg [32:1]left;
reg [32:1]right;
integer i;
reg [32:1]templeft;
reg [32:1]tempright;   

always @(ctext) 
begin
i = 0;
left = ctext[64:33];
right = ctext[32:1];

end

wire [1:48*16]skey;

subkey_generator SG (skey, key, clock);

function [1:48]expanded_data;
    input [1:32]data;
    integer i;
    begin
        expanded_data [1 : 6] = { data[32], data[1:4], data[5] };
      for(i=1;i<=6;i=i+1) 
        begin
          expanded_data[ (6*i)+1 +: 6 ] = data[ 4*i +: 6 ];
        end
        expanded_data [43 : 48] = { data[28], data[29:32], data[1] };
    end
  endfunction

function [1:4] s_out;
//module sbox(addr, dout);
input	[1:6] addr;
//output	[1:4] dout;
//reg	[1:4] dout;
begin
    case ({addr[1], addr[6], addr[2:5]})	//This maps to the values of the SBox table
         0:  s_out =  14;
         1:  s_out =   5;
         2:  s_out =   7;
         3:  s_out =   2;
         4:  s_out =  11;
         5:  s_out =   8;
         6:  s_out =   1;
         7:  s_out =  15;
         8:  s_out =   0;
         9:  s_out =  10;
        10:  s_out =   9;
        11:  s_out =   4;
        12:  s_out =   6;
        13:  s_out =  13;
        14:  s_out =  12;
        15:  s_out =   3;

        16:  s_out =   5;
        17:  s_out =   0;
        18:  s_out =   8;
        19:  s_out =  15;
        20:  s_out =  14;
        21:  s_out =   3;
        22:  s_out =   2;
        23:  s_out =  12;
        24:  s_out =  11;
        25:  s_out =   7;
        26:  s_out =   6;
        27:  s_out =   9;
        28:  s_out =  13;
        29:  s_out =   4;
        30:  s_out =   1;
        31:  s_out =  10;

        32:  s_out =   4;
        33:  s_out =   9;
        34:  s_out =   2;
        35:  s_out =  14;
        36:  s_out =   8;
        37:  s_out =   7;
        38:  s_out =  13;
        39:  s_out =   0;
        40:  s_out =  10;
        41:  s_out =  12;
        42:  s_out =  15;
        43:  s_out =   1;
        44:  s_out =   5;
        45:  s_out =  11;
        46:  s_out =   3;
        47:  s_out =   6;

        48:  s_out =   9;
        49:  s_out =   6;
        50:  s_out =  15;
        51:  s_out =   5;
        52:  s_out =   3;
        53:  s_out =   8;
        54:  s_out =   4;
        55:  s_out =  11;
        56:  s_out =   7;
        57:  s_out =   1;
        58:  s_out =  12;
        59:  s_out =   2;
        60:  s_out =   0;
        61:  s_out =  14;
        62:  s_out =  10;
        63:  s_out =  13;

    endcase

end
endfunction

function [1:32]perm_p;
    input [1:32]out;
    integer i;
    parameter [1:32*6]P = {6'd16, 6'd7, 6'd20, 6'd21, 6'd29, 6'd12, 6'd28, 6'd17, 6'd1,6'd15,6'd23,6'd26,6'd5,6'd18,6'd31,6'd10,6'd2,6'd8,6'd24,6'd14,6'd32,6'd27,6'd3,6'd9,6'd19,6'd13,6'd30,6'd6,6'd22,6'd11,6'd4,6'd25};
    begin
      for(i=1;i<=32;i=i+1)
		begin
			perm_p[i] = out[P[6*i -: 6]];
		end
    end
endfunction

function [1:32]f_out;    
    input [1:32]data;
	input [1:48]key;
	reg [1:32] temp;
	reg [1:48] s_in;  
    integer i;

begin
    s_in = expanded_data(data)^key;
    for(i=1;i<=8;i=i+1)
    temp[4*i -: 4]= s_out(s_in[(6*i) -: 6]);
    f_out = perm_p(temp);
end
endfunction

task round;

	input [32:1]Lin,Rin;
	input [48:1]key;
	output[32:1]Lout,Rout; 
	
	//wire Fout[32:1];
	
	begin
		//Fout = f_out(Rin,key);
		Rout = Lin ^ f_out(Rin, key);
		Lout = Rin;
	end

endtask

always@(posedge clock)
begin
    if(i <= 16 && i>0)
    begin
        round(left, right, skey[(48*i) -: 48], templeft, tempright);
        left=templeft;
        right=tempright;
        i = i+1;
    end 
    else if (i==0)
    begin
		i = i+1;
    end   
end

assign ptext = {right,left};

endmodule
