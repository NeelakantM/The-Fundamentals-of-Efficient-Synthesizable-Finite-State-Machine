/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Header!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Author : Neelakant Myageri
Date   : 26 Jan 2026
Description : Three always block coding to understand and learn how to 
              implement 3 always blocks.
              1. First SEQUENTIAL always block is used for state management
              2. Second COMBINATIONAL always block is used to check control 
                 inputs and state transition decision and set output. 
              3. Third SEQUENTIAL always block is used to register outputs
              4. Rules followed in the code,
                 3.1 Three always blocks only
                 3.2 Sequential block
                    -Clock + reset
                    -Only state <= nextstate
                 3.3 Combinational block
                    -Default assignments FIRST
                    -No reset
                    -No inferred latches
                 3.4 Sequential block
                    -Clock + reset.
                    -Default assignment first.
                    -Assign output based on state.
              5. Use localparam / enum for states.
              6. One-hot or binary — be explicit.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
module ThreeAlwaysBlock(
input clk, rst,
input req, dly, done,
output reg gnt
);

localparam int IDLE  = 1,
               BBUSY = 2,
               BWAIT = 3,
               BFREE = 4;

reg [3 : 0] state, nextstate;

/*First SEQUENTIAL always block,
1. Assign present and state.
2. Use non-blocking assignment.
3. Asynchronous reset.
*/
always @(posedge clk or negedge rst) begin
  if(!rst) 
	  state[IDLE] <= {3'b0,1'b1};
  else  
	  state <= nextstate;
end

/*Second COMIBINATIONAL always block,
1. Manage state transition
2. Use blocking assignments
*/
always @(*) begin
   //Default state assignment
   nextstate = 4'b0;
   /*The synthesis parallel_case directive is typically placed as a  
   comment on the same line as the case statement header. This informs 
   the synthesis  tool that all case items are mutually exclusive, 
   preventing the  comment on the same creation of a priority encoder*/
   case(1'b1) // synthesis full_case  parallel_case
      state[IDLE]  : begin
           if(req)               nextstate[BBUSY] = 1'b1;
           else                  nextstate[IDLE]  = 1'b1;
      end 
      state[BBUSY] : begin
           if(dly && done)       nextstate[BWAIT] = 1'b1;
           else if(!dly && done) nextstate[BFREE] = 1'b1;
           else                  nextstate[BBUSY] = 1'b1;
      end 
      state[BWAIT] : begin
           if(dly)               nextstate[BWAIT] = 1'b1;
           else                  nextstate[BFREE] = 1'b1;
      end
      state[BFREE] : begin
           if(req)               nextstate[BBUSY] = 1'b1;
           else                  nextstate[IDLE]  = 1'b1;
      end
      default :                  nextstate[IDLE]  = 1'b1;
   endcase
end 
/*Third SEQUENTIAL always block,
1. Assign outputs.
2. Use Non-blocking assignments.
*/
always@(posedge clk) begin
   if(!rst) gnt <= 1'b0;
   else begin
     //Default state assignment of output
     gnt <= 1'b0;
     case(1'b1)
         nextstate[BBUSY], nextstate[BWAIT]:   gnt <= 1'b1; //Output is high only in BBUS, BWAIT state.
         default                           :   gnt <= 1'b0;
     endcase
   end
end 
endmodule
