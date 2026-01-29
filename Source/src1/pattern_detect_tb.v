`timescale 1ns/1ps

module tb_pattern_detector;

    // Clock & reset
    reg clk_i;
    reg rstn_i;

    // DUT inputs
    reg  [3:0] input_pattern_i;

    // DUT outputs
    wire pattern_detect_o;

    // Instantiate DUT
    pattern_detector #(
        .pattern_value_c(4'b0101)
    ) dut (
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        .input_pattern_i(input_pattern_i),
        .pattern_detect_o(pattern_detect_o)
    );

    // -----------------------------
    // Clock generation: 10ns period
    // -----------------------------
    initial begin
        clk_i = 1'b0;
        forever #5 clk_i = ~clk_i;
    end

    // -----------------------------
    // Test sequence
    // -----------------------------
    initial begin
        // Initialize
        rstn_i = 1'b0;
        input_pattern_i = 4'b0000;

        // Apply reset
        #20;
        rstn_i = 1'b1;

        $display("---- Test 1: Correct pattern 0101 ----");

        // Apply pattern bits one per cycle
        drive_bit(0, 0);  // bit0 = 1
        drive_bit(1, 1);  // bit1 = 0
        drive_bit(2, 0);  // bit2 = 1
        drive_bit(3, 1);  // bit3 = 0

        #10;
        check_detect(1);

        $display("---- Test 2: Wrong pattern ----");

        drive_bit(0, 1);
        drive_bit(1, 1);
        drive_bit(2, 1);
        drive_bit(3, 1);

        #10;
        check_detect(0);

        $display("---- Test 3: Correct pattern again ----");

        drive_bit(0, 0);
        drive_bit(1, 1);
        drive_bit(2, 0);
        drive_bit(3, 1);

        #10;
        check_detect(1);

        $display("---- All tests completed ----");
        #20;
        $finish;
    end

    // ---------------------------------
    // Task: Drive one bit per cycle
    // ---------------------------------
    task drive_bit;
        input integer bit_pos;
        input bit_value;
        begin
            @(negedge clk_i);
            input_pattern_i = 4'b0000;
            input_pattern_i[bit_pos] = bit_value;
        end
    endtask

    // ---------------------------------
    // Task: Check detect output
    // ---------------------------------
    task check_detect;
        input expected;
        begin
            if (pattern_detect_o !== expected) begin
                $display("ERROR @ %0t: Expected detect=%0d, Got=%0d",
                          $time, expected, pattern_detect_o);
            end else begin
                $display("PASS  @ %0t: detect=%0d",
                          $time, pattern_detect_o);
            end
        end
    endtask

    // ---------------------------------
    // Monitor (optional but useful)
    // ---------------------------------
    initial begin
        $monitor("T=%0t | state=%b | input=%b | detect=%b",
                  $time, dut.state, input_pattern_i, pattern_detect_o);
    end

endmodule
