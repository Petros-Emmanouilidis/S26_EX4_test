`default_nettype none

//module to find the range between a bunch of numbers between go and finish
module RangeFinder
   #(parameter WIDTH=16)
    (input  logic [WIDTH-1:0] data_in,
     input  logic             clock, reset,
     input  logic             go, finish,
     output logic [WIDTH-1:0] range,
     output logic             error);

      assign range = data_in;
      always_ff @(posedge clk) begin
         if (~rst_n) begin
            error <= '0;
         end
         else begin
            error <= go ^ finish;
         end
      end

endmodule: RangeFinder