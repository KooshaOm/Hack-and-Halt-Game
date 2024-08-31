// ===========================================================================
//      Module Implementation of Keyboard Driver Used by Human Character
// ===========================================================================

module Keyboard(
    input CLOCK_50, // FPGA 50 MHz board clock
    input PS2_DAT, // PS2 keyboard clock
    input PS2_CLK, // PS2 keyboard data (1 bit out of 11)
    output up,
	output down,
	output left, 
	output right);
	
    localparam  
        W = 8'h1D, 
        A = 8'h1C,
        S = 8'h1B,
        D = 8'h23;

    // Initialize all regs used by module
    reg isReading = 1'b0;  // indicate if the board is actively reading data
    reg done = 1'b0; // indicates when reading process is done
    reg enable = 1'b0; // allows for data control
    reg errorFlag = 1'b0; // indicates if errors occured while reading data from PS2 keyboard
    reg KB_PreviousState = 1'b1; // keeps track of previous clock value of PS2 keyboard
    reg [3:0] numBitsReadSoFar = 1'd0; // keeps track of number of bits received by PS2 keyboard
    reg [7:0] KeyPressed = 1'd0; // store the data relating to which key was pressed 
    reg [7:0] upCounter = 1'd0; // used by rate divider
    reg [10:0] bitDataReceived = 1'd0; // stores all 11 bits sent by PS2 keyboard
    reg upReg = 1'b0, downReg  = 1'b0, leftReg  = 1'b0, rightReg = 1'b0;
	reg [7:0] prevKeyPressed = 1'd0;
	reg [2:0] resetKeyboard = 1'd0;
	 
	// Rate divider to reduce board frequency
    always @ (posedge CLOCK_50)
    begin
        if(upCounter < 249)
            begin
                upCounter <= upCounter + 1'b1;  
                enable <= 1'b0; 
            end
        else
            begin
                upCounter <= 1'd0; 
                enable <= 1'b1; 
            end

        // once pulsed by the rate dividor
        if(enable)
            begin
                if(KB_PreviousState != PS2_CLK)
                    begin
                        if(PS2_CLK != 1'b1)
                            begin
                                // PS2 keyboard's clock value changed from 1 to zero (negative edge of keyboard's clock detected)
                                bitDataReceived[0] <= PS2_DAT;
                                bitDataReceived[10:1] <= bitDataReceived[9:0];
                                isReading <= 1'b1; // enter reading state
                                numBitsReadSoFar <= numBitsReadSoFar + 1'b1;
                                errorFlag <= 1'b0;
                            end
                    end
                else if (numBitsReadSoFar == 4'b1011)
                    begin
                        numBitsReadSoFar <= 1'b0;
                        isReading <= 1'b0;
                        done <= 1'b1;
                        
                        // check for errors by inspecting the bits received
                        errorFlag <= ((~^bitDataReceived[9:1]) || bitDataReceived[0] || !bitDataReceived[10])
                    end
            KB_PreviousState <= PS2_CLK;
            end

            /*
            The validity checking logic used above:
            1 start bit.  This is always 0.
            8 data bits, least significant bit first.
            1 parity bit (odd parity).
            1 stop bit.  This is always 1
            */

        if((enable == 1'b1) && (done == 1'b1))
            begin
                        
                if(errorFlag == 1'b0)
                    begin
                        KeyPressed <= bitDataReceived[8:1];
                        if(bitDataReceived[8:1] == W)
                        begin
                            prevKeyPressed <= W;	
                            upReg <= 1'b1;
                            
                            leftReg <= 1'b0;
                            rightReg <= 1'b0;
                            downReg <= 1'b0;
                        end
                        else if (bitDataReceived[8:1] == A) begin 
                            prevKeyPressed <= A;
                            leftReg = 1'b1;
                            
                            upReg <= 1'b0;
                            rightReg <= 1'b0;
                            downReg <= 1'b0;
                        end 
                        else if (bitDataReceived[8:1] == S) begin 
                            prevKeyPressed <= S;
                            downReg <= 1'b1;
                            
                            upReg <= 1'b0;
                            rightReg <= 1'b0;
                            leftReg <= 1'b0;
                        end 
                        else if (bitDataReceived[8:1] == D) begin
                            prevKeyPressed <= D;
                            rightReg <= 1'b1;
                            
                            upReg <= 1'b0;
                            leftReg <= 1'b0;
                            downReg <= 1'b0;
                        end
                        
                    end
                else
                    begin
                        KeyPressed <= 8'b0;
                    end
            end
        else
            begin
                KeyPressed <= 8'b0;
            end
    end

	assign up = upReg;
	assign down = downReg;
	assign left = leftReg;
	assign right = rightReg;
    // check if inputs are consistent with keys pressed
endmodule

