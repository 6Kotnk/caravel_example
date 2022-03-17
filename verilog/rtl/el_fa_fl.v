`timescale 1ns / 1ps

module el_fa_fl#(
	parameter						RAIL_NUM = 2,
	parameter						IN_NUM = 3,
	parameter						OUT_NUM = 2
)
(
//---------CTRL-----------------------
	input							rst,
//---------LINK-A-IN------------------
	output							ack_a_o,
	input	[RAIL_NUM-1 : 0]		in_a,
//---------LINK-B-IN------------------
	output							ack_b_o,
	input	[RAIL_NUM-1 : 0]		in_b,
//---------LINK-C-IN------------------
	output							ack_c_o,
	input	[RAIL_NUM-1 : 0]		in_c,
//---------LINK-S-OUT-----------------
	input							ack_s_i,
	output	[RAIL_NUM-1 : 0]		out_s,
//---------LINK-C-OUT-----------------
	input							ack_c_i,
	output	[RAIL_NUM-1 : 0]		out_c
//------------------------------------
);



//curr stage
wire done_in;


wire ack_done;

assign ack_a_o = ack_done;
assign ack_b_o = ack_done;
assign ack_c_o = ack_done;


wire en_c;
assign en_c = c_done ^ ack_c_i;

wire en_s;
assign en_s = s_done ^ ack_s_i;

wire [RAIL_NUM-1 : 0] ed_a_c;
wire [RAIL_NUM-1 : 0] ed_b_c;
wire [RAIL_NUM-1 : 0] ed_cin_c;

wire [RAIL_NUM-1 : 0] ed_a_s;
wire [RAIL_NUM-1 : 0] ed_b_s;
wire [RAIL_NUM-1 : 0] ed_cin_s;
wire [RAIL_NUM-1 : 0] ed_cout_s;

wire [RAIL_NUM-1 : 0] out_c_w;
wire [RAIL_NUM-1 : 0] out_s_w;



//------------------------------------
// Carry generaion
//------------------------------------
el_ed a_cout [RAIL_NUM-1 : 0]
(

	.rst(rst),
	
	.en(en_c),
	.fb(out_c_w),
	.in(in_a),
	
	.out(ed_a_c)
);
el_ed b_cout [RAIL_NUM-1 : 0]
(

	.rst(rst),
	
	.en(en_c),
	.fb(out_c_w),
	.in(in_b),
	
	.out(ed_b_c)
);
el_ed cin_cout [RAIL_NUM-1 : 0]
(

	.rst(rst),
	
	.en(en_c),
	.fb(out_c_w),
	.in(in_c),
	
	.out(ed_cin_c)
);

el_t_mid#
(
	.IN_NUM(3)
)
c_0
(

	.in({ed_a_c[0],ed_b_c[0],ed_cin_c[0]}),
	.out(out_c_w[0])

);
el_t_mid#
(
	.IN_NUM(3)
)
c_1
(

	.in({ed_a_c[1],ed_b_c[1],ed_cin_c[1]}),
	.out(out_c_w[1])

);

//------------------------------------
// Sum generaion
//------------------------------------
el_ed a_s [RAIL_NUM-1 : 0]
(

	.rst(rst),
	
	.en(en_s),
	.fb(out_s_w),
	.in(in_a),
	
	.out(ed_a_s)
);
el_ed b_s [RAIL_NUM-1 : 0]
(

	.rst(rst),
	
	.en(en_s),
	.fb(out_s_w),
	.in(in_b),
	
	.out(ed_b_s)
);
el_ed cin_s [RAIL_NUM-1 : 0]
(

	.rst(rst),
	
	.en(en_s),
	.fb(out_s_w),
	.in(in_c),
	
	.out(ed_cin_s)
);
el_ed cout_s [RAIL_NUM-1 : 0]
(

	.rst(rst),
	
	.en(en_s),
	.fb({out_s_w[0],out_s_w[1]}),
	.in(out_c_w),
	
	.out(ed_cout_s)
);


el_t_mid#
(
	.IN_NUM(5)
)
s_0
(

	.in({ed_a_s[0],ed_b_s[0],ed_cin_s[0],ed_cout_s[1],ed_cout_s[1]}),
	.out(out_s_w[0])

);
el_t_mid#
(
	.IN_NUM(5)
)
s_1
(

	.in({ed_a_s[1],ed_b_s[1],ed_cin_s[1],ed_cout_s[0],ed_cout_s[0]}),
	.out(out_s_w[1])

);

//------------------------------------
// Acks
//------------------------------------

assign out_s = out_s_w;
assign out_c = out_c_w;

wire c_done_out;
wire s_done_out;

assign s_done_out = ^out_s_w;
assign c_done_out = ^out_c_w;

wire c_done;
wire s_done;

wire ack_c;
wire ack_s;

c_elem#
(
	.IN_NUM(IN_NUM)
)
in_agg
(
	.rst(rst),
	
	.in({^in_a,^in_b,^in_c}),
	.out(done_in)
);



c_elem#
(
	.IN_NUM(2)
)
c_agg
(
	.rst(rst),
	
	.in({c_done_out,done_in}),
	.out(c_done)
);

c_elem#
(
	.IN_NUM(2)
)
c_ack
(
	.rst(rst),
	
	.in({c_done,ack_c_i}),
	.out(ack_c)
);



c_elem#
(
	.IN_NUM(2)
)
s_agg
(
	.rst(rst),
	
	.in({s_done_out,c_done}),
	.out(s_done)
);




c_elem#
(
	.IN_NUM(2)
)
s_ack
(
	.rst(rst),
	
	.in({s_done,ack_s_i}),
	.out(ack_s)
);


c_elem#
(
	.IN_NUM(2)
)
ack_join
(
	.rst(rst),
	
	.in({ack_c,ack_s}),
	.out(ack_done)
);


endmodule
