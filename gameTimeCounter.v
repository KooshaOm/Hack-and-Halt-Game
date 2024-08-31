// ===========================================================================
//          Module Implementation to Display Time on HEX Displays
// ===========================================================================

module gameTimeCounter(
  input masterEnable,
  input enableDC,
  input reset,
  input Clock,
  output wire [6:0] hex3,
  output wire [6:0] hex4,
  output wire [6:0] hex5
);
  reg [6:0] curTime = 7'b1111000;
  wire [3:0] hundreds;
  wire [3:0] tens;
  wire [3:0] ones;

  always @(posedge Clock) begin
    if (reset == 1'b0) begin
      curTime <= 7'b1111000;
    end else begin
      if (enableDC) begin
        if (masterEnable) begin
          if (curTime > 1'b0) begin
            curTime <= curTime - 1'b1;
          end
        end
      end
    end
  end

  assign hundreds = (curTime / 100) % 10;
  assign tens = (curTime / 10) % 10;
  assign ones = curTime % 10;
  
  hex_decoder U2 (hundreds[3:0], hex5);
  hex_decoder U1 (tens[3:0], hex4);
  hex_decoder U0 (ones[3:0], hex3);

endmodule
