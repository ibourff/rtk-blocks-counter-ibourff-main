/*
    Module name: tb_counter
    Description: A testbench for the counter task
*/

// 
// Feel free to mess around with the testbench!
//

`timescale 1ns/1ps

module tb_counter_4 ();

    /////////////////////
    // Testbench Setup //
    /////////////////////

    localparam time CLOCK_PERIOD = 10; // 100 MHz 
    localparam RESET_ACTIVE = 0;
    localparam RESET_INACTIVE = 1;

    // Testbench Parameters
    integer tb_test_number = 0;
    logic[1024:0] tb_test_name = "PLACEHOLDER"; 

    // Signals for 3 DUTs of size 2, 4 and 8
    logic tb_clk, tb_nrst, tb_enable, tb_clear, tb_wrap, 
    tb_at_max_4, tb_at_max_8;

    logic [3:0] tb_max_4, tb_count_4;
    logic [7:0] tb_max_8, tb_count_8;


    // Expected values for checks
    logic [3:0] tb_count_4_exp; 
    logic tb_at_max_4_exp; 

    // iverilog waveform generation
    initial begin
        $dumpfile ("dump.vcd");
        $dumpvars;
    end

    ////////////////////////
    // Testbenching tasks //
    ////////////////////////

    // reset_dut: Does a quick reset for 1 cycle 
    task reset_dut;
        begin
            @(negedge tb_clk); // synchronize to negedge edge so there are not hold or setup time violations
            tb_nrst = RESET_ACTIVE;

            @(negedge tb_clk);
            tb_nrst = RESET_INACTIVE; 
        end
    endtask

    // set_inputs_low, sets all DUT inputs low
    task set_inputs_low;
        begin
            @(negedge tb_clk); // synchronize to the negative edge 
            tb_enable = 0;
            tb_clear = 0;
            tb_wrap = 0;
            tb_max_4 = 0;
            tb_max_8 = 0;
        end
    endtask

    // clock, waits N clock cycles
    task clock(
        input integer N
    );
        begin
            for (integer i = 0; i < N; i = i + 1) begin
                @(posedge tb_clk);
            end
        end
    endtask    


    // check output values against expected values

    task check_outputs_4;
    input logic[3:0] exp_count; 
    input logic exp_at_max; 
    begin
        @(negedge tb_clk); 
        if(exp_count != tb_count_4)
            $error("Incorrect tb_count_4 value. Actual: %0d, Expected: %0d.", tb_count_4, exp_count); 
        else 
            $info("Correct tb_count_4 value."); 
        
        if(exp_at_max != tb_at_max_4)
            $error("Incorrect tb_at_max_4 value. Actual: %0d, Expected: %0d.", tb_at_max_4, exp_at_max); 
        else 
            $info("Correct tb_at_max_4 value.");

    end
    endtask 

    //////////
    // DUTs //
    //////////

    counter_4 DUT_4 
    (
        .clk(tb_clk),
        .nrst(tb_nrst),
        .enable(tb_enable),
        .clear(tb_clear),
        .wrap(tb_wrap),
        .max(tb_max_4),

        .count(tb_count_4),
        .at_max(tb_at_max_4)
    );


    // Create an instance for the N = 8, counter



    // Clocking
    always begin
        tb_clk = 0; // set clock initially to be 0 so that they are no time violations at the rising edge 
        #(CLOCK_PERIOD / 2);
        tb_clk = 1;
        #(CLOCK_PERIOD / 2);
    end

    initial begin

        // First test the 4 bit coutnter (to check you have correctly set the parameters)

        ////////////////////////////////////////////////
        // Test 1: Power on reset & Initialize Values //
        ////////////////////////////////////////////////

        tb_test_number = tb_test_number + 1;
        tb_test_name = "Power on Reset";
        tb_nrst = RESET_ACTIVE; 
        tb_enable = 0;
        tb_clear = 0;
        tb_wrap = 0;
        tb_max_4 = 0;


        #(CLOCK_PERIOD * 2); // Wait 2 times the clock period before proceeding 
        
        tb_count_4_exp = 0; 
        tb_at_max_4_exp = 1; // since max is set 0; 
        check_outputs_4(tb_count_4_exp, tb_at_max_4_exp); 
        
        ////////////////////////////////////////////////////////
        // Test 2: Test Counter with Wrap Around condition    //
        ///////////////////////////////////////////////////////

        @(negedge tb_clk);
        tb_test_number += 1; 
        tb_test_name = "Test 4 Bit Counter w/ Wrap Around Condition & w/ Max = 15"; 
        tb_nrst = RESET_INACTIVE; // remove the reset to test the design to test it
        tb_wrap = 1'b1; 
        tb_enable = 1'b1;
        tb_max_4 = 4'hF; // max value for counting (15 in decimal)

        clock(3); // move forward by 3 clock cycles; 
        
        tb_count_4_exp = 4'h3; 
        tb_at_max_4_exp = 1'b0; 
        #(0.5); // small delay to check the values
        check_outputs_4(tb_count_4_exp, tb_at_max_4_exp);

        clock(12); // move the clock by 12 cycles and check that max value is reached
        
        tb_count_4_exp = 4'hF; 
        tb_at_max_4_exp = 1'b1; // since at max value  
        #(0.5); // small delay to check the values
        check_outputs_4(tb_count_4_exp, tb_at_max_4_exp);


        clock(1);
        tb_count_4_exp = 4'h0; // wraps around 
        tb_at_max_4_exp = 1'b0; // since at max value  
        #(0.5); // small delay to check the values
        check_outputs_4(tb_count_4_exp, tb_at_max_4_exp);


        //////////////////////////////////////////////////////////////////////////////////
        // Test 3: Test Counter w/o Wrap Around condition and w/ Different Max Value    //
        //////////////////////////////////////////////////////////////////////////////////
        tb_test_name = "Test Counter w/o Wrap Around Condition and w/ Max = 4";
        tb_test_number += 1; 

        tb_wrap = 1'b0; 
        tb_max_4 = 4'h4; 

        clock(4); // get to the maximum value of 4
        
        tb_count_4_exp = 4'h4; // wraps around 
        tb_at_max_4_exp = 1'b1; // since at max value  
        #(0.5); // small delay to check the values
        check_outputs_4(tb_count_4_exp, tb_at_max_4_exp);


        clock(15); // no matter how many clocks we move forward, the values will not change
        
        tb_count_4_exp = 4'h4; // does not wrap around 
        tb_at_max_4_exp = 1'b1; // since at max value  
        #(0.5); // small delay to check the values
        check_outputs_4(tb_count_4_exp, tb_at_max_4_exp);


        ///////////////////////////////////////////////////////////////////////////////////////////////////////
        // Test 4: Test Counter w/ synchronous Clear asserted (this should take precedence over all else)    //
        //////////////////////////////////////////////////////////////////////////////////////////////////////
        tb_test_name = "Synchronous Clear Asserted";
        tb_test_number += 1; 
        tb_clear = 1; 

        #(1); // make sure it is synchronous. Not using the task since it synchronizes to the next neg edge
        if(tb_count_4_exp != tb_count_4)
            $error("Incorrect tb_count_4 value. Actual: %0d, Expected: %0d.", tb_count_4, tb_count_4_exp); 
        else 
            $info("Correct tb_count_4 value."); 
        
        if(tb_at_max_4_exp != tb_at_max_4)
            $error("Incorrect tb_at_max_4 value. Actual: %0d, Expected: %0d.", tb_at_max_4, tb_at_max_4); 
        else 
            $info("Correct tb_at_max_4 value.");
            
        
        clock(1); 

        tb_count_4_exp = 4'h0; 
        tb_at_max_4_exp = 1'b0;
        #(0.5); // small delay to check the values
        check_outputs_4(tb_count_4_exp, tb_at_max_4_exp);
 
        $finish;
    end


endmodule
