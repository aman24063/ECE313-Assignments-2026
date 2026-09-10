//============================================================
// VDF Assignment-2, Q2(d)
// Stimulus-only testbench used for COVERED line-coverage scoring.
//
// It applies exactly the same 24-vector directed walk as tb_fsm.v
// (all 20 arcs of the state diagram), plus the reset sequence, but
// contains no functions and no tasks, because the Covered 2009
// parser cannot handle the self-checking reference model used in
// tb_fsm.v. Since line coverage is measured on fsm_gray.v and the
// stimulus is identical, the coverage figures are unaffected.
//
//   iverilog -Wall -o test_cov fsm_gray.v tb_cov.v
//   vvp test_cov
//   covered score -t tb_cov -v tb_cov.v -v fsm_gray.v -vcd fsm_cov.vcd -o fsm.cdd
//   covered report -d v fsm.cdd
//============================================================

`timescale 1ns/1ps

module tb_cov;

    reg        clk = 1'b0;
    reg        rst;
    reg  [1:0] in;
    wire [1:0] out;

    fsm_gray dut (.clk(clk), .rst(rst), .in(in), .out(out));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("fsm_cov.vcd");
        $dumpvars(0, tb_cov);

        // ---- reset into S1 ----
        rst = 1'b1;
        in  = 2'b00;
        @(posedge clk);
        @(posedge clk);
        #1 rst = 1'b0;

        // ---- directed walk covering all 20 arcs ----
        @(negedge clk); in = 2'b00;   // S1 / 00 -> S1
        @(negedge clk); in = 2'b01;   // S1 / 01 -> S1
        @(negedge clk); in = 2'b10;   // S1 / 10 -> S2
        @(negedge clk); in = 2'b10;   // S2 / 10 -> S2
        @(negedge clk); in = 2'b00;   // S2 / 00 -> S1
        @(negedge clk); in = 2'b10;   // S1 / 10 -> S2
        @(negedge clk); in = 2'b01;   // S2 / 01 -> S3
        @(negedge clk); in = 2'b10;   // S3 / 10 -> S3
        @(negedge clk); in = 2'b00;   // S3 / 00 -> S1
        @(negedge clk); in = 2'b11;   // S1 / 11 -> S3
        @(negedge clk); in = 2'b11;   // S3 / 11 -> S4
        @(negedge clk); in = 2'b11;   // S4 / 11 -> S4
        @(negedge clk); in = 2'b00;   // S4 / 00 -> S3
        @(negedge clk); in = 2'b01;   // S3 / 01 -> S5
        @(negedge clk); in = 2'b00;   // S5 / 00 -> S5
        @(negedge clk); in = 2'b11;   // S5 / 11 -> S5
        @(negedge clk); in = 2'b10;   // S5 / 10 -> S3
        @(negedge clk); in = 2'b11;   // S3 / 11 -> S4
        @(negedge clk); in = 2'b10;   // S4 / 10 -> S5
        @(negedge clk); in = 2'b01;   // S5 / 01 -> S1
        @(negedge clk); in = 2'b10;   // S1 / 10 -> S2
        @(negedge clk); in = 2'b11;   // S2 / 11 -> S4
        @(negedge clk); in = 2'b01;   // S4 / 01 -> S5
        @(negedge clk); in = 2'b01;   // S5 / 01 -> S1

        // ---- reset applied from a non-initial state ----
        @(negedge clk); in = 2'b11;
        @(negedge clk); rst = 1'b1;
        @(posedge clk); #1 rst = 1'b0;
        @(negedge clk); in = 2'b10;

        @(negedge clk);
        #20 $display("Coverage stimulus complete.");
        $finish;
    end

endmodule
