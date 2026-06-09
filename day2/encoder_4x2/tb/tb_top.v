module encoder_4x2_tb();
reg [3:0]d_tb;
wire [1:0]b_tb;
encoder_4x2 dut(.d(d_tb),.b(b_tb));
integer m;
initial
begin
d_tb=4'b0000;
end
initial
begin
for(m=0;m<4;m=m+1)
begin
#10;
$monitor("value of d is %b value of b is %b",d_tb,b_tb);
d_tb=4'b0000;
d_tb[m]=1'b1;
end
end
