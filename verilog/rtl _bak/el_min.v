`timescale 1ns / 1ps

module el_min#(
	parameter						IN_NUM = 2
)
(
//---------CTRL-----------------------
	input							rst,
//---------IN-------------------------
	input							en,
	input	[IN_NUM-1 : 0]			in,
//---------OUT------------------------
	output							out
//------------------------------------
);


wire [IN_NUM-1 : 0] pair_w;
wire out_w;
assign out = out_w;

el_ed pair_det [IN_NUM-1 : 0]
(

	.rst(rst),
	
	.en(en),
	.fb(out_w),
	.in(in),
	
	.out(pair_w)
);

c_elem#
(
	.IN_NUM(IN_NUM)
)
c_agg
(
	.rst(rst),
	
	.in(pair_w),
	.out(out_w)
);



endmodule
