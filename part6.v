module part6(
	input CLOCK_50,
	input [3:0] KEY,
	input[9:0] SW,
	output[9:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5
);

	wire [17:0] switch;

	assign switch = {8'b0, SW[9:0]};
	
	
	wire resetn;
	assign resetn = KEY[0];

	wire done;
	wire [6:0] HEX6, HEX7;

	processor p1(
			.clk_clk (CLOCK_50),                   //   clk.clk
			.done_writeresponsevalid_n (done), //  done.writeresponsevalid_n
			.hex30_HEX0 (HEX0),                // hex30.HEX0
			.hex30_HEX1 (HEX1),                //      .HEX1
			.hex30_HEX2 (HEX2),                //      .HEX2
			.hex30_HEX3 (HEX3),                //      .HEX3
			.hex74_HEX4 (HEX4),                // hex74.HEX4
			.hex74_HEX5 (HEX5),                //      .HEX5
			.hex74_HEX6 (HEX6),                //      .HEX6
			.hex74_HEX7 (HEX7),                //      .HEX7
			.leds_export (LEDR),               //  leds.export
			.reset_reset_n (resetn),             // reset.reset_n
			.run_beginbursttransfer (1'b1),    //   run.beginbursttransfer
			.sw_export (switch)                  //    sw.export
	);
		
	
endmodule	