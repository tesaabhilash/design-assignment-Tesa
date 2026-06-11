module block_mem_gen_tb();
reg clk_tb,arstn_tb,wrenb_tb;
reg [7:0]din_tb,wraddress_tb,rdaddress_tb;
wire [7:0]dout_tb;
 block_mem_gen dut(.clk(clk_tb),.arstn(arstn_tb),.wrenb(wrenb_tb),.din(din_tb),.wraddress(wraddress_tb),.rdaddress(rdaddress_tb),.dout(dout_tb));
 initial begin
 {clk_tb,arstn_tb,wrenb_tb,din_tb}=0;
 end
 always #5 clk_tb=~clk_tb;
 initial begin
 arstn_tb = 0;#15;
 arstn_tb = 1;#10;
 
 wrenb_tb = 1; wraddress_tb = 8'h01; din_tb = 8'hAB;
 #10;
 wraddress_tb = 8'h02; din_tb = 8'hCD;
 #10;
 wraddress_tb = 8'h03; din_tb = 8'hEF;
 #10;
 wrenb_tb = 0; rdaddress_tb = 8'h01;
 #10;
 $display("Read addr 01: %h (expect AB)", dout_tb);
 rdaddress_tb = 8'h02;
 #10;
 $display("Read addr 02: %h (expect CD)", dout_tb);
 rdaddress_tb = 8'h03;
 #10;
 $display("Read addr 03: %h (expect EF)", dout_tb);
 wrenb_tb = 1; wraddress_tb = 8'h04; din_tb = 8'h55;
 #5;
 arstn_tb = 0;  
 #10;
 arstn_tb = 1;
 wrenb_tb = 0; rdaddress_tb = 8'h04;
 #10;
 $display("Read addr 04 after reset: %h (expect 00)", dout_tb);
 #20;
 end
endmodule
