`timescale 1ns / 1ns

module part5(
	input [9:0] SW,
	input [3:0] KEY,
	input CLOCK_50,
	output [9:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4, 
	output [6:0] HEX5
);
	
	wire inEdge;

	wire Run;
	wire Done;
	wire Resetn;
	wire [15:0] LEDs;
	reg [4:0] addr;
	
	assign Resetn = KEY[0];
	
	assign Run = SW[9];
	

	proc p1 (Resetn, CLOCK_50, Run, SW, Done, LEDs, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	
	//assign outputs
	assign LEDR[0] = Done;
	
	/* hex_digits h0(LEDs[3:0], HEX0);
	hex_digits h1(LEDs[7:4], HEX1);
	hex_digits h2(LEDs[11:8], HEX2);
	hex_digits h3(LEDs[15:12], HEX3); */
	
endmodule


