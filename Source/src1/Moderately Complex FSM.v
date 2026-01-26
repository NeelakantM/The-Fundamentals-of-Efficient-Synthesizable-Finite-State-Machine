/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Header!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Author : Neelakant Myageri
Date   : 26 Jan 2026
Description : Two always block coding to understand and learn how to 
              implement 2 always blocks.
              1. First SEQUENTIAL always block is used for state management
			  2. Second COMBINATIONAL always block is used to check control 
			     inputs and state transition decision and set output. 
			  3. Rules followed in the code,
			     3.1 Two always blocks only
                 3.2 Sequential block
                    -clock + reset
                    -only state <= nextstate
                 3.3 Combinational block
                    -default assignments FIRST
                    -no reset
                    -no inferred latches
                 4. Use localparam / enum for states
                 5. One-hot or binary — be explicit
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
module TwoAlwaysBlockFSM(
input clk_i, rstn_i,  //Master inputs to the block
input go,jmp,         //Control inputs
output reg y1         //Output
);

//Define states
localparam int     S0 = 0,
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
  if(!rstn_i) state <= 10'b0;
  else        state <= nextstate;
end

//Second always block - Combinational, uses blocking assigment.
always @(*) begin
      nextstate = 10'b0;
	  y1        = 1'b0;
	  y2        = 1'b0;
	  y3        = 1'b0;

	  case(1'b1)
	    //Output follows default state
		//&& - Bitwise AND
	    state[S0] : begin
                        y1 = 1'b0;		
                        y2 = 1'b0;
                        y3 = 1'b0;
		                if(go && !jmp) nextstate[S1] = 1'b1;
		                else if(go && jmp) nextstate[S3] = 1'b1;
					    else nextstate[S0] = 1'b1;
		            end
		//Output follows default state
		state[S1] : begin
		                y1 = 1'b0;		
                        y2 = 1'b0;
                        y3 = 1'b0;
		                if(jmp) nextstate[S3] = 1'b1;
		                else nextstate[S2] = 1'b1;
		            end
		//Output follows default state
		state[S2] : begin 
		                y1 = 1'b0;		
                        y2 = 1'b0;
                        y3 = 1'b0;
		                nextstate[S3] = 1'b1;
		            end
		//Asynchronous output update
		state[S3] : begin 
		                y1 = 1'b1;		
                        y2 = 1'b1;
                        y3 = 1'b0;
		                if(jmp) nextstate[S3] = 1'b1;
		                else nextstate[S4] = 1'b1;
                    end
		//Output follows default state
		state[S4] : begin
		                y1 = 1'b0;		
                        y2 = 1'b0;
                        y3 = 1'b0;
		                if(jmp) nextstate[S3] = 1'b1;
		                else if (!sk0 && !jmp) nextstate[S5] = 1'b1;
		            end
		//Output follows default state
		state[S5] : begin 
		                y1 = 1'b0;		
                        y2 = 1'b0;
                        y3 = 1'b0;
		                if(jmp) nextstate[S3] = 1'b1;
		                else if (!sk0 && !sk1 && !jmp) nextstate[S6] = 1'b1;
		                else if (sk0 && !sk1 && !jmp) nextstate[S7] = 1'b1;
		                else if (!sk0 && sk1 && !jmp) nextstate[S8] = 1'b1;
		                else if (sk0 && sk1 && !jmp) nextstate[S9] = 1'b1;
						else nextstate[S5] = 1'b1;
		            end
		//Output follows default state
		state[S6] : begin 
		                y1 = 1'b1;		
                        y2 = 1'b1;
                        y3 = 1'b1;
		                if(jmp) nextstate[S3] = 1'b1;
		                else if(go && !jmp) nextstate[S7] = 1'b1;
						else nextstate[S6] = 1'b1;
		            end
		//Output follows default state
		state[S7] : begin
                        y1 = 1'b0;		
                        y2 = 1'b0;
                        y3 = 1'b1;
		                if(jmp) nextstate[S3] = 1'b1;
		                else nextstate[S8] = 1'b1;
					end
		//Output follows default state
		state[S8] : begin
                        y1 = 1'b0;		
                        y2 = 1'b1;
                        y3 = 1'b1;
		                if(jmp) nextstate[S3] = 1'b1;
		                else nextstate[S9] = 1'b1;
					end
        //Output assignment as per 2 always block mechanism.	
		state[S9] : begin 
				        y1 = 1'b1;		
                        y2 = 1'b1;
                        y3 = 1'b1;
		                if(jmp) nextstate[S3] = 1'b1;
		                else nextstate[S7] = 1'b1;
					end
		//Safety Recovery
		default   : begin
		                y1 = 1'b0;		
                        y2 = 1'b0;
                        y3 = 1'b0;
		                nextstate[S0] = 1'b0;
		            end
	  endcase
	end
end
endmodule