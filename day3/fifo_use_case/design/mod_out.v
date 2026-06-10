module mod_out(
    input clk,
    input rst,
    input [7:0] din,
    input fifo_empty,
    output reg [7:0] dout,
    output reg valid_out,
    output reg rden
);

reg [1:0] state;

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        state <= S0;
        dout <= 0;
        valid_out <= 0;
        rden <= 0;
    end
    else begin
        valid_out <= 0;

        if(!fifo_empty) begin
            rden <= 1;

            case(state)

                S0: begin
                    state <= S1;
                end

                S1: begin
                    state <= S2;
                end

                S2: begin
                    dout <= din;
                    valid_out <= 1;
                    state <= S0;
                end

            endcase
        end
        else begin
            rden <= 0;
        end
    end
end

endmodule
