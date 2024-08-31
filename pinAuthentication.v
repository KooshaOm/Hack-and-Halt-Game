// ===========================================================================
//               Implementations of Modules Used for Endgame Logic
// ===========================================================================


module top (input [9:0] SW, input CLOCK_50, output[9:0] LEDR);
	wire done = 1'b0;
	wire show = 1'b1;
	PinAuthenticaion U1 (.w0(SW[9]), .w1(SW[8]), .w2(SW[7]), .w3(SW[6]), .w4(SW[5]), .w5(SW[4]), .w6(SW[3]), .w7(SW[2]), .w8(SW[1]), .w9(SW[0]), .clk(CLOCK_50), .showPin(show), .z(done), .led(LEDR[9:0]));
endmodule



module PinAuthenticaion
(
    input w0,
    input w1,
    input w2,
    input w3,
    input w4,
    input w5,
    input w6,
    input w7,
    input w8,
    input w9,
    input clk,
    input showPin,
    output z,
    output wire [9:0] led
);
reg [3:0] counter = 4'b0000;
reg stopShowing = 1'b0;
wire increment;
reg [9:0] ledr; 

assign led[0] = ledr[0];
assign led[1] = ledr[1];
assign led[2] = ledr[2];
assign led[3] = ledr[3];
assign led[4] = ledr[4];
assign led[5] = ledr[5];
assign led[6] = ledr[6];
assign led[7] = ledr[7];
assign led[8] = ledr[8];
assign led[9] = ledr[9];


RateDivider #(.SPEED(1)) U0 (.clk(clk), .enable(increment));

always @ (posedge clk) begin
    if(increment) begin
		counter <= counter + 1'b1;
	 end
	 
	 if(showPin) begin
        if(counter < 4'b1100) begin
            ledr[0] <= 1'b1;
            ledr[1] <= 1'b1;
            ledr[2] <= 1'b1;
            ledr[3] <= 1'b0;
            ledr[4] <= 1'b0;
            ledr[5] <= 1'b1;
            ledr[6] <= 1'b0;
            ledr[7] <= 1'b1;
            ledr[8] <= 1'b0;
            ledr[9] <= 1'b1;
        end
		  else if (counter == 4'b1100) begin
				stopShowing <= 1'b1;
		  end
		  if(stopShowing) begin
				ledr[0] <= 1'b0;
            ledr[1] <= 1'b0;
            ledr[2] <= 1'b0;
            ledr[3] <= 1'b0;
            ledr[4] <= 1'b0;
            ledr[5] <= 1'b0;
            ledr[6] <= 1'b0;
            ledr[7] <= 1'b0;
            ledr[8] <= 1'b0;
            ledr[9] <= 1'b0;
		  end
    end
end



// Finite State Machine (FSM) 

reg reset = 1'b0;
reg [3:0] y, Y;

localparam [3:0] A = 4'b0000,
                 B = 4'b0001,
                 C = 4'b0010,
                 D = 4'b0011,
                 E = 4'b0100,
                 F = 4'b0101,
                 G = 4'b0110,
                 H = 4'b0111,
                 I = 4'b1000,
                 J = 4'b1001,
                 K = 4'b1010;


    always @ (*) begin
        case(y)
            
            A:
            begin 
                if(w0 == 1'b1) begin
                    Y = B;
                end
                else begin
                    Y = A;
                end
            end

            B:
            begin 
                if(w0 == 1'b0) begin
                    Y = A;
                end
                else begin 
                    if(w1 == 1'b1) begin
                        Y = B;
                    end
                    else begin
                        Y = C;
                    end
                end
            end

            C:
            begin

                if(w0 == 1'b0) begin
                    Y = A;
                end
                else begin 
                    if(w1 == 1'b1) begin
                        Y = B;
                    end
                    else begin
                        if(w2 == 1'b1) begin
                            Y = D;
                        end
                        else begin
                            Y = C;
                        end
                    end
                end 

            end

            D:
            begin

                if(w0 == 1'b0) begin
                    Y = A;
                end
                else begin 
                    if(w1 == 1'b1) begin
                        Y = B;
                    end
                    else begin
                        if(w2 == 1'b0) begin
                            Y = C;
                        end
                        else begin
                            if(w3 == 1'b0) begin
                                Y = E;
                            end
                            else begin
                                Y = D;
                            end
                        end
                    end
                end  

            end

            E:
            begin
                
                if(w0 == 1'b0) begin
                    Y = A;
                end
                else begin 
                    if(w1 == 1'b1) begin
                        Y = B;
                    end
                    else begin
                        if(w2 == 1'b0) begin
                            Y = C;
                        end
                        else begin
                            if(w3 == 1'b1) begin
                                Y = D;
                            end
                            else begin
                                if(w4 == 1'b1) begin
                                    Y = F;
                                end
                                else begin
                                    Y = E; 
                                end
                            end
                        end
                    end
                end  
            end

            F:
            begin

                if(w0 == 1'b0) begin
                    Y = A;
                end
                else begin 
                    if(w1 == 1'b1) begin
                        Y = B;
                    end
                    else begin
                        if(w2 == 1'b0) begin
                            Y = C;
                        end
                        else begin
                            if(w3 == 1'b1) begin
                                Y = D;
                            end
                            else begin
                                if(w4 == 1'b0) begin
                                    Y = E;
                                end
                                else begin
                                    if(w5 == 1'b0) begin
                                        Y = G;
                                    end
                                    else begin
                                        Y = F;
                                    end
                                end
                            end
                        end
                    end
                end  
            end

            G:
            begin 

                if(w0 == 1'b0) begin
                    Y = A;
                end
                else begin 
                    if(w1 == 1'b1) begin
                        Y = B;
                    end
                    else begin
                        if(w2 == 1'b0) begin
                            Y = C;
                        end
                        else begin
                            if(w3 == 1'b1) begin
                                Y = D;
                            end
                            else begin
                                if(w4 == 1'b0) begin
                                    Y = E;
                                end
                                else begin
                                    if(w5 == 1'b1) begin
                                        Y = F;
                                    end
                                    else begin
                                        if(w6 == 1'b0) begin
                                            Y = H;
                                        end
                                        else begin
                                            Y = G;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end  
            end

            H:
            begin 

                if(w0 == 1'b0) begin
                    Y = A;
                end
                else begin 
                    if(w1 == 1'b1) begin
                        Y = B;
                    end
                    else begin
                        if(w2 == 1'b0) begin
                            Y = C;
                        end
                        else begin
                            if(w3 == 1'b1) begin
                                Y = D;
                            end
                            else begin
                                if(w4 == 1'b0) begin
                                    Y = E;
                                end
                                else begin
                                    if(w5 == 1'b1) begin
                                        Y = F;
                                    end
                                    else begin
                                        if(w6 == 1'b1) begin
                                            Y = G;
                                        end
                                        else begin
                                            if(w7 == 1'b1) begin
                                                Y = I;
                                            end
                                            else begin
                                                Y = H;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end  
            end

            I:
            begin 

                if(w0 == 1'b0) begin
                    Y = A;
                end
                else begin 
                    if(w1 == 1'b1) begin
                        Y = B;
                    end
                    else begin
                        if(w2 == 1'b0) begin
                            Y = C;
                        end
                        else begin
                            if(w3 == 1'b1) begin
                                Y = D;
                            end
                            else begin
                                if(w4 == 1'b0) begin
                                    Y = E;
                                end
                                else begin
                                    if(w5 == 1'b1) begin
                                        Y = F;
                                    end
                                    else begin
                                        if(w6 == 1'b1) begin
                                            Y = G;
                                        end
                                        else begin
                                            if(w7 == 1'b0) begin
                                                Y = H;
                                            end
                                            else begin
                                                if(w8 == 1'b1) begin
                                                    Y = J;
                                                end
                                                else begin
                                                    Y = I;
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end  
            end

            J:
            begin 

                if(w0 == 1'b0) begin
                    Y = A;
                end
                else begin 
                    if(w1 == 1'b1) begin
                        Y = B;
                    end
                    else begin
                        if(w2 == 1'b0) begin
                            Y = C;
                        end
                        else begin
                            if(w3 == 1'b1) begin
                                Y = D;
                            end
                            else begin
                                if(w4 == 1'b0) begin
                                    Y = E;
                                end
                                else begin
                                    if(w5 == 1'b1) begin
                                        Y = F;
                                    end
                                    else begin
                                        if(w6 == 1'b1) begin
                                            Y = G;
                                        end
                                        else begin
                                            if(w7 == 1'b0) begin
                                                Y = H;
                                            end
                                            else begin
                                                if(w8 == 1'b0) begin
                                                    Y = I;
                                                end
                                                else begin
                                                    // test = 1'b1;
                                                    if(w9 == 1'b0) begin
                                                        Y = K;
                                                    end
                                                    else begin
                                                        Y = J;
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end  
            end

        endcase
    end

    always @ (posedge clk) begin
        if(!showPin) begin
            y <= A;
        end
        else begin
            y <= Y;
        end
    end

    assign z = (y == K);
endmodule

