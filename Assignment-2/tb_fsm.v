//============================================================
// VDF Assignment-2, Q2(b)
// Self-checking testbench for the 5-state Mealy FSM.
//
// The stimulus is a directed walk that exercises ALL 20 arcs
// of the state diagram (5 states x 4 input combinations), plus
// the reset behaviour. A golden reference model (written from
// the state diagram, independent of the DUT's encoding) predicts
// the output every cycle and any mismatch is reported.
//
// Compile (gray version)   : iverilog -Wall -o test fsm_gray.v tb_fsm.v
// Compile (one-hot version): iverilog -Wall -DONEHOT -o test fsm_onehot.v tb_fsm.v
// Run                      : vvp test
// View                     : gtkwave fsm.vcd
//============================================================

`timescale 1ns/1ps

module tb_fsm;

    reg        clk = 1'b0;
    reg        rst;
    reg  [1:0] in;
    wire [1:0] out;

    integer errors = 0;
    integer i;

    // ---------------- DUT ----------------
`ifdef ONEHOT
    fsm_onehot dut (.clk(clk), .rst(rst), .in(in), .out(out));
`else
    fsm_gray   dut (.clk(clk), .rst(rst), .in(in), .out(out));
`endif

    // ---------------- clock : 10 ns period ----------------
    always #5 clk = ~clk;

    // ---------------- golden reference model ----------------
    // states numbered 1..5, encoding-independent
    integer ref_state;

    // returns {next_state[2:0], expected_out[1:0]}
    function [4:0] model;
        input integer s;
        input [1:0]   stim;
        begin
            model = 5'b0;
            case (s)
            1: case (stim)
                 2'b00: model = {3'd1, 2'b01};
                 2'b01: model = {3'd1, 2'b00};
                 2'b10: model = {3'd2, 2'b01};
                 2'b11: model = {3'd3, 2'b00};
               endcase
            2: case (stim)
                 2'b00: model = {3'd1, 2'b11};
                 2'b01: model = {3'd3, 2'b11};
                 2'b10: model = {3'd2, 2'b10};
                 2'b11: model = {3'd4, 2'b10};
               endcase
            3: case (stim)
                 2'b00: model = {3'd1, 2'b00};
                 2'b01: model = {3'd5, 2'b01};
                 2'b10: model = {3'd3, 2'b10};
                 2'b11: model = {3'd4, 2'b00};
               endcase
            4: case (stim)
                 2'b00: model = {3'd3, 2'b11};
                 2'b01: model = {3'd5, 2'b01};
                 2'b10: model = {3'd5, 2'b01};
                 2'b11: model = {3'd4, 2'b11};
               endcase
            5: case (stim)
                 2'b00: model = {3'd5, 2'b00};
                 2'b01: model = {3'd1, 2'b00};
                 2'b10: model = {3'd3, 2'b00};
                 2'b11: model = {3'd5, 2'b11};
               endcase
            endcase
        end
    endfunction

    // ---------------- one stimulus vector ----------------
    task apply;
        input [1:0] stim;
        reg   [4:0] pred;
        begin
            @(negedge clk);
            in   = stim;
            pred = model(ref_state, stim);
            #1;                             // let combinational output settle
            if (out !== pred[1:0]) begin
                errors = errors + 1;
                $display("[%0t] MISMATCH: S%0d in=%b -> out=%b (expected %b)",
                         $time, ref_state, stim, out, pred[1:0]);
            end else begin
                $display("[%0t] S%0d  in=%b  out=%b  -> S%0d",
                         $time, ref_state, stim, out, pred[4:2]);
            end
            @(posedge clk);
            #1;
            ref_state = pred[4:2];          // reference follows the DUT
        end
    endtask

    // ---------------- directed walk covering all 20 arcs ----------------
    // S1:00 S1:01 S1:10 S2:10 S2:00 (S1:10) S2:01 S3:10 S3:00 S1:11
    // S3:11 S4:11 S4:00 S3:01 S5:00 S5:11 S5:10 (S3:11) S4:10 S5:01
    // (S1:10) S2:11 S4:01 S5:01
    reg [1:0] walk [0:23];
    initial begin
        walk[0]=2'b00; walk[1]=2'b01; walk[2]=2'b10; walk[3]=2'b10;
        walk[4]=2'b00; walk[5]=2'b10; walk[6]=2'b01; walk[7]=2'b10;
        walk[8]=2'b00; walk[9]=2'b11; walk[10]=2'b11; walk[11]=2'b11;
        walk[12]=2'b00; walk[13]=2'b01; walk[14]=2'b00; walk[15]=2'b11;
        walk[16]=2'b10; walk[17]=2'b11; walk[18]=2'b10; walk[19]=2'b01;
        walk[20]=2'b10; walk[21]=2'b11; walk[22]=2'b01; walk[23]=2'b01;
    end

    // ---------------- main stimulus ----------------
    initial begin
        $dumpfile("fsm.vcd");
        $dumpvars(0, tb_fsm);

        // reset
        rst = 1'b1;
        in  = 2'b00;
        ref_state = 1;
        @(posedge clk);
        @(posedge clk);
        #1 rst = 1'b0;
        $display("--- reset released, FSM should be in S1 ---");

        // walk through every arc
        for (i = 0; i < 24; i = i + 1)
            apply(walk[i]);

        // check reset from a non-initial state
        @(negedge clk); in = 2'b11; @(posedge clk);   // move away from S1
        @(negedge clk); rst = 1'b1;
        @(posedge clk); #1 rst = 1'b0;
        ref_state = 1;
        $display("--- synchronous reset re-applied, FSM back in S1 ---");
        apply(2'b10);   // must behave like S1 again

        if (errors == 0)
            $display("\nTEST PASSED : all %0d checks matched the reference model", 25);
        else
            $display("\nTEST FAILED : %0d mismatches", errors);

        #20 $finish;
    end

endmodule
