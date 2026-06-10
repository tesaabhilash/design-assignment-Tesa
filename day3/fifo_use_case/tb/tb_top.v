module top_tb();

    reg clk;
    reg rst;
    reg sin;
    reg [3:0] key;

    reg [7:0] data;
    integer i;

    wire [7:0] dout;
    wire valid_out;

    top dut(
        .clk(clk),
        .rst(rst),
        .sin(sin),
        .key(key),
        .dout(dout),
        .valid_out(valid_out)
    );

    initial begin
        clk = 0;
    end

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if(valid_out)
            $display("OUTPUT = %b at time %0t", dout, $time);
    end

    initial begin

        rst = 1;
        sin = 0;
        key = 4'b1011;

        #20;
        rst = 0;

        // Byte 1 : 10101010
        data = 8'b10101010;
        for(i=7; i>=0; i=i-1) begin
            sin = data[i];
            #10;
        end

        // Byte 2 : 11001100
        data = 8'b11001100;
        for(i=7; i>=0; i=i-1) begin
            sin = data[i];
            #10;
        end

        // Byte 3 : 11110000
        data = 8'b11110000;
        for(i=7; i>=0; i=i-1) begin
            sin = data[i];
            #10;
        end

        #50;

        // Byte 4 : 00001111
        data = 8'b00001111;
        for(i=7; i>=0; i=i-1) begin
            sin = data[i];
            #10;
        end

        // Byte 5 : 01010101
        data = 8'b01010101;
        for(i=7; i>=0; i=i-1) begin
            sin = data[i];
            #10;
        end

           // Byte 6 : 00110011
    data = 8'b00110011;
    for(i=7; i>=0; i=i-1) begin
        sin = data[i];
        #10;
    end

    sin = 0;

    #20;
    end

endmodule
