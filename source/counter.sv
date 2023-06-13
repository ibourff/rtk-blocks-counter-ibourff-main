/*
module name: counter
description: Counts to a flexible amount. Has strobe at max and controls for wrapping, enable, and clear.
*/

module counter
#(
    parameter N = 4 // Size of counter (i.e. number of bits at the output). Maximum count is 2^N - 1
)
(
    input logic clk,            // Clock
    input logic nrst,           // Asyncronous active low reset
    input logic enable,         // Enable
    input logic clear,          // Synchronous active high clear 
    input logic wrap,           // 0: no wrap at max, 1: wrap to 0 at max
    input logic [N - 1:0] max,      // Max number of count (inclusive)
    output logic [N - 1:0] count,   // Current count
    output logic at_max         // 1 when counter is at max, otherwise 0
);

    // Write your code here!

logic [(N-1):0]next_count;

always_ff @ (posedge clk, negedge nrst)
begin
    if(~nrst)
        count <= 0;
    else
        count <= next_count;
end 

always_comb
begin 
    next_count = 0;
    if (count == max)           //check for max value
        at_max = 1;
    else
        at_max = 0;


    if(clear)
        next_count = 0;        //if clear enabled, then count = 0
    else
        if(enable)             //if enable engaged, then the counter starts counting
        begin
            if((count == max) && wrap)      //if wrap is engaged when count reaches max, then it wraps back to zero
                next_count = 0;
                
            else if (count == max && ~wrap) //if wrap not engaged at max, then count stops 
                next_count = count;
            else                            //if not at max then count is incremented 
                next_count = count + 1;
        end
        else
            next_count = count;             //if enable not on then count remains constant 

end 

endmodule