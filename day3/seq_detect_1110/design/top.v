module seq_detect1110(input clk,rst,din,
output reg detected);
parameter idle=2'b00;
parameter s1=2'b01;
parameter s2=2'b10;
parameter s3=2'b11;
reg [1:0]ps,ns;

//present state logic
always@(posedge clk)begin
if (rst)
ps<=idle;
else
ps<=ns;
end

//next state logic
always@(*)begin
case(ps)
idle:begin
 detected=0;
 if (din)
  ns=s1;
 else 
  ns=idle;
end
s1:begin
 detected=0;
 if (din)
  ns=s2;
 else
  ns=idle;
 end
s2:begin
 detected=0;
 if (din)
  ns=s3;
 else
  ns=idle;
 end
s3:begin
 if (din)begin
  detected=0;
  ns=s3;
  end
 else begin
  detected=1;
  ns=idle;
  end
 end
default:begin
 detected=0;
 ns=idle;
 end
 endcase
end
