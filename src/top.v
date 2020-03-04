// OpenRAM SRAM model
// Words: 512
// Word size: 8

module top(
// Port 0: RW
    clk,csb0,web0,addr0,din0,dout0,
// Other IOs
    other0, other1
  );

  input  clk; // clock
  input   csb0; // active low chip select
  input  web0; // active low write control
  input [8:0]  addr0;
  input [7:0]  din0;
  output [7:0] dout0;

  input other0;
  output [7:0] other1;

  reg [7:0] r_other;

  //assign other1 = (dout0 == 0)? other0:1'b0;
  always @ (*) begin
    r_other <=  dout0 + din0;
  end

  sram_w8_b512_freepdk45
  R0 (
   .clk0  (clk )   ,
   .csb0  (csb0 )   ,
   .web0  (web0 )   ,
   .addr0 (addr0)   ,
   .din0  (din0 )   ,
   .dout0 (dout0)     );

  genvar g_i;
  generate
  for (g_i = 0; g_i < 8;  g_i=g_i+1) begin: TSV_GEN
    TSV TSV0 (.data_in (r_other[g_i]), .data_out (other1[g_i]));
  end
  endgenerate

endmodule
