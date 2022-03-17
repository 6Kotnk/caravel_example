`timescale 1ns / 1ps


module el_adder#(
	parameter						WIDTH = 32,
	
	parameter						RAIL_NUM = 2,
	parameter						IN_NUM = 3,
	parameter						OUT_NUM = 2
)
(
//---------CTRL-----------------------
	input							rst,
//---------LINK-A-IN------------------
	output	[WIDTH-1 : 0]			ack_a_o,
	input	[RAIL_NUM*WIDTH-1 : 0]	in_a,
//---------LINK-B-IN------------------
	output	[WIDTH-1 : 0]			ack_b_o,
	input	[RAIL_NUM*WIDTH-1 : 0]	in_b,
//---------LINK-C-IN------------------
	output							ack_c_o,
	input	[RAIL_NUM-1 : 0]		in_c,
//---------LINK-S-OUT-----------------
	input	[WIDTH-1 : 0]			ack_s_i,
	output	[RAIL_NUM*WIDTH-1 : 0]	out_s,
//---------LINK-C-OUT-----------------
	input							ack_c_i,
	output	[RAIL_NUM-1 : 0]		out_c
//------------------------------------
);

genvar pk_idx;
genvar unpk_idx;

`define PACK_ARRAY(PK_WIDTH,PK_LEN,PK_SRC,PK_DEST) generate for (pk_idx=0; pk_idx<(PK_LEN); pk_idx=pk_idx+1) begin assign PK_DEST[((PK_WIDTH)*pk_idx+((PK_WIDTH)-1)):((PK_WIDTH)*pk_idx)] = PK_SRC[pk_idx][((PK_WIDTH)-1):0]; end endgenerate

`define UNPACK_ARRAY(PK_WIDTH,PK_LEN,PK_DEST,PK_SRC) generate for (unpk_idx=0; unpk_idx<(PK_LEN); unpk_idx=unpk_idx+1) begin assign PK_DEST[unpk_idx][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*unpk_idx+(PK_WIDTH-1)):((PK_WIDTH)*unpk_idx)]; end endgenerate


genvar fa_idx;


wire [RAIL_NUM-1 : 0] carry_chain[WIDTH : 0];
wire carry_chain_ack[WIDTH : 0];

assign carry_chain[0] = in_c;
assign out_c = carry_chain[WIDTH];

assign ack_c_o = carry_chain_ack[0];
assign carry_chain_ack[WIDTH] = ack_c_i;

// pack inputs
wire [RAIL_NUM-1 : 0] in_a_up [WIDTH-1 : 0];
`UNPACK_ARRAY(RAIL_NUM,WIDTH,in_a_up,in_a)
wire [RAIL_NUM-1 : 0] in_b_up [WIDTH-1 : 0];
`UNPACK_ARRAY(RAIL_NUM,WIDTH,in_b_up,in_b)


// unpack output
wire [RAIL_NUM-1 : 0] out_s_up [WIDTH-1 : 0];
//`PACK_ARRAY(WIDTH,RAIL_NUM,out_s_up,out_s)
`PACK_ARRAY(RAIL_NUM,WIDTH,out_s_up,out_s)



generate
	for (fa_idx = 0; fa_idx < WIDTH; fa_idx = fa_idx + 1)
	begin 
		el_fa_fl full_adder
		(
		//---------CTRL----------------
			.rst(rst),
		//---------LINK-A-IN-----------
			.ack_a_o(ack_a_o[fa_idx]),
			.in_a(in_a_up[fa_idx]),
		//---------LINK-B-IN-----------
			.ack_b_o(ack_b_o[fa_idx]),
			.in_b(in_b_up[fa_idx]),
		//---------LINK-C-IN-----------
			.ack_c_o(carry_chain_ack[fa_idx]),
			.in_c(carry_chain[fa_idx]),
		//---------LINK-S-OUT----------
			.ack_s_i(ack_s_i[fa_idx]),
			.out_s(out_s_up[fa_idx]),
		//---------LINK-C-OUT----------
			.ack_c_i(carry_chain_ack[fa_idx + 1]),
			.out_c(carry_chain[fa_idx + 1])
		//-----------------------------
		);
	end
endgenerate 


endmodule
