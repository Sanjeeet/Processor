module LDA_Peripheral (
	input avs_s1_chipselect,
	input [2:0] avs_s1_address,
	input avs_s1_read,
	input avs_s1_write,
	input [31:0] avs_s1_writedata,
	output reg [31:0] avs_s1_readdata,
	output reg avs_s1_waitrequest,
	output [9:0] coe_ledr_export_LEDR,
	output [9:0] coe_vgar_export_VGA_R,
	output [9:0] coe_vgag_export_VGA_G,
	output [9:0] coe_vgab_export_VGA_B,
	output coe_vgahs_export_VGA_HS,
	output coe_vgavs_export_VGA_VS,
	output coe_vgablank_export_VGA_BLANK_N,
	output coe_vgasync_export_VGA_SYNC_N,
	output coe_vgaclk_export_VGA_CLK,
	input csi_clockreset_clk,
	input csi_clockreset_reset_n,
	output  y00
);

//state model
	reg mode, status, go;
	reg [8:0] x0, x1;
	reg [7:0] y0, y1;
	reg[3:0] colour;
	wire done;
	
	
	//write_data
	always @(posedge csi_clockreset_clk or negedge csi_clockreset_reset_n) begin
		
		//reset signal
		if (!csi_clockreset_reset_n)begin
			mode <= 0;
			status <= 0;
			go <= 0;
			avs_s1_waitrequest <= 1'b0;	
		end
		
		//write signal
		else if (avs_s1_write) begin
			if (done) begin
				go <= 0;
				avs_s1_waitrequest <= 1'b0;	
			end
			
			
			// mode selection
			else if (avs_s1_address == 3'b000) begin
				//only update if chipselect is asserted
				//if (avs_s1_chipselect == 1'b1) begin
					if (avs_s1_writedata[0] == 1'b0) begin
						mode <= 0;
						avs_s1_waitrequest <= 1'b0;	
					end
					else begin
						mode <= 1;
						avs_s1_waitrequest <= 1'b0;	
					end
				//end
			end
			
			//starting position
			else if (avs_s1_address == 3'b011) begin
				//if (avs_s1_chipselect == 1'b1) begin
					x0[8:0] <= avs_s1_writedata[8:0];
					y0[7:0] <= avs_s1_writedata[16:9];
				//end
			end
			
			//ending position
			else if (avs_s1_address == 3'b100) begin
				//if (avs_s1_chipselect == 1'b1) begin
					x1[8:0] <= avs_s1_writedata[8:0];
					y1[7:0] <= avs_s1_writedata[16:9];
				//end
			end
			
			//colour
			else if (avs_s1_address == 3'b101) begin
				//if (avs_s1_chipselect == 1'b1) begin
					colour <= avs_s1_writedata[2:0];
				//end
			end
			
			//go signal
			else if (avs_s1_address == 3'b010) begin
				//if (avs_s1_chipselect == 1'b1) begin
				
				go <= 1;
				status <= 0;
				if (mode == 0) 
					avs_s1_waitrequest <= 1'b1;
				
				//end
			end
			
		end
		
		//read status register
		else if (avs_s1_read) begin
			if (done) begin
				go <= 0;
				avs_s1_waitrequest <= 1'b0;	
			end
			if (avs_s1_chipselect == 1'b1) begin
				if (avs_s1_address == 3'b001)
					avs_s1_readdata = {31'b0, done};
			end
		end
//		else if (done) begin
//			go <= 0;
//			status <= 1;
//		end
	end
 	wire plot;
	wire [8:0] to_VGA_x;	
	wire [7:0] to_VGA_y;
	

	//LDA
 	LDA l1( 
	x0, x1,
	y0, y1,
	go, csi_clockreset_clk, csi_clockreset_reset_n,
	done,
	to_VGA_x,	
	to_VGA_y,
	plot); 
	assign y00 = done;
// 	LDA l1( 
//	9'd0, 9'd10,
//	8'd0, 8'd10,
//	1, csi_clockreset_clk, csi_clockreset_reset_n,
//	done,
//	to_VGA_x,	
//	to_VGA_y,
//	plot); 
	
	//VGA
	/*
	vga_adapter VGA(
				.resetn(csi_clockreset_reset_n),
				.clock(csi_clockreset_clk),
				.colour(colour),
				.x(to_VGA_x),
				.y(to_VGA_y),
				.plot(plot),
				.VGA_R(coe_vgar_export_VGA_R),
				.VGA_G(coe_vgag_export_VGA_G),
				.VGA_B(coe_vgab_export_VGA_B),
				.VGA_HS(coe_vgahs_export_VGA_HS),
				.VGA_VS(coe_vgavs_export_VGA_VS),
				.VGA_BLANK(coe_vgablank_export_VGA_BLANK_N),
				.VGA_SYNC(coe_vgasync_export_VGA_SYNC_N),
				.VGA_CLK(coe_vgaclk_export_VGA_CLK));
			defparam VGA.RESOLUTION = "320x240";				
			defparam VGA.MONOCHROME = "FALSE";
			defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;	
			defparam VGA.BACKGROUND_IMAGE = "background.mif";
	*/

endmodule