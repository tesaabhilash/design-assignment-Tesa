module face_mod(
    input clk,
    input rst,
    input sin,
    input [3:0] key,
    output reg sout
);

always @(posedge clk) begin
    if(rst)
        sout <= 0;
    else
        sout <= sin;
end

endmodule
