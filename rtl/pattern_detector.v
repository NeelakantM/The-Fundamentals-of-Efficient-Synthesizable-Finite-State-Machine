/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Header!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Author : Neelakant Myageri
Date   : 29 Jan 2026
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Footer!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
module pattern_detector #(
 parameter [3 : 0] pattern_value_c = 4'b0101
)
(input clk_i, rstn_i,
input [3:0] input_pattern_i,  //0101
output reg pattern_detect_o
);

//State definition for One-hot state bit positions
localparam IDLE_ = 0,
           PT1   = 1,
           PT2   = 2,
           PT3   = 3,
		   PATTERN_DETECT = 4;

reg [4:0] state, nextstate;

//Sequential always block for state and next state management
always@(posedge clk_i) begin
   if(!rstn_i)
      state <= 5'b00001;
   else
      state <= nextstate;
end 

//Combinational always block for state transition
always@(*) begin
   //default state
   nextstate = 5'b0;
   
   case(1'b1)
       state[IDLE]: begin
	       if(input_pattern_i[0] == pattern_value_c[0])  nextstate[PT1] = 1'b1;
		   else nextstate[IDLE] = 1'b1;
	   end
	   state[PT1]: begin
	       if(input_pattern_i[1] == pattern_value_c[1]) nextstate[PT2] = 1'b1;
		   else nextstate[IDLE] = 1'b1;
	   end
	   state[PT2]: begin
	       if(input_pattern_i[2] == pattern_value_c[2]) nextstate[PT3] = 1'b1;
		   else nextstate[IDLE] = 1'b1;
	   end
	   state[PT3]: begin
	       if(input_pattern_i[3] == pattern_value_c[3]) nextstate[PATTERN_DETECT] = 1'b1;
		   else nextstate[IDLE] = 1'b1;	       
	   end
	   state[PATTERN_DETECT]: begin
	       nextstate[IDLE] = 1'b1;	 
	   end
	   default : begin 
	       nextstate[IDLE] = 1'b1;
	   end
   endcase
end

//Sequential always block for ouput mapping
always@(posedge clk_i) begin
    if(!rstn_i) 
       pattern_detect_o <= 1'b0;
    else begin
      pattern_detect_o <= 1'b0;
      case(state) 
	     state[PATTERN_DETECT] : pattern_detect_o <= 1'b1;
		 state[IDLE],state[PT1],state[PT2],state[PT3] : pattern_detect_o <= 1'b0;
		 default : pattern_detect_o <= 1'b0;
	  end
    end 
end

endmodule