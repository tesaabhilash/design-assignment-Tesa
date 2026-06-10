module top(
    input clk,
    input rst,
    input sin,
    input [3:0] key,
    output [7:0] dout,
    output valid_out
);

wire face_sout;

wire [7:0] fifo_datain;
wire wren;

wire fifo_full;
wire fifo_empty;
wire [7:0] fifo_dataout;

wire rden;

face_mod fm(
    .clk(clk),
    .rst(rst),
    .sin(sin),
    .key(key),
    .sout(face_sout)
);

sipo8 sp(
    .clk(clk),
    .rst(rst),
    .s(face_sout),
    .p(fifo_datain),
    .ready(wren)
);

fifo ff(
    .clk(clk),
    .rst(rst),
    .wren(wren),
    .rden(rden),
    .datain(fifo_datain),
    .full(fifo_full),
    .empty(fifo_empty),
    .dataout(fifo_dataout)
);

mod_out mo(
    .clk(clk),
    .rst(rst),
    .din(fifo_dataout),
    .fifo_empty(fifo_empty),
    .dout(dout),
    .valid_out(valid_out),
    .rden(rden)
);

endmodule
