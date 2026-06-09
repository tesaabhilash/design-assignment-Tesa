module bcd_tb();
reg [3:0]A,B;
reg C;
wire [3:0]sum;
wire cout;
bcd dut(A,B,C,sum,cout);
initial
begin
$monitor("value of A is %b  value of B is %b  value of C is %b  value of sum is %b  value of cout is %b",A,B,C,sum,cout);
A=4; B=6; C=1;#10;
A=1; B=13; C=0;#10;
A=3; B=9; C=0;#10;
A=7; B=1; C=1;#10;
end
endmodule
