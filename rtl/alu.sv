module alu #(
  parameter int BW = 16 // bitwidth
  ) (
  input  logic signed [BW-1:0] in_a,
  input  logic signed [BW-1:0] in_b,
  input  logic        [2:0] opcode,
  output logic signed [BW-1:0] out,
  output logic        [2:0] flags // {overflow, negative, zero}
  );

  always_comb begin
    out = '0;

    case (opcode)
      3'b000: out = in_a + in_b;          // ADD
      3'b001: out = in_a - in_b;          // SUB
      3'b010: out = in_a & in_b;          // AND
      3'b011: out = in_a | in_b;          // OR
      3'b100: out = in_a ^ in_b;          // XOR
      3'b101: out = in_a + 1'b1;          // INC
      3'b110: out = in_a;                 // MOVA
      3'b111: out = in_b;                 // MOVB
      default: out = '0;
    endcase
  end

  always_comb begin
    logic ovf;
    ovf = 1'b0;

    case (opcode)
      3'b000: // ADD ovf
        ovf = ~(in_a[BW-1] ^ in_b[BW-1]) & (in_a[BW-1] ^ out[BW-1]);
      3'b001: // SUB ovf
        ovf = (in_a[BW-1] ^ in_b[BW-1]) & (in_a[BW-1] ^ out[BW-1]);
      3'b101: // INC ovf
        ovf = ~in_a[BW-1] & out[BW-1];
      default: 
        ovf = 1'b0;
    endcase

    flags = {ovf, out[BW-1], ~|out}; // {overflow, negative, zero}
  end

endmodule
