`timescale  1ns/1ns

`include "common.vh"

module blink
#(
    parameter               CLK_FREQ    =   50000000
) (
    input   wire            sys_clk,
    input   wire            sys_rst_n,
    output  reg     [3:0]   led_out
);
    reg     [31:0]  cnt;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (~sys_rst_n) begin
            cnt <= 0;
        end else begin
            if (cnt == CLK_FREQ - 1)
                cnt <= 0;
            else 
                cnt <= cnt + 1;
        end
    end

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (~sys_rst_n) begin
            led_out <= 0;
        end else begin
            if (cnt == CLK_FREQ - 1)
                led_out <= led_out + `ADD_NUM;
        end
    end

endmodule
