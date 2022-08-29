
`default_nettype none

module user_module_341364381657858642(
  input [7:0] io_in,
  output [7:0] io_out
);

mcpu6bit mcpu6bit_top (
  .clk(io_in[0]),
  .rst(io_in[1]),
  .datain(io_in[7:2]),

  .we(io_out[1]),
  .dataout(io_out[7:2]),
);

endmodule
