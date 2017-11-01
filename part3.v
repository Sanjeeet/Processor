`timescale 1ns / 1ns

module part3(
	input [9:0] SW,
	input [3:0] KEY,
	input CLOCK_50,
	output [9:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3

);
	
	wire inEdge;

	wire Run;
	wire Done;
	wire Resetn;
	wire [15:0] LEDs;
	reg [4:0] addr;
	
	assign Resetn = KEY[0];
	
	assign Run = SW[9];
	

	
	
	proc p1 (Resetn, CLOCK_50, Run, Done, LEDs);
	
	
	//assign outputs
	assign LEDR[0] = Done;
	
	hex_digits h0(LEDs[3:0], HEX0);
	hex_digits h1(LEDs[7:4], HEX1);
	hex_digits h2(LEDs[11:8], HEX2);
	hex_digits h3(LEDs[15:12], HEX3);
	
endmodule


module hex_digits(x, hex_LEDs);
	input [3:0] x;
	output [6:0] hex_LEDs;
	
	assign hex_LEDs[0] = 	(~x[3] & ~x[2] & ~x[1] & x[0]) |
							(~x[3] & x[2] & ~x[1] & ~x[0]) |
							(x[3] & x[2] & ~x[1] & x[0]) |
							(x[3] & ~x[2] & x[1] & x[0]);
	assign hex_LEDs[1] = 	(~x[3] & x[2] & ~x[1] & x[0]) |
							(x[3] & x[1] & x[0]) |
							(x[3] & x[2] & ~x[0]) |
							(x[2] & x[1] & ~x[0]);
	assign hex_LEDs[2] = 	(x[3] & x[2] & ~x[0]) |
							(x[3] & x[2] & x[1]) |
							(~x[3] & ~x[2] & x[1] & ~x[0]);
	assign hex_LEDs[3] =	(~x[3] & ~x[2] & ~x[1] & x[0]) | 
							(~x[3] & x[2] & ~x[1] & ~x[0]) | 
							(x[2] & x[1] & x[0]) | 
							(x[3] & ~x[2] & x[1] & ~x[0]);
	assign hex_LEDs[4] = 	(~x[3] & x[0]) |
							(~x[3] & x[2] & ~x[1]) |
							(~x[2] & ~x[1] & x[0]);
	assign hex_LEDs[5] = 	(~x[3] & ~x[2] & x[0]) | 
							(~x[3] & ~x[2] & x[1]) | 
							(~x[3] & x[1] & x[0]) | 
							(x[3] & x[2] & ~x[1] & x[0]);
	assign hex_LEDs[6] = 	(~x[3] & ~x[2] & ~x[1]) | 
							(x[3] & x[2] & ~x[1] & ~x[0]) | 
							(~x[3] & x[2] & x[1] & x[0]);
	
endmodule
