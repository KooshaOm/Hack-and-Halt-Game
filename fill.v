// Part 2 skeleton

module fill
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		KEY,							// On Board Keys
		SW,
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
		LEDR,
		PS2_DAT,
		PS2_CLK,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;	
	input [9:0] SW;
	input PS2_DAT, PS2_CLK;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 
	output [9:0] LEDR;
	
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	
	wire resetn;
	assign resetn = 1'b0;
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;
	wire [8:0] x;
	wire [8:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(1'b1),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "map.mif";
			
	
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	//part2 u1 (.iResetn(resetn), .iPlotBox(KEY[1]), .iBlack(KEY[2]), .iColour(colour), .iLoadX(KEY[3]), .iXY_Coord(SW[6:0]), .iClock(Clock_50), .oX(x),.oY(y), .oColour(colour), .oPlot(writeEn));
	SCP U1(.iResetn(resetn), 
	.KEYS(KEY), 
	.Switches(SW), 
	.PS2_Clock(PS2_CLK),
	.PS2_Data(PS2_DAT),
	.LEDs(LEDR), 
	.HEX0(HEX0), 
	.HEX1(HEX1), 
	.HEX2(HEX2), 
	.HEX3(HEX3), 
	.HEX4(HEX4), 
	.HEX5(HEX5), 
	.iClock(CLOCK_50), 
	.oX(x),
	.oY(y), 
	.oColour(colour), 
	.oPlot(writeEn)
	);

endmodule

module SCP(
	input wire iResetn,
	input [3:0] KEYS,
	input [9:0] Switches,
	input PS2_Clock, PS2_Data,
	output [9:0] LEDs,
   output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, 
    input wire iClock,
   output wire [8:0] oX,     
   output wire [8:0] oY,

   output wire [2:0] oColour,     
   output wire 	   oPlot
	
	);
	
	localparam 
        W = 8'h1D, 
        A = 8'h1C,
        S = 8'h1B,
        D = 8'h23,
		  LENGTH = 8'd320, 
		  WIDTH = 8'd240;
	
	wire [8:0] testGate1X, testGate1Y, 
	testGate2X, testGate2Y, 
	testGate3X, testGate3Y, 
	testGate4X, testGate4Y, 
	testGate5X, testGate5Y, 
	testGate6X, testGate6Y, 
	testGate7X, testGate7Y,
	testGate8X, testGate8Y, 
	testGate9X, testGate9Y, 
	testGate10X, testGate10Y;
	wire gate1Done, gate2Done, 
	gate3Done, gate4Done, 
	gate5Done, gate6Done,
	gate7Done, gate8Done,
	gate9Done, gate10Done,
	gate1BlackDone, gate2BlackDone; 
	
   wire masterEnable;
	wire playerEnWire;
	wire playerEn; 
   reg masterEnableReg;
	wire [7:0] currentKeyPressed;
	wire [8:0] gateWireX, gateWireY;
	wire [3:0] currentGate;
	wire [7:0] keyOn; 
	reg drawing = 1'b0;
	reg [3:0] prevGate = 1'd0;
	wire up,down,left,right;
	reg gate1En = 1'd0,
	gate2En = 1'd0,
	gate3En = 1'd0,
	gate4En = 1'd0,
	gate5En = 1'd0,
	gate6En = 1'd0,
	gate7En = 1'd0,
	gate8En = 1'd0,
	gate9En = 1'd0,
	gate10En = 1'd0,
	gate1BlackEn = 1'd0,
	gate2BlackEn = 1'd0;
	reg showPin = 1'b0; // **** NEW *****   ( SHOULD BE AN INPUT TO THE UI MODULE THAT FEEDS INTO PINAUTHENTICATION MODULE)
	wire blackedOut; // **** NEW *****   (SHOULD BE AN INPUT TO THE UI MODULE THAT FEEDS INTO BLACKOUT MODULE)
	wire enableOneSecond; // **** NEW *****   (USE RATE DIVIDOR TO GET 1 SECOND PULSES)
	reg blackedOutFlag = 1'b0;
	reg [20:0] frameCounter = 1'b0, speedReg = 21'd75000;
	reg [8:0] playerX = 9'd80, playerY = 9'd170, prevPosX, prevPosY;
	reg [8:0] gateRegX, gateRegY;
	reg [5:0] set = 1'd0;
	reg [5:0] gateCounter = 1'd0;
	reg [2:0] colourReg = 3'b100; 
	reg [3:0] gateBuilt = 4'd13;
	reg [4:0] buildCounter = 5'b0;
	reg[8:0] xScreen = 10'd0;
    reg [8:0] yScreen = 10'd0;
    reg [2:0] colourGate1 = 1'd0;
    reg [2:0] colourGate2 = 1'd0;
    reg [2:0] colourGate3 = 1'd0;
    reg [2:0] colourGate4 = 1'd0;
    reg [2:0] colourGate5 = 1'd0;
    reg [2:0] colourGate6 = 1'd0;
    reg [2:0] colourGate7 = 1'd0;
    reg [2:0] colourGate8 = 1'd0;
    reg [2:0] colourGate9 = 1'd0;
    reg [2:0] colourGate10 = 1'd0;
	reg [2:0] colourPowerUp1 = 1'd0; // **** NEW *****
	reg [2:0] colourPowerUp2 = 1'd0; // **** NEW *****
	reg [2:0] colourPowerUp3 = 1'd0; // **** NEW *****
	reg [2:0] blackOutCounter = 3'b000; // **** NEW *****
	
	reg gateOneClosed = 1'b0; // **** NEW *****
	reg gateTwoClosed = 1'b0; // **** NEW *****
	reg gateThreeClosed = 1'b0; // **** NEW *****
	reg gateFourClosed = 1'b0; // **** NEW *****
	reg gateFiveClosed = 1'b0; // **** NEW *****
	reg gateSixClosed = 1'b0; // **** NEW ***** 
	reg gateSevenClosed = 1'b0; // **** NEW *****
	reg gateEightClosed = 1'b0; // **** NEW *****
	reg gateNineClosed = 1'b0; // **** NEW *****
	reg gateTenClosed = 1'b0; // **** NEW *****
	reg powerUpOneCollected = 1'b0; // **** NEW *****
	reg powerUpTwoCollected = 1'b0; // **** NEW *****
	reg powerUpThreeCollected = 1'b0; // **** NEW *****
	
	wire playerWon; // **** NEW FEEDS INTO z OUTPUT OF PIN AUTHEN. *****
	reg stopTimer = 1'b1; // ***** NEW FEEDS INTO MASTER ENABLE OF GAME COUNTER
	reg screenBlackedOut = 1'b0;	// ***** NEW *****
	reg timeRanOut = 1'b0;
	reg [16:0] addressOfPlayerWinScreen; // ***** NEW *****
	reg [16:0] addressOfComputerWinScreen; // ***** NEW *****
	wire [2:0] colourPlayerWinScreen; // ***** NEW *****
	wire [2:0] colourComputerWinScreen; // ***** NEW *****
	reg [6:0] curTime = 7'b1111000; // ***** NEW USED TO KEEP TRACK OF TIME IN TOP LEVEL


	//dont need the icolour technically
	gateBuilder testGate (.enable(gate1En), .iColour(3'b100), .vertical(1'b0), .x(9'd110), .y(9'd73), .iClock(iClock), .outX(testGate1X), .outY(testGate1Y), .done(gate1Done));
	defparam testGate.LENGTH = 14;
	
	gateBuilder testGate2 (.enable(gate2En), .iColour(3'b100), .vertical(1'b1), .x(9'd124), .y(9'd104), .iClock(iClock), .outX(testGate2X), .outY(testGate2Y), .done(gate2Done));
	defparam testGate2.LENGTH = 7;
	
	gateBuilder testGate3 (.enable(gate3En), .iColour(3'b100), .vertical(1'b1), .x(9'd123), .y(9'd181), .iClock(iClock), .outX(testGate3X), .outY(testGate3Y), .done(gate3Done) );
	defparam testGate3.LENGTH = 6;
	
	gateBuilder testGate4 (.enable(gate4En), .iColour(3'b100), .vertical(1'b0), .x(9'd124), .y(9'd104), .iClock(iClock), .outX(testGate4X), .outY(testGate4Y), .done(gate4Done) );
	defparam testGate4.LENGTH = 10;
	
	gateBuilder testGate5 (.enable(gate5En), .iColour(3'b100), .vertical(1'b0), .x(9'd154), .y(9'd127), .iClock(iClock), .outX(testGate5X), .outY(testGate5Y), .done(gate5Done) );
	defparam testGate5.LENGTH = 13;
	
	gateBuilder testGate6 (.enable(gate6En), .iColour(3'b100), .vertical(1'b1), .x(9'd208), .y(9'd105), .iClock(iClock), .outX(testGate6X), .outY(testGate6Y), .done(gate6Done) );
	defparam testGate6.LENGTH = 6;
	
	gateBuilder testGate7 (.enable(gate7En), .iColour(3'b100), .vertical(1'b1), .x(9'd167), .y(9'd155), .iClock(iClock), .outX(testGate7X), .outY(testGate7Y), .done(gate7Done));
	defparam testGate7.LENGTH = 5;
	
	gateBuilder testGate8 (.enable(gate8En), .iColour(3'b100), .vertical(1'b1), .x(9'd167), .y(9'd161), .iClock(iClock), .outX(testGate8X), .outY(testGate8Y), .done(gate8Done));
	defparam testGate8.LENGTH = 7;
	
	gateBuilder testGate9 (.enable(gate9En), .iColour(3'b100), .vertical(1'b0), .x(9'd48), .y(9'd128), .iClock(iClock), .outX(testGate9X), .outY(testGate9Y), .done(gate9Done));
	defparam testGate9.LENGTH = 13;
	
	gateBuilder testGate10 (.enable(gate10En), .iColour(3'b100), .vertical(1'b0), .x(9'd259), .y(9'd73), .iClock(iClock), .outX(testGate10X), .outY(testGate10Y), .done(gate10Done));
	defparam testGate10.LENGTH = 14;
	
	// BLACKING GATES
	gateBuilder testGateBlack1 (.enable(gate1BlackEn), .iColour(3'b010), .vertical(1'b0), .x(9'd110), .y(9'd73), .iClock(iClock), .outX(testGate1X), .outY(testGate1Y), .done(gate1BlackDone));
	defparam testGateBlack1.LENGTH = 14;
	gateBuilder testGateBlack2 (.enable(gate2BlaclEn), .iColour(3'b010), .vertical(1'b1), .x(9'd124), .y(9'd104), .iClock(iClock), .outX(testGate2X), .outY(testGate2Y), .done(gate2BlackDone));
	defparam testGateBlack2.LENGTH = 7;
	/*
Check which gate is selected from select gate -> if gateBuilt == 11 -> build with blue -> gateBuilt set to gate from shift reg -> if diff gate selected compared to gateBuilt -> do step 3 with black -> do step 3 with blue 
*/
	// wire [3:0] gateBuilt = 4'd14;
	
	
	// always @ (posedge iClock) begin
		
		// // build a blue gate at proper location
		// if(currentGate == 4'd0) begin
			// if(done == 1'b1) begin
				// gate1En <= 1'b1;
			// end
			// else begin
				// gate1En <= 1'b1;
				// colourReg <= 3'b001;
				// gateRegX <= testGate1X;
				// gateRegY <= testGate1Y;
			// end
			
		// end
	
	// end
	
	
	
//	
//	assign testGate1X = 9'd176;
//	assign testGate1Y = 9'd160;
//	
//	assign testGate2X = 9'd75;
//	assign testGate2Y = 9'd48;	
//	
//	assign testGate3X = 9'd130;
//	assign testGate3Y = 9'd104;
//	
//	assign testGate4X = 9'd204;
//	assign testGate4Y = 9'd110;
//	
//	assign testGate5X = 9'd61;
//	assign testGate5Y = 9'd105;
//	
//	assign testGate6X = 9'd260;
//	assign testGate6Y = 9'd74;
//	
//	assign testGate7X = 9'd47;
//	assign testGate7Y = 9'd188;
	
	// always @(posedge playerEn) begin
		// if (up) begin 
			// playerY <= playerY + 1'd1;
			// colourReg <= 1'b010;
		// end
		// // else if (currentKeyPressed == A) playerX <= playerX - 1'd1;
		// // else if (currentKeyPressed == S) playerY <= playerY - 1'd1;
		// // else if (currentKeyPressed == D) playerX <= playerX + 1'd1;
	// end
	
	 always @(posedge iClock) begin
		if(xScreen < 9'd320) begin
					xScreen <= xScreen + 1'b1;
			  end
			  else if(xScreen == 9'd320) begin
					if(yScreen == 9'd240)begin
						 yScreen <= 1'd0;
					end
					else begin
						 yScreen <= yScreen + 1'b1;
					end
					xScreen <= 1'd0;
			  end
	 
		if(enableOneSecond) begin  // CHANGE NAME OF ENABLE VAR
			
			if (curTime > 1'b0) begin
				if (playerWon == 1'b0) begin
					curTime <= curTime - 1'b1;
				end
				
			 end
            if (curTime == 1'b0) begin
				
				if (playerWon == 1'b0) begin
					timeRanOut <= 1'b1;
				end
				
			end
		end
		
		if((playerWon == 1'b1) && (timeRanOut == 1'b0)) begin

			// player won, stop timer
			stopTimer <= 1'b0;
			
			if(screenBlackedOut == 1'b0) begin
				drawing <= 1'b1;
				colourReg <= 3'b000;
				gateRegX <= xScreen;
				gateRegY <= yScreen;

				if((xScreen == 9'd319) && (yScreen == 9'd239)) begin
					screenBlackedOut <= 1'b1;
				end
			end

			if(screenBlackedOut == 1'b1) begin
				drawing <= 1'b1;
				gateRegX <= xScreen;
				gateRegY <= yScreen;
				addressOfPlayerWinScreen <= ( (320 * yScreen) + xScreen);
				
				if(colourPlayerWinScreen == 3'd7) begin
					colourReg <=  3'b111;
				end
				else begin
					colourReg <=  3'b000;
				end
				
			end
			
		end
		else if ((playerWon == 1'b0) && (timeRanOut == 1'b1)) begin
			// computer won, stop timer
			stopTimer <= 1'b0;
			
			if(screenBlackedOut == 1'b0) begin
				drawing <= 1'b1;
				colourReg <= 3'b000;
				gateRegX <= xScreen;
				gateRegY <= yScreen;

				if((xScreen == 9'd319) && (yScreen == 9'd239)) begin
					screenBlackedOut <= 1'b1;
				end
			end
			
			if(screenBlackedOut == 1'b1) begin
				drawing <= 1'b1;
				gateRegX <= xScreen;
				gateRegY <= yScreen;
				addressOfComputerWinScreen <= ( (320 * yScreen) + xScreen);
				
				if(colourComputerWinScreen == 3'd7) begin
					colourReg <=  3'b111;
				end
				else begin
					colourReg <=  3'b000;
				end
				
			end
		end
			else 
		begin 
			if (playerEn) begin
				frameCounter <= frameCounter + 1'b1;
			end
			if (frameCounter == (speedReg/2)) begin
				prevPosX <= playerX;
				prevPosY <= playerY; 
			end 
			else if (frameCounter == speedReg) begin
				if (up) begin
					if (!((playerY - 1'd1 == 9'd48 || playerY - 1'd1 == 9'd49) && (playerX >= 9'd46 && playerX <= 9'd273))
						 && !((playerX == 9'd46 || playerX == 9'd47) && (playerY - 1'd1 >= 9'd48 && playerY - 1'd1 <= 9'd188))
						 && !((playerY - 1'd1 == 9'd188 || playerY - 1'd1 == 9'd187) && (playerX >= 9'd46 && playerX <= 9'd273))
						 && !(playerX == 9'd273 && (playerY - 1'd1 >= 9'd48 && playerY - 1'd1 <= 9'd188))
						 && !((playerY - 1'd1 == 9'd73 || playerY - 1'd1 == 9'd72) && (playerX >= 9'd48 && playerX <= 9'd109))
						 && !((playerY - 1'd1 == 9'd73 || playerY - 1'd1 == 9'd72) && (playerX >= 9'd123 && playerX <= 9'd258))
						 && !(playerY - 1'd1 == 9'd104 && (playerX >= 9'd61 && playerX <= 9'd124))
						 && !(playerY - 1'd1 == 9'd104 && (playerX >= 9'd133 && playerX <= 9'd273))
						 && !((playerY - 1'd1 == 9'd128 || playerY - 1'd1 == 9'd127) && (playerX >= 9'd61 && playerX <= 9'd154))
						 && !((playerY - 1'd1 == 9'd128 || playerY - 1'd1 == 9'd127) && (playerX >= 9'd177 && playerX <= 9'd209))
						 && !(playerY - 1'd1 == 9'd160 && (playerX >= 9'd46 && playerX <= 9'd110))
						 && !(playerY - 1'd1 == 9'd160 && (playerX >= 9'd139 && playerX <= 9'd200))
						 && !(playerY - 1'd1 == 9'd160 && (playerX >= 9'd208 && playerX <= 9'd273))
						 && !((playerX == 9'd123 || playerX == 9'd124) && (playerY - 1'd1 >= 9'd74 && playerY - 1'd1 <= 9'd104))
						 && !((playerX == 9'd123 || playerX == 9'd124) && (playerY - 1'd1 >= 9'd111 && playerY - 1'd1 <= 9'd180))
						 && !((playerX == 9'd167 || playerX == 9'd168) && (playerY - 1'd1 >= 9'd48 && playerY - 1'd1 <= 9'd63)) //unsure
						 && !(playerX == 9'd167 && (playerY - 1'd1 >= 9'd89 && playerY - 1'd1 <= 9'd155))
						 && !(playerX == 9'd167 && (playerY - 1'd1 >= 9'd167 && playerY - 1'd1 <= 9'd188))
						 && !((playerX == 9'd208 || playerX == 9'd209) && (playerY - 1'd1 >= 9'd111 && playerY - 1'd1 <= 9'd188))
						 && !(gateOneClosed && playerY - 1'd1 == 9'd73 && (playerX >= 9'd109 && playerX <= 9'd123))
						 && !(gateTwoClosed && playerX == 9'd123 && (playerY - 1'd1 >= 9'd104 && playerY - 1'd1 <= 9'd111))
						 && !(gateThreeClosed && playerX == 9'd123 && (playerY - 1'd1 >= 9'd180 && playerY - 1'd1 <= 9'd188))
						 && !(gateFourClosed && playerY - 1'd1 == 9'd104 && (playerX >= 9'd124 && playerX <= 9'd133))
						 && !(gateFiveClosed && playerY - 1'd1 == 9'd127 && (playerX >= 9'd154 && playerX <= 9'd167))
						 && !(gateSixClosed && playerX == 9'd208 && (playerX >= 9'd105 && playerX <= 9'd110))
						 && !(gateSevenClosed && playerX == 9'd167 && (playerY >= 9'd155 && playerY <= 9'd159))
						 && !(gateEightClosed && playerX == 9'd167 && (playerY >= 9'd161 && playerY <= 9'd167))
						 && !(gateNineClosed && playerY - 1'd1 == 9'd128 && (playerX >= 9'd48 && playerX <= 9'd60))
					&& !(gateTenClosed && playerY - 1'd1 == 9'd73 && (playerX >= 9'd258 && playerX <= 9'd288)))
					begin 
						playerY <= playerY - 1'd1;	
					end
				end 
				else if (left) begin
					if (!((playerY == 9'd48 || playerY == 9'd49) && (playerX - 1'd1 >= 9'd46 && playerX - 1'd1 <= 9'd273))
						 && !((playerX - 1'd1 == 9'd46 || playerX - 1'd1 == 9'd47) && (playerY >= 9'd48 && playerY <= 9'd188))
						 && !((playerY == 9'd188 || playerY == 9'd187) && (playerX - 1'd1 >= 9'd46 && playerX - 1'd1 <= 9'd273))
						 && !(playerX - 1'd1 == 9'd273 && (playerY >= 9'd48 && playerY <= 9'd188))
						 && !((playerY == 9'd73 || playerY == 9'd72) && (playerX - 1'd1 >= 9'd48 && playerX - 1'd1 <= 9'd109))
						 && !((playerY == 9'd73 || playerY == 9'd72) && (playerX - 1'd1 >= 9'd123 && playerX - 1'd1 <= 9'd258))
						 && !(playerY == 9'd104 && (playerX - 1'd1 >= 9'd61 && playerX - 1'd1 <= 9'd124))
						 && !(playerY == 9'd104 && (playerX - 1'd1 >= 9'd133 && playerX - 1'd1 <= 9'd273))
						 && !((playerY == 9'd128 || playerY == 9'd127) && (playerX - 1'd1 >= 9'd61 && playerX - 1'd1 <= 9'd154))
						 && !((playerY == 9'd128 || playerY == 9'd127) && (playerX - 1'd1 >= 9'd177 && playerX - 1'd1 <= 9'd209))
						 && !(playerY == 9'd160 && (playerX - 1'd1 >= 9'd46 && playerX - 1'd1 <= 9'd110))
						 && !(playerY == 9'd160 && (playerX - 1'd1 >= 9'd139 && playerX - 1'd1 <= 9'd200))
						 && !(playerY == 9'd160 && (playerX - 1'd1 >= 9'd208 && playerX - 1'd1 <= 9'd273))
						 && !((playerX - 1'd1 == 9'd123 || playerX - 1'd1 == 9'd124) && (playerY >= 9'd74 && playerY <= 9'd104))
						 && !((playerX - 1'd1 == 9'd123 || playerX - 1'd1 == 9'd124) && (playerY >= 9'd111 && playerY <= 9'd180))
						 && !((playerX - 1'd1 == 9'd167 || playerX - 1'd1 == 9'd168) && (playerY >= 9'd48 && playerY <= 9'd63)) //unsure
						 && !(playerX - 1'd1 == 9'd167 && (playerY >= 9'd89 && playerY <= 9'd155))
						 && !(playerX - 1'd1 == 9'd167 && (playerY >= 9'd167 && playerY <= 9'd188))
						 && !((playerX - 1'd1 == 9'd208 || playerX - 1'd1 == 9'd209) && (playerY >= 9'd111 && playerY <= 9'd188))
						 && !(gateOneClosed && playerY == 9'd73 && (playerX - 1'd1 >= 9'd109 && playerX - 1'd1 <= 9'd123))
						 && !(gateTwoClosed && playerX - 1'd1 == 9'd123 && (playerY >= 9'd104 && playerY <= 9'd111))
						 && !(gateThreeClosed && playerX - 1'd1 == 9'd123 && (playerY >= 9'd180 && playerY <= 9'd188))
						 && !(gateFourClosed && playerY == 9'd104 && (playerX - 1'd1 >= 9'd124 && playerX - 1'd1 <= 9'd133))
						 && !(gateFiveClosed && playerY == 9'd127 && (playerX - 1'd1 >= 9'd154 && playerX - 1'd1 <= 9'd167))
						 && !(gateSixClosed && playerX - 1'd1 == 9'd208 && (playerY >= 9'd105 && playerY <= 9'd110))
						 && !(gateSevenClosed && playerX - 1'd1 == 9'd167 && (playerY >= 9'd155 && playerY <= 9'd159))
						 && !(gateEightClosed && playerX - 1'd1 == 9'd167 && (playerY >= 9'd161 && playerY <= 9'd167))
						 && !(gateNineClosed && playerY == 9'd128 && (playerX - 1'd1 >= 9'd48 && playerX - 1'd1 <= 9'd60))
					&& !(gateTenClosed && playerY == 9'd73 && (playerX - 1'd1 >= 9'd258 && playerX - 1'd1 <= 9'd288)))
					begin 
						playerX <= playerX - 1'd1;
					end 
				end 
				else if(down) begin 
					if (!((playerY + 1'd1 == 9'd48 || playerY + 1'd1 == 9'd49) && (playerX >= 9'd46 && playerX <= 9'd273))
						 && !((playerX == 9'd46 || playerX == 9'd47) && (playerY + 1'd1 >= 9'd48 && playerY + 1'd1 <= 9'd188))
						 && !((playerY + 1'd1 == 9'd188 || playerY + 1'd1 == 9'd187) && (playerX >= 9'd46 && playerX <= 9'd273))
						 && !(playerX == 9'd273 && (playerY + 1'd1 >= 9'd48 && playerY + 1'd1 <= 9'd188))
						 && !((playerY + 1'd1 == 9'd73 || playerY + 1'd1 == 9'd72) && (playerX >= 9'd48 && playerX <= 9'd109))
						 && !((playerY + 1'd1 == 9'd73 || playerY + 1'd1 == 9'd72) && (playerX >= 9'd123 && playerX <= 9'd258))
						 && !(playerY + 1'd1 == 9'd104 && (playerX >= 9'd61 && playerX <= 9'd124))
						 && !(playerY + 1'd1 == 9'd104 && (playerX >= 9'd133 && playerX <= 9'd273))
						 && !((playerY + 1'd1 == 9'd128 || playerY + 1'd1 == 9'd127) && (playerX >= 9'd61 && playerX <= 9'd154))
						 && !((playerY + 1'd1 == 9'd128 || playerY + 1'd1 == 9'd127) && (playerX >= 9'd177 && playerX <= 9'd209))
						 && !(playerY + 1'd1 == 9'd160 && (playerX >= 9'd46 && playerX <= 9'd110))
						 && !(playerY + 1'd1 == 9'd160 && (playerX >= 9'd139 && playerX <= 9'd200))
						 && !(playerY + 1'd1 == 9'd160 && (playerX >= 9'd208 && playerX <= 9'd273))
						 && !((playerX == 9'd123 || playerX == 9'd124) && (playerY + 1'd1 >= 9'd74 && playerY + 1'd1 <= 9'd104))
						 && !((playerX == 9'd123 || playerX == 9'd124) && (playerY + 1'd1 >= 9'd111 && playerY + 1'd1 <= 9'd180))
						 && !((playerX == 9'd167 || playerX == 9'd168) && (playerY + 1'd1 >= 9'd48 && playerY + 1'd1 <= 9'd63)) //unsure
						 && !(playerX == 9'd167 && (playerY + 1'd1 >= 9'd89 && playerY + 1'd1 <= 9'd155))
						 && !(playerX == 9'd167 && (playerY + 1'd1 >= 9'd167 && playerY + 1'd1 <= 9'd188))
						 && !((playerX == 9'd208 || playerX == 9'd209) && (playerY + 1'd1 >= 9'd111 && playerY + 1'd1 <= 9'd188))
						 && !(gateOneClosed && playerY + 1'd1 == 9'd73 && (playerX >= 9'd109 && playerX <= 9'd123))
						 && !(gateTwoClosed && playerX == 9'd123 && (playerY + 1'd1 >= 9'd104 && playerY + 1'd1 <= 9'd111))
						 && !(gateThreeClosed && playerX == 9'd123 && (playerY + 1'd1 >= 9'd180 && playerY + 1'd1 <= 9'd188))
						 && !(gateFourClosed && playerY + 1'd1 == 9'd104 && (playerX >= 9'd124 && playerX <= 9'd133))
						 && !(gateFiveClosed && playerY + 1'd1 == 9'd127 && (playerX >= 9'd154 && playerX <= 9'd167))
						 && !(gateSixClosed && playerX == 9'd208 && (playerY >= 9'd105 && playerY <= 9'd110))
						 && !(gateSevenClosed && playerX == 9'd167 && (playerY >= 9'd155 && playerY <= 9'd159))
						 && !(gateEightClosed && playerX == 9'd167 && (playerY >= 9'd161 && playerY <= 9'd167))
						 && !(gateNineClosed && playerY + 1'd1 == 9'd128 && (playerX >= 9'd48 && playerX <= 9'd60))
						 && !(gateTenClosed && playerY + 1'd1 == 9'd73 && (playerX >= 9'd258 && playerX <= 9'd288)))
					begin
						playerY <= playerY + 1'd1;
					end 
				end
				else if (right) begin 
					if (!((playerY == 9'd48 || playerY == 9'd49) && (playerX + 1'd1 >= 9'd46 && playerX + 1'd1 <= 9'd273))
						 && !((playerX + 1'd1 == 9'd46 || playerX + 1'd1 == 9'd47) && (playerY >= 9'd48 && playerY <= 9'd188))
						 && !((playerY == 9'd188 || playerY == 9'd187) && (playerX + 1'd1 >= 9'd46 && playerX + 1'd1 <= 9'd273))
						 && !(playerX + 1'd1 == 9'd273 && (playerY >= 9'd48 && playerY <= 9'd188))
						 && !((playerY == 9'd73 || playerY == 9'd72) && (playerX + 1'd1 >= 9'd48 && playerX + 1'd1 <= 9'd109))
						 && !((playerY == 9'd73 || playerY == 9'd72) && (playerX + 1'd1 >= 9'd123 && playerX + 1'd1 <= 9'd258))
						 && !(playerY == 9'd104 && (playerX + 1'd1 >= 9'd61 && playerX + 1'd1 <= 9'd124))
						 && !(playerY == 9'd104 && (playerX + 1'd1 >= 9'd133 && playerX + 1'd1 <= 9'd273))
						 && !((playerY == 9'd128 || playerY == 9'd127) && (playerX + 1'd1 >= 9'd61 && playerX + 1'd1 <= 9'd154))
						 && !((playerY == 9'd128 || playerY == 9'd127) && (playerX + 1'd1 >= 9'd177 && playerX + 1'd1 <= 9'd209))
						 && !(playerY == 9'd160 && (playerX + 1'd1 >= 9'd46 && playerX + 1'd1 <= 9'd110))
						 && !(playerY == 9'd160 && (playerX + 1'd1 >= 9'd139 && playerX + 1'd1 <= 9'd200))
						 && !(playerY == 9'd160 && (playerX + 1'd1 >= 9'd208 && playerX + 1'd1 <= 9'd273))
						 && !((playerX + 1'd1 == 9'd123 || playerX + 1'd1 == 9'd124) && (playerY >= 9'd74 && playerY <= 9'd104))
						 && !((playerX + 1'd1 == 9'd123 || playerX + 1'd1 == 9'd124) && (playerY >= 9'd111 && playerY <= 9'd180))
						 && !((playerX + 1'd1 == 9'd167 || playerX + 1'd1 == 9'd168) && (playerY >= 9'd48 && playerY <= 9'd63)) //unsure
						 && !(playerX + 1'd1 == 9'd167 && (playerY >= 9'd89 && playerY <= 9'd155))
						 && !(playerX + 1'd1 == 9'd167 && (playerY >= 9'd167 && playerY <= 9'd188))
						 && !((playerX + 1'd1 == 9'd208 || playerX + 1'd1 == 9'd209) && (playerY >= 9'd111 && playerY <= 9'd188))
						 && !(gateOneClosed && playerY == 9'd73 && (playerX + 1'd1 >= 9'd109 && playerX + 1'd1 <= 9'd123))
						 && !(gateTwoClosed && playerX + 1'd1 == 9'd123 && (playerY >= 9'd104 && playerY <= 9'd111))
						 && !(gateThreeClosed && playerX + 1'd1 == 9'd123 && (playerY >= 9'd180 && playerY <= 9'd188))
						 && !(gateFourClosed && playerY == 9'd104 && (playerX + 1'd1 >= 9'd124 && playerX + 1'd1 <= 9'd133))
						 && !(gateFiveClosed && playerY == 9'd127 && (playerX + 1'd1 >= 9'd154 && playerX + 1'd1 <= 9'd167))
						 && !(gateSixClosed && playerX + 1'd1 == 9'd208 && (playerY >= 9'd105 && playerY <= 9'd110))
						 && !(gateSevenClosed && playerX + 1'd1 == 9'd167 && (playerY >= 9'd155 && playerY <= 9'd159))
						 && !(gateEightClosed && playerX + 1'd1 == 9'd167 && (playerY >= 9'd161 && playerY <= 9'd167))
						 && !(gateNineClosed && playerY == 9'd128 && (playerX + 1'd1 >= 9'd48 && playerX + 1'd1 <= 9'd60))
						 && !(gateTenClosed && playerY == 9'd73 && (playerX + 1'd1 >= 9'd258 && playerX + 1'd1 <= 9'd288)))
					begin 
						playerX <= playerX + 1'd1;
					end 
				end
				// gateRegX <= playerX;
				// gateRegY <= playerY;
				
				frameCounter <= 4'b0000;
			end 
		

			  //Add logic for modifying 'drawing' based on counters and currentGate
			  if(yScreen == 9'd73) begin
					if(xScreen >= 9'd110) begin
						 if(xScreen <= 9'd123) begin
							  drawing <= 1'b1;
							  colourReg <= colourGate1;
							  gateRegX <= xScreen;
							gateRegY <= yScreen;
						 end
						 else begin
							  drawing <= 1'b0;
						 end
					end
					else begin 
						 drawing <= 1'b0;
					end
			  end
			  if(xScreen == 9'd123) begin
					if(yScreen >= 9'd105) begin
						 if(yScreen <= 9'd111) begin
							  drawing <= 1'b1;
							  colourReg <= colourGate2;
							  gateRegX <= xScreen;
							  gateRegY <= yScreen;
						 end
						 else begin
							  drawing <= 1'b0;
						 end
					end
					else begin
						 drawing <= 1'b0;
					end
			  end
			  if(xScreen == 9'd123) begin
					if(yScreen >= 9'd181) begin
						 if(yScreen <= 9'd186)begin
							  drawing <= 1'b1;
							  colourReg <= colourGate3;
							  gateRegX <= xScreen;
							  gateRegY <= yScreen;
						 end
						 else begin
							  drawing <= 1'b0;
						 end
					end
					else begin
						 drawing <= 1'b0;
					end
			  end
			  if(yScreen == 9'd104) begin
					if(xScreen >= 9'd124) begin
						 if(xScreen <= 9'd133)begin
							  drawing <= 1'b1;
							  colourReg <= colourGate4;
							  gateRegX <= xScreen;
							  gateRegY <= yScreen;
						 end
						 else begin
							  drawing <= 1'b0;
						 end
					end
					else begin
						 drawing <= 1'b0;
					end
			  end
			  if(yScreen == 9'd127) begin
					if(xScreen >= 9'd154) begin
						 if (xScreen <= 9'd166) begin
							  drawing <= 1'b1;
							  colourReg <= colourGate5;
							  gateRegX <= xScreen;
							  gateRegY <= yScreen;
						 end
						 else begin
							  drawing <= 1'b0;
						 end
					end
					else begin
						 drawing <= 1'b0;
					end
			  end
			  if(xScreen == 9'd208) begin
					if(yScreen >= 9'd105) begin
						 if(yScreen <= 9'd110)begin
							  drawing <= 1'b1;
							  colourReg <= colourGate6;
							  gateRegX <= xScreen;
							  gateRegY <= yScreen;
						 end
						 else begin
							  drawing <= 1'b0;
						 end
					end
					else begin
						 drawing <= 1'b0;
					end
			  end
			  if(xScreen == 9'd167) begin
					if(yScreen >= 9'd155) begin
						 if(yScreen <= 9'd159)begin
							  drawing <= 1'b1;
							  colourReg <= colourGate7;
							  gateRegX <= xScreen;
							  gateRegY <= yScreen;
						 end
						 else begin
							  drawing <= 1'b0;
						 end
					end
					else begin
						 drawing <= 1'b0;
					end
			  end
			  if(xScreen == 9'd167) begin
					if(yScreen >= 9'd161) begin
						 if(yScreen <= 9'd167)begin
							  drawing <= 1'b1;
							  colourReg <= colourGate8;
							  gateRegX <= xScreen;
							  gateRegY <= yScreen;
						 end
						 else begin
							  drawing <= 1'b0;
						 end
					end
					else begin
						 drawing <= 1'b0;
					end
			  end
			  if(yScreen == 9'd128) begin
					if(xScreen >= 9'd48) begin
						 if(xScreen <= 9'd60)begin
							  drawing <= 1'b1;
							  colourReg <= colourGate9;
							  gateRegX <= xScreen;
							  gateRegY <= yScreen;
						 end
						 else begin
							  drawing <= 1'b0;
						 end
					end
					else begin
						 drawing <= 1'b0;
					end
			  end
			  if(yScreen == 9'd73) begin
					if(xScreen >= 9'd259) begin
						 if(xScreen <= 9'd272)begin
							  drawing <= 1'b1;
							  colourReg <= colourGate10;
							  gateRegX <= xScreen;
							  gateRegY <= yScreen;
						 end
						 else begin
							  drawing <= 1'b0;
						 end
					end
					else begin
						 drawing <= 1'b0;
					end
			  end
			if (xScreen == playerX) begin
				if (yScreen == playerY) begin
					drawing <= 1'b1;
					colourReg <= 3'b110;
					gateRegX <= xScreen;
					gateRegY <= yScreen;
				end 
				else begin
					drawing <= 1'b0;
				end 
			end 
			
			if (xScreen == prevPosX) begin
				if (yScreen == prevPosY) begin
					drawing <= 1'b1;
					colourReg <= 3'b000;
					gateRegX <= xScreen;
					gateRegY <= yScreen;
				end 
				else begin
					drawing <= 1'b0;
				end 
			end 

			
			if(xScreen >= 9'd55) begin //location of power up one
				if(xScreen <= 9'd57) begin
					if(yScreen >= 9'd60 ) begin
						if(yScreen <= 9'd62) begin
							drawing <= 1'b1;
							colourReg <= colourPowerUp1;
							gateRegX <= xScreen;
							gateRegY <= yScreen;
						end
						else begin
							drawing <= 1'b0;
						end
					end
					else begin
						drawing <= 1'b0;
					end
				end
				else begin
					drawing <= 1'b0;
				end
			end
			if(xScreen >= 9'd150) begin //location of power up two
				if(xScreen <= 9'd152) begin
					if(yScreen >= 9'd179) begin
						if(yScreen <= 9'd181) begin
							drawing <= 1'b1;
							colourReg <= colourPowerUp2;
							gateRegX <= xScreen;
							gateRegY <= yScreen;
						end
						else begin
							drawing <= 1'b0;
						end
					end
					else begin
						drawing <= 1'b0;
					end
				end
				else begin
					drawing <= 1'b0;
				end
			end
			if(xScreen >= 9'd230) begin //location of power up three
				if(xScreen <= 9'd232) begin
					if(yScreen >= 9'd89) begin
						if(yScreen <= 9'd91) begin
							drawing <= 1'b1;
							colourReg <= colourPowerUp3;
							gateRegX <= xScreen;
							gateRegY <= yScreen;
						end
						else begin
							drawing <= 1'b0;
						end
					end
					else begin
						drawing <= 1'b0;
					end
				end
				else begin
					drawing <= 1'b0;
				end
			end
			
			
			// Determine if power up has been collected
			if(playerX >= 9'd55) begin
				if(playerX <= 9'd57) begin
					if(playerY >= 9'd60) begin
						if(playerY <= 9'd62) begin
							powerUpOneCollected <= 1'b1;
						end
					end
				end
			end
			if (playerX >= 9'd150) begin
				if(playerX <= 9'd152) begin
					if(playerY >= 9'd179) begin
						if(playerY <= 9'd181) begin
							powerUpTwoCollected <= 1'b1;
						end
					end
				end
			end
			if (playerX >= 9'd230) begin
				if(playerX <= 9'd232) begin
					if(playerY >= 9'd89) begin
						if(playerY <= 9'd91) begin
							powerUpThreeCollected <= 1'b1;
						end
					end
				end
			end
			
			
			  //DETERMINE COLOUR
			  //check if ability is used.
			  //  if ability not used, draw blue
			  //  if ability has been used, stop drawing, only red gate until cooldown runsout
			 
			 
			if(powerUpOneCollected && powerUpTwoCollected && powerUpThreeCollected) begin
				showPin <= 1'b1;
				speedReg <= 21'd50000; 
			end
			else if((powerUpOneCollected && powerUpTwoCollected) || (powerUpTwoCollected && powerUpThreeCollected) || (powerUpOneCollected && powerUpThreeCollected)) begin
				speedReg <= 21'd55000; 
			end
			else if(powerUpOneCollected || powerUpTwoCollected || powerUpThreeCollected) begin
				speedReg <= 21'd60000; 
			end
			


			//if blacked out, start counter, once counter runs out, show original colour
			if(blackedOut == 1'b0) begin
				if(enableOneSecond) begin // add one to counter every one second
					if(blackOutCounter == 3'd7)begin
						blackedOutFlag <= 1'b0;
					end
					else begin
						blackedOutFlag <= 1'b1;
						blackOutCounter <= blackOutCounter + 1'b1;
					end
					
				end
			end
			else begin 
				blackOutCounter <= 1'b0;
			end

			if(powerUpOneCollected == 1'b1)begin
				colourPowerUp1 = 3'b000;
			end
			else if (blackedOutFlag == 1'b1) begin // USE A WIRE THAT FEEDS FROM UI MODULE TO THIS TOP LEVEL
				colourPowerUp1 = 3'b000;
			end
			else begin
				colourPowerUp1 = 3'b010;
			end
			
			if(powerUpTwoCollected == 1'b1)begin
				colourPowerUp2 = 3'b000;
			end
			else if (blackedOutFlag == 1'b1) begin // USE A WIRE THAT FEEDS FROM UI MODULE TO THIS TOP LEVEL
				colourPowerUp2 = 3'b000;
			end
			else begin
				colourPowerUp2 = 3'b010;
			end

			if(powerUpThreeCollected == 1'b1)begin
				colourPowerUp3 = 3'b000;
			end
			else if (blackedOutFlag == 1'b1) begin // USE A WIRE THAT FEEDS FROM UI MODULE TO THIS TOP LEVEL
				colourPowerUp3 = 3'b000;
			end
			else begin
				colourPowerUp3 = 3'b010;
			end

			if(currentGate == 4'd0) begin

				if(canBuildGate == 1'b0) begin
					// gate placed, make red
					colourGate1 <= 3'b100;
					gateOneClosed = 1'b1;
				end
				else begin 
					colourGate1 <= 3'b011;
					gateOneClosed = 1'b0;
				end
				colourGate2 <= 3'b000;
				colourGate3 <= 3'b000;
				colourGate4 <= 3'b000;
				colourGate5 <= 3'b000;
				colourGate6 <= 3'b000;
				colourGate7 <= 3'b000;
				colourGate8 <= 3'b000;
				colourGate9 <= 3'b000;
				colourGate10 <= 3'b000;
					
			  end
			  else if(currentGate == 4'd1) begin

				if(canBuildGate == 1'b0) begin
					// gate placed, make red
					colourGate2 <= 3'b100;
					gateTwoClosed = 1'b1;

				end
				else begin 
					colourGate2 <= 3'b011;
					gateTwoClosed = 1'b0;
				end
					colourGate1 <= 3'b000;
					colourGate3 <= 3'b000;
					colourGate4 <= 3'b000;
					colourGate5 <= 3'b000;
					colourGate6 <= 3'b000;
					colourGate7 <= 3'b000;
					colourGate8 <= 3'b000;
					colourGate9 <= 3'b000;
					colourGate10 <= 3'b000;
			  end
			  else if(currentGate == 4'd2) begin
				
				if(canBuildGate == 1'b0) begin
					// gate placed, make red
					colourGate3 <= 3'b100;
					gateThreeClosed = 1'b1;
				end
				else begin 
					colourGate3 <= 3'b011;
					gateThreeClosed = 1'b0;
				end
					colourGate1 <= 3'b000;
					colourGate2 <= 3'b000;
					colourGate4 <= 3'b000;
					colourGate5 <= 3'b000;
					colourGate6 <= 3'b000;
					colourGate7 <= 3'b000;
					colourGate8 <= 3'b000;
					colourGate9 <= 3'b000;
					colourGate10 <= 3'b000;
			  end
			  else if(currentGate == 4'd3) begin

				if(canBuildGate == 1'b0) begin
					// gate placed, make red
					colourGate4 <= 3'b100;
					gateFourClosed = 1'b1;
				end
				else begin 
					colourGate4 <= 3'b011;
					gateFourClosed = 1'b0;
				end
					colourGate1 <= 3'b000;
					colourGate2 <= 3'b000;
					colourGate3 <= 3'b000;
					colourGate5 <= 3'b000;
					colourGate6 <= 3'b000;
					colourGate7 <= 3'b000;
					colourGate8 <= 3'b000;
					colourGate9 <= 3'b000;
					colourGate10 <= 3'b000;
			  end
			  else if(currentGate == 4'd4) begin
				
				if(canBuildGate == 1'b0) begin
					// gate placed, make red
					colourGate5 <= 3'b100;
					gateFiveClosed = 1'b1;
				end
				else begin 
					colourGate5 <= 3'b011;
					gateFiveClosed = 1'b0;
				end
					colourGate1 <= 3'b000;
					colourGate2 <= 3'b000;
					colourGate3 <= 3'b000;
					colourGate4 <= 3'b000;
					colourGate6 <= 3'b000;
					colourGate7 <= 3'b000;
					colourGate8 <= 3'b000;
					colourGate9 <= 3'b000;
					colourGate10 <= 3'b000;
			  end
			  else if(currentGate == 4'd5) begin

				if(canBuildGate == 1'b0) begin
					// gate placed, make red
					colourGate6 <= 3'b100;
					gateSixClosed = 1'b1;
				end
				else begin 
					colourGate6 <= 3'b011;
					gateSixClosed = 1'b0;
				end
					colourGate1 <= 3'b000;
					colourGate2 <= 3'b000;
					colourGate3 <= 3'b000;
					colourGate4 <= 3'b000;
					colourGate5 <= 3'b000;
					colourGate7 <= 3'b000;
					colourGate8 <= 3'b000;
					colourGate9 <= 3'b000;
					colourGate10 <= 3'b000;
			  end
			  else if(currentGate == 4'd6) begin
					
				if(canBuildGate == 1'b0) begin
					// gate placed, make red
					colourGate7 <= 3'b100;
					gateSevenClosed = 1'b1;
				end
				else begin 
					colourGate7 <= 3'b011;
					gateSevenClosed = 1'b0;
				end
				colourGate1 <= 3'b000;
					colourGate2 <= 3'b000;
					colourGate3 <= 3'b000;
					colourGate4 <= 3'b000;
					colourGate5 <= 3'b000;
					colourGate6 <= 3'b000;
					colourGate8 <= 3'b000;
					colourGate9 <= 3'b000;
					colourGate10 <= 3'b000;
			  end
			  else if(currentGate == 4'd7) begin

				if(canBuildGate == 1'b0) begin
					// gate placed, make red
					colourGate8 <= 3'b100;
					gateEightClosed = 1'b1;
				end
				else begin 
					colourGate8 <= 3'b011;
					gateEightClosed = 1'b0;
				end
					colourGate1 <= 3'b000;
					colourGate2 <= 3'b000;
					colourGate3 <= 3'b000;
					colourGate4 <= 3'b000;
					colourGate5 <= 3'b000;
					colourGate6 <= 3'b000;
					colourGate7 <= 3'b000;
					colourGate9 <= 3'b000;
					colourGate10 <= 3'b000;
			  end
			  else if(currentGate == 4'd8) begin

				if(canBuildGate == 1'b0) begin
					// gate placed, make red
					colourGate9 <= 3'b100;
					gateNineClosed = 1'b1;
				end
				else begin 
					colourGate9 <= 3'b011;
					gateNineClosed = 1'b0;
				end
					colourGate1 <= 3'b000;
					colourGate2 <= 3'b000;
					colourGate3 <= 3'b000;
					colourGate4 <= 3'b000;
					colourGate5 <= 3'b000;
					colourGate6 <= 3'b000;
					colourGate7 <= 3'b000;
					colourGate8 <= 3'b000;
					colourGate10 <= 3'b000;
			  end
			  else if(currentGate == 4'd9) begin

				if(canBuildGate == 1'b0) begin
					// gate placed, make red
					colourGate10 <= 3'b100;
					gateTenClosed = 1'b1;
				end
				else begin 
					colourGate10 <= 3'b011;
					gateTenClosed = 1'b0;
				end
					colourGate1 <= 3'b000;
					colourGate2 <= 3'b000;
					colourGate3 <= 3'b000;
					colourGate4 <= 3'b000;
					colourGate5 <= 3'b000;
					colourGate6 <= 3'b000;
					colourGate7 <= 3'b000;
					colourGate8 <= 3'b000;
					colourGate9 <= 3'b000;
			  end

			//CHECK ABILITY AVAILIBILITY
	//	
	//		if(gateBuilt <= 4'd10) begin
	//			
	//			if(gateBuilt != currentGate) begin
	//				
	//				if(gateBuilt == 4'd0) begin
	//					gate1BlackEn <= 1'b1;
	//					colourReg <= 3'b010; // SET BLACK
	//					gateRegX <= testGate1X;
	//					gateRegY <= testGate1Y;
	//
	//					if(buildCounter == 5'd20) begin
	//						buildCounter <= 5'b0;
	//						gate1BlackEn <= 1'b0;
	//						gateBuilt <= 4'd13;
	//					end
	//					else begin
	//						buildCounter <= buildCounter + 1'b1;
	//					end
	//				end
	//				
	//				if(gateBuilt == 4'd1) begin
	//					gate2BlackEn <= 1'b1;
	//					colourReg <= 3'b010; // SET BLACK
	//					gateRegX <= testGate2X;
	//					gateRegY <= testGate2Y;
	//					gateBuilt <= 4'd13;
	//
	//					if(buildCounter == 5'd20) begin
	//						buildCounter <= 5'b0;
	//						gate2BlackEn <= 1'b0;
	//						gateBuilt <= 4'd13;
	//					end
	//					else begin
	//						buildCounter <= buildCounter + 1'b1;
	//					end
	//				end
	//				
	//			end	
	//		end
	//		else begin
	//			
	//			if(currentGate == 4'd0) begin
	//				gate1En <= 1'b1;
	//				colourReg <= 3'b001;
	//				gateRegX <= testGate1X;
	//				gateRegY <= testGate1Y;
	//
	//				if(buildCounter == 5'd20) begin
	//					buildCounter <= 5'b0;
	//					gate1En <= 1'b0;
	//					gateBuilt <= 4'd0;
	//				end
	//				else begin
	//					buildCounter <= buildCounter + 1'b1;
	//				end
	//				
	//			end
	//			
	//			if(currentGate == 4'd1) begin
	//				gate2En <= 1'b1;
	//				colourReg <= 3'b001;
	//				gateRegX <= testGate2X;
	//				gateRegY <= testGate2Y;
	//
	//				if(buildCounter == 5'd20) begin
	//					buildCounter <= 5'b0;
	//					gate2En <= 1'b0;
	//					gateBuilt <= 4'd1;
	//				end
	//				else begin
	//					buildCounter <= buildCounter + 1'b1;
	//				end
	//				
	//				
	//			end
	//			
	//			
	//		end
	//			

			// if (prevGate != currentGate) begin 
				// if (prevGate == 4'd0) 
				// begin
					// if (gate1Done) begin 
						// gate1En <= 1'b0;
						// prevGate <= currentGate;	
					// end
					// else begin
						// gate1En <= 1'b1;
						// colourReg <= 3'b010; 
						// gateRegX <= testGate1X;
						// gateRegY <= testGate1Y;
					// end 
				// end
				// else if (prevGate == 4'd1) 
				// begin
					// if (gate2Done) begin 
						// gate2En <= 1'b0;
						// prevGate <= currentGate;	
					// end 
					// else begin 
						// gate2En <= 1'b1;
						// colourReg <= 3'b010; 
						// gateRegX <= testGate2X;
						// gateRegY <= testGate2Y;
					// end 
				// end
				// else if (prevGate == 4'd2) 
				// begin
					// if (gate3Done) begin 
						// gate3En <= 1'b0;
						// prevGate <= currentGate;	
					// end 
					// else begin
						// colourReg <= 3'b010;
						// gate3En <= 1'b1;
						// gateRegX <= testGate3X;
						// gateRegY <= testGate3Y;
					// end 
				// end
				// else if (prevGate == 4'd3) 
				// begin
					// if (gate4Done) begin 
						// gate4En <= 1'b0;
						// prevGate <= currentGate;	
					// end
					// else begin
						// colourReg <= 3'b010;
						// gate4En <= 1'b1;
						// gateRegX <= testGate4X;
						// gateRegY <= testGate4Y;
					// end 
				// end
				// else if (prevGate == 4'd4) 
				// begin
					// gate5En <= 1'b1;
					// gateRegX <= testGate5X;
					// gateRegY <= testGate5Y;
					// if (gate5Done) begin 
						// gate5En <= 1'b0;
						// prevGate <= currentGate;	
					// end 
				// end
				// else if (prevGate == 4'd5) 
				// begin
					// gate6En <= 1'b1;
					// gateRegX <= testGate6X;
					// gateRegY <= testGate6Y;
					// if (gate6Done) begin 
						// gate6En <= 1'b0;
						// prevGate <= currentGate;	
					// end 
				// end
				// else if (prevGate == 4'd6) 
				// begin
					// gate7En <= 1'b1;
					// gateRegX <= testGate7X;
					// gateRegY <= testGate7Y;
					// if (gate7Done) begin 
						// gate7En <= 1'b0;
						// prevGate <= currentGate;
					// end 
				// end
				// else if (prevGate == 4'd7) 
				// begin
					// if (!gate8Done) begin 
					// gate8En <= 1'b1;
					// gateRegX <= testGate8X;
					// gateRegY <= testGate8Y;
					// end
					// if (gate8Done) begin 
						// gate8En <= 1'b0;
						// prevGate <= currentGate;	
					// end 
				// end
				// else if (prevGate == 4'd8) 
				// begin
					// gate9En <= 1'b1;
					// gateRegX <= testGate9X;
					// gateRegY <= testGate9Y;
					// if (gate9Done) begin 
						// gate9En <= 1'b0;
						// prevGate <= currentGate;	
					// end 
					
				// end
				// else if (prevGate == 4'd9) 
				// begin
					// gate10En <= 1'b1;
					// gateRegX <= testGate10X;
					// gateRegY <= testGate10Y;
					// if (gate10Done) begin 
						// gate10En <= 1'b0;
						// prevGate <= currentGate;	
					// end 
				// end 
			// end
			// else if (prevGate == currentGate) begin
				// if (currentGate == 4'd0) 
				// begin
					// if (gate1Done) begin 
						// gate1En <= 1'b0;
					// end
					// else begin 
						// colourReg <= 3'b100;
						// gate1En <= 1'b1;
						// gateRegX <= testGate1X;
						// gateRegY <= testGate1Y;
					// end 
				// end
				// else if (currentGate == 4'd1) 
				// begin
					// if (gate2Done) begin 
						// gate2En <= 1'b0;
					// end
					// else begin 
						// colourReg <= 3'b100;
						// gate2En <= 1'b1;
						// gateRegX <= testGate2X;
						// gateRegY <= testGate2Y;
					// end 
				// end
				// else if (currentGate == 4'd2) 
				// begin
					// colourReg <= 3'b100;
					// gate3En <= 1'b1;
					// gateRegX <= testGate3X;
					// gateRegY <= testGate3Y;
					// if (gate3Done) gate3En <= 1'b0;
				// end
				// else if (currentGate == 4'd3) 
				// begin
					// colourReg <= 3'b100;
					// gate4En <= 1'b1;
					// gateRegX <= testGate4X;
					// gateRegY <= testGate4Y;
					// if (gate4Done) gate4En <= 1'b0;
				// end
				// else if (currentGate == 4'd4) 
				// begin
					// colourReg <= 3'b100;	
					// gate5En <= 1'b1;
					// gateRegX <= testGate5X;
					// gateRegY <= testGate5Y;
					// if (gate5Done) gate5En <= 1'b0;
				// end
				// else if (currentGate == 4'd5) 
				// begin
					// colourReg <= 3'b100;
					// gate6En <= 1'b1;
					// gateRegX <= testGate6X;
					// gateRegY <= testGate6Y;
					// if (gate6Done) gate6En <= 1'b0;
				// end
				// else if (currentGate == 4'd6) 
				// begin
					// colourReg <= 3'b100;
					// gate7En <= 1'b1;
					// gateRegX <= testGate7X;
					// gateRegY <= testGate7Y;
					// if (gate7Done) gate7En <= 1'b0;
				// end
				// else if (currentGate == 4'd7) 
				// begin
					// colourReg <= 3'b100;	
					// gate8En <= 1'b1;
					// gateRegX <= testGate8X;
					// gateRegY <= testGate8Y;
					// if (gate8Done) gate8En <= 1'b0;
				// end
				// else if (currentGate == 4'd8) 
				// begin
					// colourReg <= 3'b100;
					// gate9En <= 1'b1;
					// gateRegX <= testGate9X;
					// gateRegY <= testGate9Y;
					// if (gate9Done) gate9En <= 1'b0;
				// end
				// else if (currentGate == 4'd9) 
				// begin
					// colourReg <= 3'b100;
					// gate10En <= 1'b1;
					// gateRegX <= testGate10X;
					// gateRegY <= testGate10Y;
					// if (gate10Done) gate10En <= 1'b0;
				// end
			// end 
		end 
	end 
		
	assign oX = gateRegX;
	assign oY = gateRegY;
	assign oColour = colourReg;
//	assign gateWireX = gateRegX;
//	assign gateWireY = gateRegY;
	assign playerEn = (frameCounter == speedReg) ? 1'b0 : playerEnWire;

	assign oPlot = 1'b1;
	
	PinAuthenticaion U1 (.w0(Switches[9]), .w1(Switches[8]), .w2(Switches[7]), .w3(Switches[6]), .w4(Switches[5]), .w5(Switches[4]), .w6(Switches[3]), .w7(Switches[2]), .w8(Switches[1]), .w9(Switches[0]), .clk(iClock), .showPin(showPin), .z(playerWon), .led(LEDs));
	UI u1(.masterEnablewire(stopTimer), .CLOCK_50(iClock), .resetN(1'b1), .KEY(KEYS), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .counter(currentGate), .blackout(blackedOut), .canBuildWire(canBuildGate));
	Keyboard keyboard(.CLOCK_50(iClock), .PS2_DAT(PS2_Data), .PS2_CLK(PS2_Clock), .up(up), .down(down), .left(left), .right(right));
	RateDivider playerClock (.clk(iClock), .enable(playerEnWire));
	defparam playerClock.SPEED = 1666667;
	RateDivider blackoutTimer (.clk(iClock), .enable(enableOneSecond));
	defparam blackoutTimer.SPEED = 1;
	playerMem playerScreen(.address(addressOfPlayerWinScreen), .clock(iClock), .data(3'd0), .wren(1'b0), .q(colourPlayerWinScreen));
	computerMem computerScreen(.address(addressOfComputerWinScreen), .clock(iClock), .data(3'd0), .wren(1'b0), .q(colourComputerWinScreen));
endmodule


