`timescale 1ns/1ps

module OneHot_FSM_tb;

//Inputs declaration
reg clk;
reg rst_n;
reg dly;
reg done;
reg req;

//Output declaration
wire gnt;

//module associate port mapping
OneHotCode_FSM uut(
   .clk(clk),
   .rst_n(rst_n),
   .dly(dly), 
   .done(done),
   .req(req),
   .gnt(gnt)
);

//Clock generation 10ns duration
always #5 clk = ~clk;

//Stimulus
initial begin
    //Initialization of inputs to DUT
    clk    = 1'b0;
    rst_n  = 1'b0;
    dly    = 1'b0;
    done   = 1'b0;
    req    = 1'b0;

    // Apply reset
    #10 rst_n = 1;

    // TEST CASE 1: IDLE -> BBUSY
    #10 req = 1;

    // TEST CASE 2: Stay in BBUSY
    #10 req = 0;
        done = 0;
        dly  = 0;

    // TEST CASE 3: BBUSY -> BWAIT
    #10 dly = 1;

    // TEST CASE 4: Stay in BWAIT
    #10 dly = 1;

    // TEST CASE 5: BWAIT -> BFREE
    #10 dly = 0;

    // TEST CASE 6: BFREE -> BWAIT (rqst = 0)
    #10 req = 0;

    // TEST CASE 7: BWAIT -> BFREE again
    #10 dly = 0;

    // TEST CASE 8: BBUSY -> BFREE via done
    #10 req  = 1;
    #10 done = 1;
end 

//Monitor each input and output
initial begin
    $monitor("Time=%0t | rst_n=%b req=%b dly=%b done=%b | gnt=%b",
              $time, rst_n, req, dly, done, gnt);
end

//Waveform dump
initial begin
  $dumpfile("sim/waveforms/OneHot_FSM.vcd");  // MUST match Makefile
  $dumpvars(0, OneHot_FSM_tb);

  #200 $finish;
end

endmodule  
