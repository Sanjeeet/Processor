`timescale 1ns / 1ns

module part2(
	input [9:0] SW,
	input [3:0] KEY,
	output [9:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5

);
	
	wire inEdge;

	wire [15:0] BusWires;
	wire PClock;
	wire MClock;
	wire Run;
	wire Done;
	wire Resetn;
	wire [3:0] r0;
	wire [15:0] DIN;
	reg [4:0] addr;
	
	assign Resetn = KEY[0];
	assign MClock = ~KEY[1];
	assign PClock = ~KEY[2];
	assign Run = SW[9];
	
	assign inEdge = ~KEY[2];
	
	
	
	
	//counter
	always@(posedge MClock or negedge Resetn) begin
		if (!Resetn)
			addr <= 0;
		else
			addr <= addr + 1'b1;
	end
	
	//instantiate memory
	memory m1(
		addr,
		MClock,
		DIN);
	
	
	
	
	
	
	proc p1(DIN, Resetn, PClock, Run, Done, BusWires, r0);
	
	
	//assign outputs
	assign LEDR[0] = Done;
	
	hex_digits h0(BusWires[3:0], HEX0);
	hex_digits h1(BusWires[7:4], HEX1);
	hex_digits h2(BusWires[11:8], HEX2);
	hex_digits h3(BusWires[15:12], HEX3);
	hex_digits h4(r0, HEX4);
	hex_digits h5(addr[3:0], HEX5);
	
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
