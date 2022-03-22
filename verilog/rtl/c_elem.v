`timescale 1ns / 1ps

module c_elem#(
	parameter						IN_NUM = 2
)
(
//---------CTRL-----------------------
	input							rst,
//---------IN-------------------------
	input	[IN_NUM-1 : 0]					in,
//---------OUT------------------------
	output							out
//------------------------------------
);

/*
wire [IN_NUM-1 : 0] in_rst;
assign in_rst = in & ({IN_NUM{!rst}});
*/
reg out_r = 0;

assign out = out_r;

always@(*)
begin
	if(rst)
	begin
		out_r = 0;
	end
	else
	begin
		if(!(|in))
		begin
			out_r = 0;
		end
		if(&in)
		begin
			out_r = 1;
		end
	end
end



endmodule
