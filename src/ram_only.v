module ram_only(
  input clk,
  input rst_n,
  input   csb0, // active low chip select
  input  web0, // active low write control
  input [7:0] din0,
  input [7:0] din1,
  input [8:0]  addr0,
  output [7:0] dout0,
  output reg [7:0] dout1,
  output equal);


always @ (posedge clk or negedge rst_n) begin
  if (~rst_n)
    dout1 <= 8'd0;
  else
    dout1 <= din0 + din1;
end

assign equal = (din0 == din1);

  sram_w8_b512_freepdk45
  R0 (
   .clk0  (clk )   ,
   .csb0  (csb0 )   ,
   .web0  (web0 )   ,
   .addr0 (addr0)   ,
   .din0  (din0 )   ,
   .dout0 (dout0)     );
endmodule
