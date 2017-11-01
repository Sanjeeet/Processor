module part7(
	input CLOCK_50,
	output[9:0] LEDR,
	output [9:0] VGA_R,
	output [9:0] VGA_G,
	output [9:0] VGA_B,
	output VGA_HS,
	output VGA_VS,
	output VGA_BLANK_N,
	output VGA_SYNC_N,
	output VGA_CLK 
	
);
	wire done;

	Processor p1(
		.clk_clk (CLOCK_50),                   //      clk.clk
		.done_writeresponsevalid_n (done), //     done.writeresponsevalid_n
		.ledr_export (LEDR),               //     ledr.export
		.reset_reset_n (1'b1),             //    reset.reset_n
		.run_beginbursttransfer (1'b1),    //      run.beginbursttransfer
		.vgab_export (VGA_B),               //     vgab.export
		.vgablank_export (VGA_BLANK_N),           // vgablank.export
		.vgaclk_export(VGA_CLK),             //   vgaclk.export
		.vgag_export (VGA_G),               //     vgag.export
		.vgahs_export (VGA_HS),              //    vgahs.export
		.vgar_export (VGA_R),               //     vgar.export
		.vgasync_export (VGA_SYNC_N),            //  vgasync.export
		.vgavs_export (VGA_VS)              //    vgavs.export
	);
	
endmodule