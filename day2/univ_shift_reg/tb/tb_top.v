module univ_reg_tb();
reg clk_tb,rst_tb,sin_tb,shift_tb,load_tb,mod_tb;
reg [3:0]pin_tb;
wire sout_tb;
wire [3:0]pout_tb;
univ_reg dut(clk_tb,rst_tb,sin_tb,shift_tb,load_tb,mod_tb,pin_tb,sout_tb,pout_tb);
initial begin
{clk_tb,rst_tb, sin_tb, load_tb, shift_tb, mod_tb} = 0;
    pin_tb = 4'b0000;
end
always #5 clk_tb=~clk_tb;
initial begin
 rst_tb = 1; #10;
 rst_tb = 0;
 $display("Reset done pout=%b", pout_tb);
  pin_tb = 4'b1011; load_tb = 1; #10;
  load_tb = 0;
  $display("Loaded 1011  pout=%b", pout_tb);
  shift_tb=1; mod_tb=0; sin_tb=1; #10;
  $display("Right shift  sin=1  pout=%b  sout=%b", pout_tb, sout_tb);
  #10;
  $display("Right shift  sin=1  pout=%b  sout=%b", pout_tb, sout_tb);
  shift_tb = 0;
  pin_tb = 4'b1010; load_tb = 1; #10;
  load_tb = 0;
  $display("Loaded 1010  pout=%b", pout_tb);
  shift_tb=1; mod_tb=1; sin_tb=0; #10;
  $display("Left shift  sin=0  pout=%b  sout=%b", pout_tb, sout_tb);
  #10;
  $display("Left shift  sin=0  pout=%b  sout=%b", pout_tb, sout_tb);
  shift_tb = 0;

