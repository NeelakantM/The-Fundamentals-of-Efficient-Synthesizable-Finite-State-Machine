//Declare Module I/Os
module FSM_Coding(
input clk,rst_in,
input dly,done,dly,rqst,
output reg gnt
);

//Declare FSM States in Binary Coding
parameter [1:0] IDLE = 2'b00,
    			BBUSY = 2'b01,
				BWAIT = 2'b10,
				BFREE = 2'b11;

//Declare State transition registers
reg [1:0] state, nextstate;

  //Always block for state transition management. 
  //The sequential always block is coded using nonblocking assignments
  always@(posedge clk) begin
    if(!rst)
         state = IDLE;
    else
         state = nextstate;
  end
  
  //@@Always block to check inputs and state transition as well to set output
  
  //Assignments within the combinational always block are made using Verilog blocking assignments
  always@(*) begin
    case(state)
       /*Default output assignments are made before coding the case statement (this eliminates latches and
       reduces the amount of code required to code the rest of the outputs in the case statement and
       highlights in the case statement exactly in which states the individual output(s) change).*/
       nextstate = 2'bx;
       
       IDLE : 
         if(rqst)
           nextstate = BBUSY;
         else
           nextstate = IDLE;
             
       BBUSY : begin
         gnt = 1'b1;
         if(done)
           nextstate = BFREE;
         else if(dly)
           nextstate = BWAIT; 
         else
           nextstate = BBUSY;
         end
      
       BWAIT : begin
         gnt = 1'b1;
         if(dly)
           nextstate = BWAIT;
         else
           nextstate = BFREE;
         end
       BFREE : 
         if(req)
             nextstate = BFREE;
         else
             nextstate = BWAIT;
      
       Default :
         gnt = 1'b0;
         nextstate = IDLE; 
   end
endmodule