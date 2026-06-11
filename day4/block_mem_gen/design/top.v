module block_mem_gen(input clk,arstn,wrenb,
input [7:0]din,wraddress,rdaddress,
output reg [7:0]dout);
reg [7:0] mem [0:255];  // 256 locations, each 8 bits wide
integer i;

always@(posedge clk or negedge arstn)begin

if (arstn) begin
 if(wrenb)begin
  mem[wraddress]<=din;
 end
 else begin
  dout<=mem[rdaddress];
 end
 end
 else begin
 for(i=0;i<256;i=i+1)
    mem[i]<=0;
end
end
endmodule
