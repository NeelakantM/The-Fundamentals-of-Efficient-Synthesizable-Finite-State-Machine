module checkbit_calc(
//Master inputs
input clk_i,
input rst_in,

//Control Inputs
input encoder_raw_data_ready_i,
input [15:0] encoder_data_i,

//Outputs 
output reg [11:0] cw_position_counts_o,
output reg [11:0] ccw_position_counts_o,
output reg [1:0] checkbit_result_o,
output reg data_ready_o,
output reg checkBit_NoError_o,
output reg checkBit_Error_o
);

//Internal Constants
parameter integer ccw_to_cw_position_conversion_c = 4095;
localparam integer ENCODER_VALUE_ST = 0,
		   CHECK_BIT_CALC_ST = 1,
		   VALIDATE_RESULT_ST = 2;

reg [2:0] state, nextstate;
reg encoder_raw_data_ready_rs;
reg [1:0] checkbit_result_ready_rs;
reg [11:0] data_rs;

//Fall egde encoder data ready detection
wire fe_encoder_raw_data_ready_rs;

//1st always block - Sequential always block
//state assignment always block, uses non-blocking
//assigment. Under reset, state is initialized 
//to "encoder_value_st". Otherwise state follows
//nextstate.
always@(posedge clk_i or negedge rst_in) begin
	if(!rst_in) begin
	       	state <= 3'b001;
		encoder_raw_data_ready_rs <= 1'b0;
	end 
	else begin
		state <= nextstate;
		//For falling edge detection,encoder_raw_data_ready_i is 
		//delayed by a clock
		encoder_raw_data_ready_rs <= encoder_raw_data_ready_i;
	end
end 

//Find falling edge of encoder_data_ready input
assign  fe_encoder_raw_data_ready_rs = ((~encoder_raw_data_ready_i) & (encoder_raw_data_ready_rs));

//Function to compute the checkbit result
function [1:0] CheckbitResult;
	input [15: 0] data;     //Input received data
	reg odd_parity;		//XOR of odd position bits in data
	reg even_parity;	//XOR of even position bits in data
	reg odd_checkbit;	//Final odd checkbit after XORing with received odd parity
	reg even_checkbit;	//Final even checkbit after XORing with received eveb parity
	integer i;
	begin
		//Initialization of signals used in the function
		odd_parity = 1'b0;
                even_parity = 1'b0;
		odd_checkbit = 1'b0;
		even_checkbit = 1'b0;
		
		//XORing of odd position bits in received data
		for (i = 0; i <= 6; i=i+1)
			odd_parity = (data[i * 2 + 1] ^ odd_parity);

		//XORing of even position bits in received data
                for (i = 0; i <= 6; i=i+1)
                        even_parity = (data[i * 2] ^ even_parity);

		//Odd Parity final check
		odd_checkbit  = ((!odd_parity) ^ data[15]);
		//Even Parity final check
		even_checkbit = ((!even_parity) ^ data[14]);
		
		//Concate even and odd parity
		CheckbitResult = {odd_checkbit,even_checkbit};
	end 
endfunction


//2nd always block - combination always block
//1. Manage state transition
//2. Uses blocking assignments
always@(*) begin
	//Default conditions
        nextstate = 3'b000;

	case(1'b1)
		state[ENCODER_VALUE_ST]: begin
		     //Upon falling edge of the encoder data ready, check
		     //whether encoder data is non-zero.
                     if((fe_encoder_raw_data_ready_rs == 1'b1) && (encoder_data_i != 0)) 
			     nextstate[CHECK_BIT_CALC_ST] = 1'b1;
		     else
			     nextstate[ENCODER_VALUE_ST] = 1'b1;
		end

		state[CHECK_BIT_CALC_ST] : begin
		     nextstate[VALIDATE_RESULT_ST] = 1'b1;
		end 

		state[VALIDATE_RESULT_ST] : begin
			nextstate[ENCODER_VALUE_ST] = 1'b1;
		end 

		default: begin
			nextstate = 3'b000;
		end 
	endcase 
end

//3rd Always block - Sequnetial
//1. Aiignement outputs based on the state
//2. Use non-blocking assignment
always @(posedge clk_i or negedge rst_in) begin
	if(!rst_in) begin
	   data_ready_o <= 1'b0;
   	   checkBit_Error_o <= 1'b0;
           checkBit_NoError_o <= 1'b0;
	   checkbit_result_o <= 2'b00;
	   data_rs <= 12'b0;
	   checkbit_result_ready_rs <= 2'b0;
           cw_position_counts_o <= 12'b0;
	   ccw_position_counts_o <= 12'b0;
	end 
	else begin
		//Default condition
		cw_position_counts_o <= data_rs;
		ccw_position_counts_o <= (4095 - data_rs);
		data_ready_o <= 1'b0;
	        checkBit_Error_o <= 1'b0;
         	checkBit_NoError_o <= 1'b0;
            	checkbit_result_o <= 2'b00;
		checkbit_result_ready_rs <= 2'b0;

		case(1'b1) 
			nextstate[CHECK_BIT_CALC_ST] : begin
			     //Call checkbit computation function to verify
			     //whether encoder received data is intact.
			     //as well report the computed checkbit value
			     checkbit_result_ready_rs <= CheckbitResult(encoder_data_i);
			end 
			nextstate[VALIDATE_RESULT_ST] : begin
			     //Ensure checkbit result is 0 to confirm no parity
			     //error, then copy the position value for further
			     //processing.
			     if(checkbit_result_ready_rs == 2'b0) begin
			 	data_rs <= encoder_data_i[13:2];  //Take a copy of the 12 bits
				data_ready_o <= 1'b1;
				checkBit_Error_o <= 1'b0;
				checkBit_NoError_o <= 1'b1;
			     end 
			     else begin
				data_ready_o <= 1'b0;
				checkBit_Error_o <= 1'b1;
				checkBit_NoError_o <= 1'b0;
			     end
	
			     checkbit_result_o <= checkbit_result_ready_rs;
			end

			default : begin
			     data_ready_o <= 1'b0;
			     checkBit_Error_o <= 1'b0;
			     checkBit_NoError_o <= 1'b0;
			     checkbit_result_o <= 2'b00;
			end	
		endcase
	end 
end 
endmodule 
