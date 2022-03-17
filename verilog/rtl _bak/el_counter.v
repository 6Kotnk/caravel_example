`timescale 1ns / 1ps

module el_counter#(
	parameter						WIDTH = 32,
	
	parameter						RAIL_NUM = 2,
	parameter						IN_NUM = 3,
	parameter						OUT_NUM = 2
)
(
//---------CTRL-----------------------
	input							rst,
	input							start,
//---------OUTPUT-LINK----------------
	input							ack_i,
	output							ack_o,
	output	[RAIL_NUM*WIDTH-1 : 0]	out
//------------------------------------
);

genvar pk_idx;
genvar unpk_idx;

`define PACK_ARRAY(PK_WIDTH,PK_LEN,PK_SRC,PK_DEST) generate for (pk_idx=0; pk_idx<(PK_LEN); pk_idx=pk_idx+1) begin assign PK_DEST[((PK_WIDTH)*pk_idx+((PK_WIDTH)-1)):((PK_WIDTH)*pk_idx)] = PK_SRC[pk_idx][((PK_WIDTH)-1):0]; end endgenerate

`define UNPACK_ARRAY(PK_WIDTH,PK_LEN,PK_DEST,PK_SRC) generate for (unpk_idx=0; unpk_idx<(PK_LEN); unpk_idx=unpk_idx+1) begin assign PK_DEST[unpk_idx][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*unpk_idx+(PK_WIDTH-1)):((PK_WIDTH)*unpk_idx)]; end endgenerate

genvar bus_idx;

wire ack_a;
wire ack_b;
wire ack_c_o;

wire ack_s;
wire ack_c;

wire [RAIL_NUM*WIDTH-1 : 0] loop;

wire [RAIL_NUM*WIDTH-1 : 0] in_a;
wire [RAIL_NUM*WIDTH-1 : 0] in_b;
wire [RAIL_NUM-1 : 0] 		in_c;

wire [RAIL_NUM-1 : 0] out_c;



generate
	for (bus_idx = 0; bus_idx < RAIL_NUM*WIDTH; bus_idx = bus_idx + 2)
	begin 
		assign in_a [bus_idx+0] = loop [bus_idx+0] ^ start;
		assign in_a [bus_idx+1] = loop [bus_idx+1];
		
		assign in_b [bus_idx+0] = {ack_s ^ start};
		assign in_b [bus_idx+1] = 0;
	end
endgenerate 




assign in_c[0] = start; 
assign in_c[1] = ack_s; 

//assign ack_c = ^out_c;

assign ack_o = ack_s;

el_adder_linked#
(
	.WIDTH(WIDTH)
)
adder_l
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
	.out_s(loop),
//---------LINK-C-OUT----------
	.out_c(out_c),
//-----------------------------
	.ack_i(!ack_s)
);

assign out = loop;


c_elem#
(
	.IN_NUM(2)
)
c_join_out
(
	.rst(rst),
	
	.in({ack_c_o,ack_i}),
	.out(ack_s)
);


endmodule
