module ripplecarry_tb();
reg [3:0]A;
reg [3:0]B;
reg C;
wire [3:0]sum;
wire cout;
ripplecarry dut(A,B,C,sum,cout);
initial
begin
$monitor("value of A is %b  value of B is %b  value of C is %b  value of sum is %b  value of carry is %b",A,B,C,sum,cout);
A=8; B=4; C=0;#10;
A=3; B=1; C=1;#10;
A=5; B=9; C=1;#10;
end
endmodule

