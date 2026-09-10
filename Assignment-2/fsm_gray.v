`timescale 1ns/1ps
//============================================================
// VDF Assignment-2, Q2(a)
// Mealy FSM, 5 states, 2-bit input, 2-bit output
// State encoding : GRAY  (3 bits)
//   S1 = 000, S2 = 001, S3 = 011, S4 = 010, S5 = 110
//   consecutive codes differ in exactly one bit
//============================================================

module fsm_gray (
    input  wire       clk,
    input  wire       rst,   // synchronous, active high -> S1
    input  wire [1:0] in,
    output reg  [1:0] out
);

    // ---------------- gray state codes ----------------
    localparam [2:0] S1 = 3'b000,
                     S2 = 3'b001,
                     S3 = 3'b011,
                     S4 = 3'b010,
                     S5 = 3'b110;

    (* fsm_encoding = "none" *) reg [2:0] cur_state;
    reg [2:0] next_state;

    // ---------------- state register ----------------
    always @(posedge clk) begin
        if (rst)
            cur_state <= S1;
        else
            cur_state <= next_state;
    end

    // ---------------- next state + output logic ----------------
    // Mealy: output is a function of (cur_state, in)
    always @(*) begin
        // safe defaults (avoid latches / unknown propagation)
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

            // unused gray codes 100, 101, 111 -> recover to S1
            default: begin next_state = S1; out = 2'b00; end

        endcase
    end

endmodule
