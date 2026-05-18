`timescale 1ns/1ps

module checkbit_calc_tb;

//Master inputs
reg clk_i;
reg rst_in;
//control Inputs
reg encoder_raw_data_ready_i;
reg [15:0] encoder_data_i;

//Outputs
wire [11:0] cw_position_counts_o;
wire [11:0] ccw_position_counts_o;
wire [1:0] checkbit_result_o;
wire data_ready_o;
wire checkBit_NoError_o;
wire checkBit_Error_o;

checkbit_calc uut(
	//Master inputs
	.clk_i(clk_i),
	.rst_in(rst_in),

	//Control Inputs
	.encoder_raw_data_ready_i(encoder_raw_data_ready_i),
	.encoder_data_i(encoder_data_i),

	 //Outputs
	.cw_position_counts_o(cw_position_counts_o),
	.ccw_position_counts_o(ccw_position_counts_o),
	.checkbit_result_o(checkbit_result_o),
	.data_ready_o(data_ready_o),
	.checkBit_NoError_o(checkBit_NoError_o),
	.checkBit_Error_o(checkBit_Error_o)
);

//Generate clock of 100MHz clock frequency
initial clk_i = 1'b0;
always #5 clk_i = ~clk_i;

initial begin

//Initialize input to DUT	
clk_i = 1'b0;
rst_in = 1'b0;
encoder_raw_data_ready_i = 1'b0;
encoder_data_i = 16'b0;

//Remove reset
#100 rst_in = 1'b1;

//@(posedge clk_i);
#100 encoder_data_i = 16'hBFF8;
encoder_raw_data_ready_i = 1'b1;
//repeat(4) @(posedge clk_i)
//@(posedge clk_i);
#100 encoder_raw_data_ready_i = 1'b0;
//repeat(4) @(posedge clk_i);

#100 encoder_data_i = 16'h7FF4;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

#100 encoder_data_i = 16'h3FF0;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

#100 encoder_data_i = 16'hBFEC;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

#100 encoder_data_i = 16'hFFE8;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

#100 encoder_data_i = 16'h3FE4;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

#100 encoder_data_i = 16'h7FE0;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

#100 encoder_data_i = 16'h7FDC;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

#100 encoder_data_i = 16'h3FD8;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

#100 encoder_data_i = 16'hFFD4;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

#100 encoder_data_i = 16'hBFD0;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

#100 encoder_data_i = 16'h3FCC;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

#100 encoder_data_i = 16'h7FC8;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

#100 encoder_data_i = 16'hBFC4;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

#100 encoder_data_i = 16'hFFC0;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

#100 encoder_data_i = 16'hBFBC;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

//Incorrect Checkbit Data
#100 encoder_data_i = 16'hBFBD;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;

#100 encoder_data_i = 16'hAFBC;
encoder_raw_data_ready_i = 1'b1;
#100 encoder_raw_data_ready_i = 1'b0;
end 

//Monitor each input and output
initial begin
$monitor("Time=%0t | rst_in=%b encoder_raw_data_ready_i=%b encoder_data_i=%h | data_ready_o=%b  checkbit_result_o=%b cw_position_counts_o =%h ccw_position_counts_o = %h", $time, rst_in, encoder_raw_data_ready_i, encoder_data_i, data_ready_o, checkbit_result_o, cw_position_counts_o, ccw_position_counts_o);

end

//Waveform dump
initial begin
  $dumpfile("sim/waveforms/checkbit_calc.vcd");  // MUST match Makefile
  $dumpvars(0, checkbit_calc_tb);

  #9000 $finish;
end

endmodule
