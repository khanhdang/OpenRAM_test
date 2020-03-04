module no_macro(
  input clk,
  input rst_n,
  input [7:0] din0,
  input [7:0] din1,
  output reg [7:0] dout,
  output equal);


always @ (posedge clk or negedge rst_n) begin
  if (~rst_n)
    dout <= 8'd0;
  else
    dout <= din0 + din1;
end

assign equal = (din0 == din1);

endmodule
