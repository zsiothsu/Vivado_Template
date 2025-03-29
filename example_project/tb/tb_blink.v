`timescale  1ns/1ps

module  tb_blink();
    wire    [3:0]   led_out     ;
    reg             sys_clk     ;
    reg             sys_rst_n   ;

    initial begin
        sys_clk    = 1'b0;
        sys_rst_n <= 1'b0;
        #20
        sys_rst_n <= 1'b1;
        #10000 $finish;
    end

    always begin
        #10 sys_clk <= ~sys_clk;
    end


    blink #(
        .CLK_FREQ(32'd10)
    ) i_blink (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .led_out(led_out)
    );

endmodule
