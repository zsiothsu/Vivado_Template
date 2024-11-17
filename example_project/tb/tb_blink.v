`timescale  1ns/1ns

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

    `ifdef __IVERILOG__
    initial begin
        $dumpfile("tb_blink.vcd");        //生成的vcd文件名称
        $dumpvars(0, tb_blink);    //tb模块名称
    end 
    `endif

    `ifdef __VCS__
    initial begin
        $fsdbDumpfile("tb_blink.fsdb");
        $fsdbDumpvars("+all");
    end
    `endif

endmodule
