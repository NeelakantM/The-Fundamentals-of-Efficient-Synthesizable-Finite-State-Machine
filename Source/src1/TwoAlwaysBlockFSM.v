/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Header!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Author : Neelakant Myageri
Date   : 21 Jan 2026
Description : Two always block coding to understand and learn how to 
              implement 2 always blocks.
              1. First SEQUENTIAL always block is used for state management
			  2. Second COMBINATIONAL always block is used to check control 
			     inputs and state transition decision and set output. 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
module TwoAlwaysBlockFSM(
input clk_i, rstn_i,  //Master inputs to the block
input go,jmp,         //Control inputs
output reg y1         //Output
);

//Define states
parameter S0 = 0,
          S1 = 1,
		  S2 = 2,
		  S3 = 3,
		  S4 = 4,
		  S5 = 5,
		  S6 = 6,
		  S7 = 7,
		  S8 = 8,
		  S9 = 9;

//Define present and next state
reg [9 : 0] state, nextstate;


//First always block - Sequential and uses non-blocking assignment.
always@(posedge clk_i or negedge rstn_i) begin
  if(!rstn_i) 
     state <= 9'b0;
  else
     state <= nextstate;
  end
end

//Second always block - Combinational, uses blocking assigment.
always @(*) begin
   if(!rstn_i) begin
      nextstate = 9'b0;
	  y1        = 1'b0;
   end
   //Define default condition
      nextstate = 9'b0;
	  y1        = 1'b0;
	  
	  case(1'b1)
	    state[IDLE] : if(go & !jmp)
	  endcase
	  
   else
   
   end
end

endmodule