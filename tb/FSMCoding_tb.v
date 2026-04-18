`timescale 1ns/1ps

module FSMCoding_tb;

  // Inputs (reg type)
  reg clk;
  reg rst_in;
  reg dly;
  reg done;
  reg rqst;

  // Outputs (wire type)
  wire gnt;

  // Instantiate DUT (Device Under Test)
  FSM_Coding uut (
    .clk(clk),
    .rst_in(rst_in),
    .dly(dly),
    .done(done),
    .rqst(rqst),
    .gnt(gnt)
  );

  // Clock generation: 10ns period
  always #5 clk = ~clk;

  // Stimulus
  initial begin
    // Initialize signals
    clk    = 0;
    rst_in = 0;
    dly    = 0;
    done   = 0;
    rqst   = 0;

    // Apply reset
    #10 rst_in = 1;

    // TEST CASE 1: IDLE -> BBUSY
    #10 rqst = 1;

    // TEST CASE 2: Stay in BBUSY
    #10 rqst = 0;
        done = 0;
        dly  = 0;

    // TEST CASE 3: BBUSY -> BWAIT
    #10 dly = 1;

    // TEST CASE 4: Stay in BWAIT
    #10 dly = 1;

    // TEST CASE 5: BWAIT -> BFREE
    #10 dly = 0;

    // TEST CASE 6: BFREE -> BWAIT (rqst = 0)
    #10 rqst = 0;

    // TEST CASE 7: BWAIT -> BFREE again
    #10 dly = 0;

    // TEST CASE 8: BBUSY -> BFREE via done
    #10 rqst = 1;
    #10 done = 1;

    // Finish simulation
    #20 $finish;
  end

  // Monitor signals
  initial begin
    $monitor("Time=%0t | rst=%b rqst=%b dly=%b done=%b | gnt=%b",
              $time, rst_in, rqst, dly, done, gnt);
  end

 initial begin
  $dumpfile("sim/waveforms/FSMCoding.vcd");  // MUST match Makefile
  $dumpvars(0, FSMCoding_tb);

  #200 $finish;
 end
endmodule
