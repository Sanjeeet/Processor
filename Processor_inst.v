	Processor u0 (
		.clk_clk                   (<connected-to-clk_clk>),                   //      clk.clk
		.reset_reset_n             (<connected-to-reset_reset_n>),             //    reset.reset_n
		.done_writeresponsevalid_n (<connected-to-done_writeresponsevalid_n>), //     done.writeresponsevalid_n
		.run_beginbursttransfer    (<connected-to-run_beginbursttransfer>),    //      run.beginbursttransfer
		.ledr_export               (<connected-to-ledr_export>),               //     ledr.export
		.vgar_export               (<connected-to-vgar_export>),               //     vgar.export
		.vgag_export               (<connected-to-vgag_export>),               //     vgag.export
		.vgab_export               (<connected-to-vgab_export>),               //     vgab.export
		.vgahs_export              (<connected-to-vgahs_export>),              //    vgahs.export
		.vgavs_export              (<connected-to-vgavs_export>),              //    vgavs.export
		.vgablank_export           (<connected-to-vgablank_export>),           // vgablank.export
		.vgasync_export            (<connected-to-vgasync_export>),            //  vgasync.export
		.vgaclk_export             (<connected-to-vgaclk_export>)              //   vgaclk.export
	);

