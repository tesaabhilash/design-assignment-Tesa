module fifo(
    input clk,
    input rst,
    input wren,
    input rden,
    input [7:0] datain,
    output full,
    output empty,
    output reg [7:0] dataout
);

reg [7:0] mem[7:0];
reg [2:0] wr_ptr, rd_ptr;
integer i;

assign full  = ((wr_ptr + 3'b001) == rd_ptr);
assign empty = (wr_ptr == rd_ptr);

always @(posedge clk or posedge rst) begin
    if(rst) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        dataout <= 0;
        for(i=0;i<8;i=i+1)
            mem[i] <= 0;
    end
    else begin
        if(wren && !full) begin
            mem[wr_ptr] <= datain;
            wr_ptr <= wr_ptr + 1;
        end
        else if(rden && !empty) begin
            dataout <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end
end

endmodule
