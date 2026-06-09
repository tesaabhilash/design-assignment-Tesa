module sr_ff_tb();
reg s_tb,r_tb,rst_tb,clk_tb;
wire q_tb,qbar_tb;
sr_ff dut(.s(s_tb),.r(r_tb),.rst(rst_tb),.clk(clk_tb),.q(q_tb),.qbar(qbar_tb));
initial
begin
{s_tb,r_tb,rst_tb,clk_tb}=0;
end
always #5 clk_tb=~clk_tb;
initial 
 begin
 #10;
 rst_tb=1;
 #10;
 rst_tb=0; s_tb=0; r_tb=0;
 #10;
  $display("value of s is %b  value of r is %b  value of q is %b  value of qbar is %b",s_tb,r_tb,q_tb,qbar_tb);
 s_tb=0; r_tb=1;
 #10;
 $display("value of s is %b  value of r is %b  value of q is %b  value of qbar is %b",s_tb,r_tb,q_tb,qbar_tb);
 s_tb=1; r_tb=0;
 #10;
 $display("value of s is %b  value of r is %b  value of q is %b  value of qbar is %b",s_tb,r_tb,q_tb,qbar_tb);
 s_tb=1; r_tb=1; 
 #10;
 $display("value of s is %b  value of r is %b  value of q is %b  value of qbar is %b",s_tb,r_tb,q_tb,qbar_tb);
 $finish;
 end
endmodule

