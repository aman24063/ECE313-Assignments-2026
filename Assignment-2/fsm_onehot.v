`timescale 1ns/1ps
//============================================================
// VDF Assignment-2, Q2(f)
// Same FSM as fsm_gray.v, but ONE-HOT encoded (5 bits)
//   S1 = 00001, S2 = 00010, S3 = 00100, S4 = 01000, S5 = 10000
//
// NOTE: the (* fsm_encoding = "none" *) attribute stops Yosys'
// 'fsm' pass from re-encoding this register back to binary.
// Without it Yosys recognises the FSM and picks its own encoding,
// so both files would synthesise to (nearly) the same netlist and
// the comparison asked for in (f) would be meaningless.
//============================================================

module fsm_onehot (
    input  wire       clk,
    input  wire       rst,   // synchronous, active high -> S1
    input  wire [1:0] in,
    output reg  [1:0] out
);

    // ---------------- one-hot state codes ----------------
    localparam [4:0] S1 = 5'b00001,
                     S2 = 5'b00010,
                     S3 = 5'b00100,
                     S4 = 5'b01000,
                     S5 = 5'b10000;

    (* fsm_encoding = "none" *) reg [4:0] cur_state;
    reg [4:0] next_state;

    // ---------------- state register ----------------
    always @(posedge clk) begin
        if (rst)
            cur_state <= S1;
        else
            cur_state <= next_state;
    end

    // ---------------- next state + output logic ----------------
    always @(*) begin
        next_state = S1;
        out        = 2'b00;

        case (cur_state)

            S1: case (in)
                    2'b00: begin next_state = S1; out = 2'b01; end
                    2'b01: begin next_state = S1; out = 2'b00; end
                    2'b10: begin next_state = S2; out = 2'b01; end
                    2'b11: begin next_state = S3; out = 2'b00; end
                endcase

            S2: case (in)
                    2'b00: begin next_state = S1; out = 2'b11; end
                    2'b01: begin next_state = S3; out = 2'b11; end
                    2'b10: begin next_state = S2; out = 2'b10; end
                    2'b11: begin next_state = S4; out = 2'b10; end
                endcase

            S3: case (in)
                    2'b00: begin next_state = S1; out = 2'b00; end
                    2'b01: begin next_state = S5; out = 2'b01; end
                    2'b10: begin next_state = S3; out = 2'b10; end
                    2'b11: begin next_state = S4; out = 2'b00; end
                endcase

            S4: case (in)
                    2'b00: begin next_state = S3; out = 2'b11; end
                    2'b01: begin next_state = S5; out = 2'b01; end
                    2'b10: begin next_state = S5; out = 2'b01; end
                    2'b11: begin next_state = S4; out = 2'b11; end
                endcase

            S5: case (in)
                    2'b00: begin next_state = S5; out = 2'b00; end
                    2'b01: begin next_state = S1; out = 2'b00; end
                    2'b10: begin next_state = S3; out = 2'b00; end
                    2'b11: begin next_state = S5; out = 2'b11; end
                endcase

            default: begin next_state = S1; out = 2'b00; end

        endcase
    end

endmodule
