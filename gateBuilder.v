// ===========================================================================
//    Implementations of Gating Ability Module Used by Computer Character
// ===========================================================================

module gateBuilder(enable,iColour,vertical,x,y,iClock,outX,outY,Colour,done);
   parameter LENGTH = 15;

   input wire enable, vertical, iClock;
   input wire [2:0] iColour;
   input wire [10:0] x;
   input wire [10:0] y;
   output wire [10:0] outX;         // VGA pixel coordinates
   output wire [10:0] outY;
   output wire done;
   output wire [2:0] Colour;     // VGA pixel colour (0-7)


   reg [10:0] xOG, yOG;
   reg [10:0] counter = 10'b0000000000;
   reg stopIteration = 1'b0;
	
   always@ (posedge iClock) begin
		if (enable) begin
			
         if(!counter) begin
            xOG = x;
			yOG = y;
            counter <= counter + 1'b1;
         end
         else if (counter == LENGTH) begin
            stopIteration <= 1'b1;
         end
         else if (counter < LENGTH) begin

            if(!stopIteration) begin
               if(vertical) begin
                  yOG <= yOG + 1'b1;
               end
               else begin
                  xOG <= xOG + 1'b1;
               end
               counter <= counter + 1'b1;
            end
         end
		end
		else begin
			counter <= 1'b0;
			stopIteration <= 1'b0; // EMPH
		end
   end

   assign outX[10:0] = xOG[10:0]; // start at the leftmost x-value, increment all the way to (x + 4)
   assign outY[10:0] = yOG[10:0]; // start at the top, wait for one cycle of x-values, go to the row below
   assign Colour[2:0] = iColour[2:0];
   assign done = stopIteration;
endmodule 