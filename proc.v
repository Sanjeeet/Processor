`timescale 1ns / 1ns // `timescale time_unit/time_precision


module proc (

	input Resetn, 
	input Clock, 
	input Run, 
	output reg Done, 
	output [31:0] Addr, 
	input [31:0] DIN, 
	output wire [31:0] DOUT, 
	output [3:0] byteenable, 
	input waitrequest, 
	output write, 
	output read,
	output [31:0] r1
);
	
	assign byteenable = 4'b1111;
	
	wire[31:0] BusWires;
	

	
	//declare variables
	reg[7:0] Rin; // control signal for loading register(i.e. Rin[0] = 1 then load R0 register)
	wire[8:0] IR; // instruction register
	wire [2:0] I; // store instruction
	wire [2:0] Tstep_Q;
	wire [7:0] Xreg, Yreg;
	
	//control signals
	reg Ain, IRin, RYout, RXin, DINout, RXout, Gin, Gout, AddSub, Addrin, incr_pc, Doutin, W_D, SWout, R_D;
	reg [7:0] Rout;
	
	//reg Clear;
	reg Clear;
	//assign Clear = Done;
	
	wire[31:0] R0, R1, R2, R3, R4, R5, R6, R7, Areg, Greg, ALUout, LEDs, DINtoMux, Addr1;
	
	assign r1 = R1;
	
	wire g_neq_0;
	assign g_neq_0 = (Greg != 32'b0);
	
	upcount Tstep (Clear, Clock, Tstep_Q, Resetn, waitrequest);
	
	assign I = IR[8:6];
	
	dec3to8 decX (IR[5:3], 1'b1, Xreg);
	dec3to8 decY (IR[2:0], 1'b1, Yreg);
	always @(*) begin
		
			// specify initial values
			Rout = 8'b0;
			Rin = 8'b0;
			Ain = 0;
			Gin = 0;
			AddSub = 0;
			Done = 0;
			Gout = 0;
			DINout = 0;
			Clear = 1;
			IRin = 0;
			Addrin = 0;
			incr_pc = 0;
			Doutin = 0;
			W_D = 0;
			SWout = 0;
			R_D = 0;
			
			case (Tstep_Q)
				3'b000: begin // store DIN in IR in time step 0
					if (Run) begin
						Addrin = 1'b1;
						Rout = 8'b10000000;
						Clear = 0;
						R_D = 1;
						
					end 
				end
				
				3'b001: begin
					Clear = 0;
					if (waitrequest == 1)
						R_D = 1; //keep the read high if waitrequested
					else begin
						IRin = 1;
						incr_pc = 1;
					end
					
				end
				3'b010: begin //define signals in time step 2
					case (I)
						3'b000: begin //mv
							Rout = Yreg;
							Rin = Xreg;
							Done = 1'b1;
						end
						3'b001: begin //mvi	
							Addrin = 1'b1;
							Rout = 8'b10000000;
							Clear = 0;
							R_D = 1;	
							
						end
						3'b010: begin //add
							Rout = Xreg;
							Ain = 1'b1;
							Clear = 0;
						end
						3'b011: begin //sub
							Rout = Xreg;
							Ain = 1'b1;
							Clear = 0;
						end
						3'b100: begin //ld
							Rout = Yreg;
							Addrin = 1'b1;
							R_D = 1;
							Clear = 0;
						end
						3'b101: begin //st -- load address into ADDR register
							Rout = Yreg;
							Addrin = 1'b1;
							Clear = 0;
						end
						3'b110: begin //mvnz
							Rout = Yreg;
							if (g_neq_0)
								Rin = Xreg;
							Done = 1'b1;
						end
					endcase
				end
				3'b011: begin//define signals in time step 3
					case (I) 
						3'b001: begin //mvi
							if (waitrequest) begin
								R_D = 1;
								Clear = 0;
							end
							else begin
								DINout = 1'b1;
								Rin = Xreg;
								Done = 1'b1;
								incr_pc = 1;
							end
						end
						
						3'b010: begin //add
							Rout = Yreg;
							AddSub = 1'b0;
							Gin = 1'b1;
							Clear = 0;
						end
						
						3'b011: begin //sub
							Rout = Yreg;
							AddSub = 1'b1;
							Gin = 1'b1;
							Clear = 0;
						end
						3'b100: begin //ld
							if (waitrequest) begin
								R_D = 1;
								Clear = 0;
							end
							else begin
								DINout = 1'b1;
								Rin = Xreg;
								Done = 1'b1;
							end
						end	
						3'b101: begin //st -- load data into DOUT register 
							Doutin = 1;
							Rout = Xreg;
							W_D = 1;
							Clear = 0;
						end
					endcase
				end
				3'b100: begin //define signals in time step 4
					case (I)
						
						3'b010: begin //add
							Gout = 1'b1;
							Rin = Xreg;
							Done = 1'b1;
						end
						
						3'b011: begin //sub
							Gout = 1'b1;
							Rin = Xreg;
							Done = 1'b1;
						end
						3'b101: begin //st -- store into the memory 
							
							Clear = 0;
													
						end
					endcase
					
				end
				3'b101: begin //define signals in time step 4
					case (I)
						3'b101: begin //st -- store into the memory 
							if (waitrequest == 1) begin		
								W_D = 1;
								Clear = 0;
							end
							else
								Done = 1;
						end
					endcase
					
				end
			endcase
	end	
	
	
	

	
	regn reg0(BusWires, Rin[0], Clock,Resetn, R0);
	regn reg1(BusWires, Rin[1], Clock,Resetn, R1);
	regn reg2(BusWires, Rin[2], Clock,Resetn, R2);
	regn reg3(BusWires, Rin[3], Clock,Resetn, R3);
	regn reg4(BusWires, Rin[4], Clock,Resetn, R4);
	regn reg5(BusWires, Rin[5], Clock,Resetn, R5);
	regn reg6(BusWires, Rin[6], Clock,Resetn, R6);
	//regn reg7(BusWires, Rin[7], Clock,Resetn, R7);
	
	Counter reg7(BusWires, Rin[7], incr_pc, Clock, Resetn, R7);
	
	//memory related registers
	regn ADDR1(BusWires, Addrin, Clock, Resetn, Addr1);
	regn DOUT1(BusWires, Doutin, Clock, Resetn, DOUT);
	
	assign Addr = Addr1 << 2;
	

	defparam W.n = 1;
	regn W(W_D, 1'b1, Clock, Resetn, write);
	defparam R.n = 1;
	regn R(R_D, 1'b1, Clock, Resetn, read);
	
	regn regA(BusWires, Ain, Clock, Resetn, Areg);
	
	regn regG(ALUout, Gin, Clock, Resetn, Greg);
	
	
	//n_port
	//port_n p1(SW, DIN, SWout, DINtoMux);
	
	
	//ALU
	ALU ALUinst(Areg, BusWires, AddSub, ALUout);
	
	mux10to1 multiplexer (DIN, R0, R1, R2, R3, R4, R5, R6, R7, Greg, Rout, Gout, DINout, BusWires);
	
	defparam instr.n = 9;
	regn instr(DIN[15:7], IRin, Clock, Resetn, IR);
		
	wire wren, LED_in, hex0_in, hex1_in, hex2_in, hex3_in, hex4_in, hex5_in;
	assign wren = (~(Addr[15] | Addr[14] | Addr[13] | Addr[12]) & write); 
	
	assign LED_in = (~(Addr[15] | Addr[14] | Addr[13] | ~Addr[12]) & write); 
	
	assign hex0_in = ((Addr[15:0] == 16'h2007) && write);
	assign hex1_in = ((Addr[15:0] == 16'h2006) && write);
	assign hex2_in = ((Addr[15:0] == 16'h2005) && write);
	assign hex3_in = ((Addr[15:0] == 16'h2004) && write);
	assign hex4_in = ((Addr[15:0] == 16'h2003) && write);
	assign hex5_in = ((Addr[15:0] == 16'h2002) && write);
	/*
	//LEDs register
	defparam LEDReg.n = 16;
	regn LEDReg(Dout, LED_in, Clock, Resetn, LEDs);
	
	//hex registers
	seg7_scroll hex0(Dout[6:0], hex0_in, Clock, Resetn, HEX0);
	seg7_scroll hex1(Dout[6:0], hex1_in, Clock, Resetn, HEX1);
	seg7_scroll hex2(Dout[6:0], hex2_in, Clock, Resetn, HEX2);
	seg7_scroll hex3(Dout[6:0], hex3_in, Clock, Resetn, HEX3);
	seg7_scroll hex4(Dout[6:0], hex4_in, Clock, Resetn, HEX4);
	seg7_scroll hex5(Dout[6:0], hex5_in, Clock, Resetn, HEX5);
	
	
	
	assign out = LEDs;
	
	//memory
	memory m1(
	Addr[6:0],
	Clock,
	Dout,
	wren,
	DIN);
	*/
	
	//instantiate other registers and the adder/subtracter unit
	//define the bus
endmodule

module port_n(
	input [9:0] SW,
	input [15:0] DINmem,
	input selectSW,
	output reg[15:0] DIN

);
	
	always@(*) begin
		if (selectSW)
			DIN = {6'b0, SW[9:0]};
		else
			DIN[15:0] = DINmem[15:0];
		
	end
endmodule

module seg7_scroll(
	input [6:0] data,
	input hex_in, 
	input Clock,
	input Resetn,
	output reg [6:0] hex
	
);
	wire [6:0]hexout;
	hex_digits r11(data[3:0], hexout);

	always@(posedge Clock or negedge Resetn) begin
		if (!Resetn) begin
			hex <= 7'b1000000;
		end
		else if (hex_in) begin
			hex <= hexout;
		end
	end

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


module Counter(
	input [31:0] DIN,
	input loadEnable,
	input counterEnable,
	input Clock,
	input Resetn,
	output reg [31:0] Dout
);
	always@(posedge Clock or negedge Resetn) begin
		if (!Resetn)
			Dout <= 32'b0;
		else if (loadEnable)
			Dout <= DIN;
		else if (counterEnable)
			Dout <= Dout + 1;
	end

endmodule

//10 to 1 multiplexer
module mux10to1 (
	input [31:0] DIN,
	input [31:0] R0,
	input [31:0] R1,
	input [31:0] R2,
	input [31:0] R3,
	input [31:0] R4,
	input [31:0] R5,
	input [31:0] R6,
	input [31:0] R7,
	input [31:0] Greg,
	
	input [7:0] Rout,
	input Gout,
	input DINout,
	
	output reg [31:0] BusWire

); 

	always@(*) begin
		if (DINout)	
			BusWire = DIN;
		else if (Rout[0])
			BusWire = R0;
		else if (Rout[1])
			BusWire = R1;
		else if (Rout[2])
			BusWire = R2;
		else if (Rout[3])
			BusWire = R3;
		else if (Rout[4])
			BusWire = R4;
		else if (Rout[5])
			BusWire = R5;
		else if (Rout[6])
			BusWire = R6;
		else if (Rout[7])
			BusWire = R7;
		else if (Gout)
			BusWire = Greg;
		else 
			BusWire = 32'b0;
	end
	


endmodule



//need ALU
module ALU (
	input [31:0] a,
	input [31:0] b,
	input AddSub,
	output reg [31:0] ALUout

);

	always@(*) begin
		if (!AddSub)
			ALUout = a + b;
		else
			ALUout = a - b;
	
	end


endmodule






module upcount(Clear, Clock, Q, Resetn, waitrequest);
	input Clear, Clock, Resetn, waitrequest;
	output [2:0] Q;
	reg [2:0] Q;
	
	always @(posedge Clock) begin
		if (Clear || !Resetn)
			Q <= 3'b0;
		else if (!waitrequest)
			Q <= Q + 1'b1; //only increment when waitrequest is low
	end
	
endmodule

module dec3to8(W, En, Y);
	input [2:0] W;
	input En;
	output [7:0] Y;
	reg [7:0] Y;
	
	
	always @(*) begin
	
		if (En == 1) begin
			case (W)
				3'b000: Y = 8'b00000001;
				3'b001: Y = 8'b00000010;
				3'b010: Y = 8'b00000100;
				3'b011: Y = 8'b00001000;
				3'b100: Y = 8'b00010000;
				3'b101: Y = 8'b00100000;
				3'b110: Y = 8'b01000000;
				3'b111: Y = 8'b10000000;
			endcase
		end
		else
			Y = 8'b00000000;
	end
	
endmodule


module regn(R, Rin, Clock, Resetn, Q);
	parameter n = 32;
	input [n-1:0] R;
	input Rin, Clock, Resetn;
	output [n-1:0] Q;
	reg [n-1:0] Q;
	
	always @(posedge Clock or negedge Resetn)
		if (!Resetn)
			Q <= 0;
		
		else if (Rin)
			Q <= R;
endmodule

