interface fifo_if;
  logic clk, rst, wren, rden;
  logic [7:0] datain;
  logic full, empty;
  logic [7:0] dataout;
endinterface

module fifo_tb;

  fifo_if fif();

  fifo dut(
    .clk(fif.clk),
    .rst(fif.rst),
    .wren(fif.wren),
    .rden(fif.rden),
    .datain(fif.datain),
    .full(fif.full),
    .empty(fif.empty),
    .dataout(fif.dataout)
  );

  always #5 fif.clk = ~fif.clk;

  initial begin
    fif.clk=0; fif.rst=1; fif.wren=0; fif.rden=0; fif.datain=0;
    #10; fif.rst=0;

    fif.wren=1; fif.datain=8'd10; #10;
    fif.datain=8'd20; #10;
    fif.datain=8'd30; #10;
    fif.wren=0;

    fif.rden=1; #10;
    $display("dataout=%0d", fif.dataout);
    #10;
    $display("dataout=%0d", fif.dataout);
    fif.rden=0;

    fif.wren=1; fif.datain=8'd40; #10; fif.wren=0;

    fif.rden=1; #10;
    $display("dataout=%0d", fif.dataout);
    fif.rden=0;

    $display("empty=%0b full=%0b", fif.empty, fif.full);
    $finish;
  end

endmodule
