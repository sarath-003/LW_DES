module test();
reg clock;
reg [64:1] ctext;
reg [64:1] key;
wire [64:1] ptext;

DES_Main M1(.ptext(ptext), .ctext(ctext), .key(key), .clock(clock));

always #5 clock = ~clock;

initial
    begin
	clock=1'b0;
	ctext=64'hcf245c04cce07661;
	key=64'h133457799bbcdff1;
	#175 $finish;
    end
endmodule
