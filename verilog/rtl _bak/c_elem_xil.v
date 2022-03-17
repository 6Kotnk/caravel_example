`timescale 1ns / 1ps

module c_elem#(
	parameter						IN_NUM = 2
)
(
//---------CTRL-----------------------
	input							rst,
//---------IN-------------------------
	input	[IN_NUM-1 : 0]			in,
//---------OUT------------------------
	output							out
//------------------------------------
);

wire r;
//assign #IN_NUM r = !(|in);
assign r = !(|in);

wire s;
//assign #IN_NUM s = &in;
assign s = &in;

rs_lat lat
(

	.rst(rst),
	
	.r(r),
	.s(s),
	.out(out)
);

endmodule
