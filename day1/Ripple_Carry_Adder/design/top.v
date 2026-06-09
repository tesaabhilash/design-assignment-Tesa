module ripplecarry(input [3:0]A,[3:0]B,
input C,
output [3:0]sum,
output cout);
wire w1,w2,w3;
fulladd FA0(.A_FA(A[0]),.B_FA(B[0]),.C_FA(C),.sum_FA(sum[0]),.carry_FA(w1));
fulladd FA1(.A_FA(A[1]),.B_FA(B[1]),.C_FA(w1),.sum_FA(sum[1]),.carry_FA(w2));
fulladd FA2(.A_FA(A[2]),.B_FA(B[2]),.C_FA(w2),.sum_FA(sum[2]),.carry_FA(w3));
fulladd FA3(.A_FA(A[3]),.B_FA(B[3]),.C_FA(w3),.sum_FA(sum[3]),.carry_FA(cout));
endmodule
