module seq_detect1110_tb();
reg clk_tb,rst_tb,din_tb;
wire detected_tb;
seq_detect1110 dut(.clk(clk_tb),.rst(rst_tb),.din(din_tb),.detected(detected_tb));
initial begin
{clk_tb,rst_tb,din_tb}=0;
end
always #5 clk_tb=~clk_tb;
initial begin
rst_tb=1;#10;
rst_tb=0;
$display("reset done");
$strobe("value of input is %b  value of output is %b",din_tb,detected_tb);
din_tb=1;#10;
$strobe("value of input is %b  value of output is %b",din_tb,detected_tb);
din_tb=1;#10;
$strobe("value of input is %b  value of output is %b",din_tb,detected_tb);
din_tb=1;#10;
$strobe("value of input is %b  value of output is %b",din_tb,detected_tb);
din_tb=1;#10;
$strobe("value of input is %b  value of output is %b",din_tb,detected_tb);
din_tb=0;#10;
$strobe("value of input is %b  value of output is %b",din_tb,detected_tb);
din_tb=1;#10;
$strobe("value of input is %b  value of output is %b",din_tb,detected_tb);
din_tb=0;#10;
end
endmodule
