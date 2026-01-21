module oneHot_Code_FSM(
input dly, done, req, clk, rst_n,
output reg gnt);
  
  //Parameter decalration of FSM States, ADVANTAGE - parameter values 
  //can be changed  later without modifying the source code. 
  //Each parameter declaration is separated by comma(,)
  parameter [3:0] IDLE  = 0,  
                  BBUSY = 1,
                  BWAIT = 2,
                  BFREE = 3;
  
  //State signal declaration and nextstate assignment.
  reg [3:0] state, 
            nextstate;
  
  //Asynchronous reset block
  always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin           //Default assignment upon resetting the design
      state       <= 4'b0;
      state[IDLE] <= 1'b1;     //Start the state from IDLE, after reset is released.
    end
    else state    <= nextstate; //Next state transition assignment
  end 
  
  //Second always block for combinational logic each assignment MUST use blocking statement.
  //Explicitly mention signals critical for state transition in combinational always block
  always@(state,dly, done, req) begin
    //Decalrae default condition of output, state
    nextstate = 4'b0;
    gnt       = 1'b0;
    //Define case statement for 1'b1 condition as it is one hot code state machine
    //Use text "ambit synthesis case = full, parallel to prevent the tool from 
    //building unnecessary priority encoders.
    case(1'b1) //ambit synthesis case = full, parallel 
      state[IDLE]  : begin //Multiple assignment within a case requires begin and end
        				if(!req) nextstate[IDLE] = 1'b1;
      				 	else  nextstate[BBUSY] = 1'b1;
                     end
      state[BBUSY] : begin
                     	gnt = 1'b1;
        				if(!done) nextstate[BBUSY] = 1'b1; 
        				else if(dly && done) nextstate[BWAIT] = 1'b1;
                     	else if(!dly && done) nextstate[BFREE] = 1'b1;
      				 end 
      state[BWAIT] : begin
                       gnt = 1'b1;
        			   if(dly) nextstate[BWAIT] = 1'b1;
                       else nextstate[BFREE] = 1'b1;
                     end 
      state[BFREE] : begin
        			   if(!req) nextstate[IDLE] = 1'b1;
      				   else nextstate[BBUSY] = 1'b1;
                     end 
      default      : nextstate[IDLE] = 1'b1; 
    endcase
  end
endmodule