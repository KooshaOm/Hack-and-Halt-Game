// ===========================================================================
//      Implementations of Ability Modules Used by Computer Character
// ===========================================================================


// When button is pressed, disable the button, start counting from 7 on HEX, and at the end enable the ability
// and allow the button to be used again 
module GateCoolDown(input enableDC, input triggerButton, input clk, output wire ability, output wire [6:0] hexCounterWire);
    //output wire [3:0] coolDown
    reg takeInput = 1'b1;
    reg [3:0] counter = 4'b0000;
    wire [6:0] HEXInterpretedOutput;
    reg isMoveAvailable = 1'b1;

    // always check for inputs
    always @ (posedge clk) begin
        // make sure cycle is completed before taking any more inputs
        if (counter == 4'b0000) begin
            
            isMoveAvailable <= 1'b1;
            takeInput <= 1'b1;

            if (triggerButton) begin
                if (takeInput) begin
                    counter <= 4'b0111;
                    isMoveAvailable <= 1'b0;
                    takeInput <= 1'b0;
                end
            end
        end
        else begin
            if (enableDC) begin
                if (counter > 4'b0000) begin
                    counter <= counter - 1'b1;
                end
                // else begin
                //     takeInput <= 1'b1;
                // end
            end
        end
    end


    // Decode the counter binary value to a number in decimal
    HEX_Decoder U0 (.c(counter), .s(HEXInterpretedOutput));

    //Connect to HEX3
    assign ability = isMoveAvailable;
    assign hexCounterWire = (counter) ? HEXInterpretedOutput : 7'b1111111;
endmodule 

// When button is pressed, disable the button, start counting from 30 on HEX, and at the end enable the ability
// and allow the button to be used again 
module BlackOutCoolDown(input enableDC, input triggerButton, input clk, output wire ability, output wire [6:0] hexCounterWireTens, output wire [6:0] hexCounterWireOnes);
    //output wire [3:0] coolDown
    reg takeInput = 1'b1;
    reg [4:0] counter = 5'b00000;
    wire [6:0] HEXInterpretedOutputTens;
    wire [6:0] HEXInterpretedOutputOnes;
    wire [3:0] counterTens;
    wire [3:0] counterOnes;
    reg isMoveAvailable = 1'b1;

    // always check for inputs
    always @ (posedge clk) begin
        // make sure cycle is completed before taking any more inputs
        if (counter == 5'b00000) begin
            
            isMoveAvailable <= 1'b1;
            takeInput <= 1'b1;

            if (triggerButton) begin
                if (takeInput) begin
                    counter <= 5'b11110;
                    isMoveAvailable <= 1'b0;
                    takeInput <= 1'b0;
                end
            end
        end
        else begin
            if (enableDC) begin
                if (counter > 5'b00000) begin
                    counter <= counter - 1'b1;
                end
            end
        end
    end

    assign ability = isMoveAvailable;
    assign counterTens = (counter / 10) % 10;
    assign counterOnes = counter % 10;
    
    // Decode the counter binary value to a number in decimal for both the ones and tens place
    HEX_Decoder U0 (.c(counterOnes), .s(HEXInterpretedOutputOnes));
    HEX_Decoder U1 (.c(counterTens), .s(HEXInterpretedOutputTens));
    
    // Connect to HEX1 and HEX2
    assign hexCounterWireOnes = (counter) ? HEXInterpretedOutputOnes : 7'b1111111;
    assign hexCounterWireTens = (counter) ? HEXInterpretedOutputTens : 7'b1111111;
endmodule 

// When button next button is pressed, shift to another gate. When back button is pressed, shift to previous gate. 
module SelectGate(input enableDC, input nextButton, input backButton, input clk, input canBuild, output [3:0] indicatorLoc);
    // For 12 gates
    reg [3:0] gateCounter = 4'b0000;

    always @ (posedge clk) begin
        
        if(enableDC == 1'b1) begin
            if (canBuild == 1'b1) begin 
				 // loop around if we reach last possible gate on the map
				if(gateCounter == 4'b1001) begin
					if(nextButton == 1'b1) begin
						gateCounter <= 4'b0000;
					end
					if(backButton == 1'b1) begin
						gateCounter <= gateCounter - 1'b1;
					end
				end
				else if(gateCounter == 4'b0000) begin
					if(backButton == 1'b1) begin
						gateCounter <= 4'b1001;
					end
					if(nextButton == 1'b1) begin
						gateCounter <= gateCounter + 1'b1; 
					end
				end
				else begin
					if(nextButton == 1'b1) begin
						gateCounter <= gateCounter + 1'b1;
					end
					if(backButton == 1'b1) begin
						gateCounter <= gateCounter - 1'b1;
					end
				end
			end 
        end
    end
    assign indicatorLoc = gateCounter;
endmodule