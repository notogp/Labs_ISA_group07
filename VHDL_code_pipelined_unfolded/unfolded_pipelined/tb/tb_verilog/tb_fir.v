/***********************************************************************
 * Test bench for the 8-order FIR  12 bit coefficients.
 **********************************************************************/


module tb_fir ();


   wire CLK_i;
   wire RST_n_i;
   wire signed [11:0] DIN0_i;
  wire signed [11:0] DIN1_i;
  wire signed [11:0] DIN2_i;
   wire VIN_i;
   wire signed [11:0] H0_i;
   wire signed [11:0] H1_i;
   wire signed [11:0] H2_i;
   wire signed [11:0] H3_i;
   wire signed [11:0] H4_i;
   wire signed [11:0] H5_i;
   wire signed [11:0] H6_i;
   wire signed [11:0] H7_i;
   wire signed [11:0] H8_i;
   wire VOUT_i;
   wire signed [11:0] DOUT_i;
   
   integer error_count = 0;
   integer resC, res, a = 1;
   integer endL = 0;
   integer outfile0,outfile1; //file descriptors
   
	


   tb_fir_all DG(.CLK(CLK_i),
	             .RST_N(RST_n_i),
               .DIN0(DIN0_i),
				  .DIN1(DIN1_i),
                  .DIN2(DIN2_i),
               .VIN(VIN_i),
               .H0(H0_i),
               .H1(H1_i),
	 	           .H2(H2_i),
	 	           .H3(H3_i),
	 	           .H4(H4_i),
	 	           .H5(H5_i),
	 	           .H6(H6_i),
	 	           .H7(H7_i),
	 	           .H8(H8_i),
   	           .VOUT(VOUT_i),
	             .DOUT0(DOUT0_i),
				  .DOUT1(DOUT1_i),
                  .DOUT2(DOUT2_i));

   FIR_Filter UUT(.CLK(CLK_i),
	              .RST_n(RST_n_i),
                  .VIN(VIN_i),
	              .DIN0(DIN0_i),
				  .DIN1(DIN1_i),
                  .DIN2(DIN2_i),	 
			      .B0(H0_i),
	              .B1(H1_i),
               	  .B2(H2_i),
                  .B3(H3_i),
                  .B4(H4_i),
                  .B5(H5_i),
                  .B6(H6_i),
                  .B7(H7_i),
                  .B8(H8_i),
                  .VOUT(VOUT_i),
				  .DOUT0(DOUT0_i),
				  .DOUT1(DOUT1_i),
                  .DOUT2(DOUT2_i));




	
		

endmodule




		   
