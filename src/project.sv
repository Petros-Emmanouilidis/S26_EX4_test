/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none


module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  assign uio_oe[1:0] = '0;
  assign uio_oe[7:2] = '1;
  assign uio_out[7:3] = '0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0};

  RangeFinder #(8) rf(.data_in(ui_in), .range(uo_out), .clock(clk), .reset(~rst_n), .go(uio_out[0]), .finish(uio_out[1]), .error(uio_out[2]));

endmodule
