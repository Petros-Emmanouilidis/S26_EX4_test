`default_nettype none

//module to find the range between a bunch of numbers between go and finish
module RangeFinder
   #(parameter WIDTH=16)
    (input  logic [WIDTH-1:0] data_in,
     input  logic             clock, reset,
     input  logic             go, finish,
     output logic [WIDTH-1:0] range,
     output logic             error);

   logic [WIDTH-1:0] max, min;
   logic receiving;

   //logic for max and min
   always_ff @(posedge clock, posedge reset) begin
      if (reset) begin
         max <= 'b0;
         min <= 'b0;
         receiving <= 'b0;
      end
      else if (go & ~finish & ~error) begin
         max <= data_in;
         min <= data_in;
         receiving <= 1'b1;
      end
      else if (receiving & ~error) begin
         if (data_in > max) begin
            max <= data_in;
         end
         if (data_in < min) begin
            min <= data_in;
         end
         if (finish) begin
            receiving <= 'b0;
         end
      end
      else if (error) begin
         receiving <= 'b0;
      end
   end

   logic [WIDTH-1:0] actual_min, actual_max;

   //combinational logic for error
   always_comb begin
      error = '0;
      if (reset) error = 1'b0;
      if (go & finish)
         error = 1'b1;
      if (~receiving & finish)
         error = 1'b1;
      if (receiving & go)
         error = 1'b1;
      if (error & go & ~finish)
         error = 1'b0;
   end

   logic [WIDTH-1:0] actual_range;
   //logic to keep range when there is an error
   always_ff @(posedge clock, posedge reset) begin
      if (reset) begin
         actual_range <= 'b0;
      end
      else if (~error) begin
         actual_range <= range;
      end
   end

   //combinational logic for range
   always_comb begin
      actual_min = '0;
      actual_max = '0;
      range = '0;
      if (~error) begin
         if (data_in > max) begin
            actual_max = data_in;
         end
         else actual_max = max;
         if (data_in < min) begin
            actual_min = data_in;
         end
         else actual_min = min;
         range = actual_max - actual_min;
      end
      else range = actual_range;
   end

endmodule: RangeFinder