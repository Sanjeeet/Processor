
module Processor (
	clk_clk,
	reset_reset_n,
	done_writeresponsevalid_n,
	run_beginbursttransfer,
	ledr_export,
	vgar_export,
	vgag_export,
	vgab_export,
	vgahs_export,
	vgavs_export,
	vgablank_export,
	vgasync_export,
	vgaclk_export);	

	input		clk_clk;
	input		reset_reset_n;
	output		done_writeresponsevalid_n;
	input		run_beginbursttransfer;
	output	[9:0]	ledr_export;
	output	[9:0]	vgar_export;
	output	[9:0]	vgag_export;
	output	[9:0]	vgab_export;
	output		vgahs_export;
	output		vgavs_export;
	output		vgablank_export;
	output		vgasync_export;
	output		vgaclk_export;
endmodule
