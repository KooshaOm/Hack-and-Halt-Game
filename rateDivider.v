// ======================================================================================
//      Module Implementation of Rate Divider Used by Different Aspects of Game Logic 
// ======================================================================================


module RateDivider (input wire clk, output reg enable);
  parameter SPEED = 1;
  reg [26:0] counter;  // 27-bit counter to achieve a 50 MHz clock divide     

  // Increment the counter on each positive edge of the clock
  always @(posedge clk) begin
    if (counter == 50000000 / SPEED) begin  // 50 MHz, so 1 second is 25,000,000 clock cycles
      counter <= 0;                 // Reset the counter
      enable <= 1'b1;//~enable;            // Toggle the enable signal every 1 second
    end else begin
      enable <= 1'b0;
		counter <= counter + 1;       // Increment the counter
    end
  end

endmodule