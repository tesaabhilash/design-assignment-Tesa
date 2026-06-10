module sipo8(
    input clk,
    input rst,
    input s,
    output reg [7:0] p,
    output reg ready
);

reg [2:0] count;

always @(posedge clk or posedge rst)
begin
    if(rst) begin
        p <= 8'b00000000;
        count <= 3'b000;
        ready <= 1'b0;
    end
    else begin
        p <= {p[6:0], s};
        ready <= 1'b0;

        if(count == 3'd7) begin
            count <= 3'd0;
            ready <= 1'b1;
        end
        else begin
            count <= count + 1'b1;
        end
    end
end

endmodule
