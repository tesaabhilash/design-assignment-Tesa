module d_ff_tb( );
reg d_tb,clk_tb,rst_tb;
wire q_tb,qbar_tb;
d_ff dut(.d(d_tb),.clk(clk_tb),.rst(rst_tb),.q(q_tb),.qbar(qbar_tb));
initial begin
{d_tb,clk_tb,rst_tb}=0;
end
always #5 clk_tb=~clk_tb;
initial begin
#10;
d_tb=1'b0;
#10;
$display("value of d is %b  value of q is %b  value of qbar is %b",d_tb,q_tb,qbar_tb);
d_tb=1'b1;
#10;
$display("value of d is %b  value of q is %b  value of qbar is %b",d_tb,q_tb,qbar_tb);
end
endmodule

