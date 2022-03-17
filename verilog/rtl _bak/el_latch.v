`timescale 1ns / 1ps

module el_latch#(
	parameter						RAIL_NUM = 2
)
(
//---------CTRL-----------------------
	input							rst,
//---------LINK-IN--------------------
	input							lat_i,
	input	[RAIL_NUM-1 : 0]		in,
//---------LINK-OUT-------------------
	output							ack_o,
	output	[RAIL_NUM-1 : 0]		out
//------------------------------------
);

reg [RAIL_NUM-1 : 0] out_r = 0;
wire ack;

assign ack = ^out_r;
assign ack_o = ack;
assign out = out_r;

always@(*)
begin
	if(rst)
	begin
		out_r = 0;
	end
	else
	begin
		if(!lat_i)
		begin
			out_r = in;
		end
	end
end



endmodule
