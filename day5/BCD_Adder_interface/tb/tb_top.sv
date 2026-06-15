interface bcd_if;
  logic [3:0] A, B;
  logic C;
  logic [3:0] sum;
  logic cout;
endinterface

module bcd_tb_interface;

  bcd_if bif();

  bcd dut (
    .A(bif.A),
    .B(bif.B),
    .C(bif.C),
    .sum(bif.sum),
    .cout(bif.cout)
  );

  task apply_test(input [3:0] a, b, input c);
    bif.A = a;
    bif.B = b;
    bif.C = c;
    #10;
    $display("A=%0d B=%0d Cin=%0b Sum=%0d Cout=%0b", bif.A, bif.B, bif.C, bif.sum, bif.cout);
  endtask

  initial begin
    apply_test(4'd0, 4'd0, 0);
    apply_test(4'd3, 4'd4, 0);
    apply_test(4'd5, 4'd4, 0);
    apply_test(4'd5, 4'd5, 0);
    apply_test(4'd7, 4'd6, 0);
    apply_test(4'd9, 4'd9, 0);
    apply_test(4'd4, 4'd4, 1);
    apply_test(4'd5, 4'd5, 1);
    apply_test(4'd9, 4'd9, 1);
    $finish;
  end

endmodule
