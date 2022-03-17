`timescale 1ns / 1ps

module el_adder_linked#(
	parameter						WIDTH = 32,
	
	parameter						RAIL_NUM = 2,
	parameter						IN_NUM = 3,
	parameter						OUT_NUM = 2
)
(
//---------CTRL-----------------------
	input							rst,
//---------LINK-A-IN------------------
	output							ack_a_o,
	input	[RAIL_NUM*WIDTH-1 : 0]	in_a,
//---------LINK-B-IN------------------
	output							ack_b_o,
	input	[RAIL_NUM*WIDTH-1 : 0]	in_b,
//---------LINK-C-IN------------------
	output							ack_c_o,
	input	[RAIL_NUM-1 : 0]		in_c,
//---------LINK-S-OUT-----------------
	output	[RAIL_NUM*WIDTH-1 : 0]	out_s,
//---------LINK-C-OUT-----------------
	output	[RAIL_NUM-1 : 0]		out_c,
//------------------------------------
	input							ack_i
);


wire [WIDTH : 0] ack_i_link;
assign ack_i_link = {(WIDTH + 1){ack_i}};

wire [WIDTH-1 : 0] ack_add_s;
assign ack_add_s = {WIDTH{ack_add}};

wire ack_add;

wire [WIDTH-1 : 0] ack_a;
wire [WIDTH-1 : 0] ack_b;

wire [RAIL_NUM*WIDTH-1 : 0] out_s_add;
wire [RAIL_NUM-1 : 0] out_c_add;

el_adder #
(
	.WIDTH(WIDTH)
)
adder
(
//---------CTRL----------------
	.rst(rst),
//---------LINK-A-IN-----------
	.ack_a_o(ack_a),
	.in_a(in_a),
//---------LINK-B-IN-----------
	.ack_b_o(ack_b),
	.in_b(in_b),
//---------LINK-C-IN-----------
	.ack_c_o(ack_c_o),
	.in_c(in_c),
//---------LINK-S-OUT----------
	.ack_s_i(ack_add_s),
	.out_s(out_s_add),
//---------LINK-C-OUT----------
	.ack_c_i(ack_add),
	.out_c(out_c_add)
//-----------------------------
);


wire ack_l;
wire [RAIL_NUM*(WIDTH + 1)-1 : 0] dat_l;


el_link#
(
	.LINK_WIDTH(WIDTH + 1),
	.RAIL_NUM(RAIL_NUM)
)
link_1
(
	.rst(rst),
	
	.ack_o(ack_add),
	.in({out_c_add,out_s_add}),
	
	.ack_i(ack_l),
	.out(dat_l)
);

el_link#
(
	.LINK_WIDTH(WIDTH + 1),
	.RAIL_NUM(RAIL_NUM)
)
link_2
(
	.rst(rst),
	
	.ack_o(ack_l),
	.in(dat_l),
	
	.ack_i(ack_i),
	.out({out_c,out_s})
);



c_elem#
(
	.IN_NUM(WIDTH)
)
c_join_a
(
	.rst(rst),
	
	.in(ack_a),
	.out(ack_a_o)
);

c_elem#
(
	.IN_NUM(WIDTH)
)
c_join_b
(
	.rst(rst),
	
	.in(ack_b),
	.out(ack_b_o)
);



endmodule
