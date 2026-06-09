module univ_reg(input clk,rst,sin,shift,load,mod,
input[3:0]pin,
output reg sout,
output reg [3:0]pout );
always@(posedge clk)
begin
if (rst) begin
  sout<=1'b0;
  pout<=4'b0000;
end               
else if (load) begin
pout<=pin;
sout<=1'b0;
end
else if (shift)begin
if(mod)begin
pout<={pin[2:0],sin};
sout<=pout[3];
end
else begin
pout<={sin,pin[2:0]};
sout<=pout[0];
end
end
end
endmodule

