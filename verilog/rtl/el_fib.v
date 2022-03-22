`timescale 1ns / 1ps

module el_fib#(
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

wire [RAIL_NUM*WIDTH-1 : 0] in_a;
wire [RAIL_NUM*WIDTH-1 : 0] in_b;
wire [RAIL_NUM-1 : 0] 		in_c;

wire [RAIL_NUM*WIDTH-1 : 0] out_s;
wire [RAIL_NUM-1 : 0] out_c;

wire [RAIL_NUM*WIDTH-1 : 0] mem_1_o_b;
wire [RAIL_NUM*WIDTH-1 : 0] mem_1_o;
wire [RAIL_NUM*WIDTH-1 : 0] mem_2_o_b;
wire [RAIL_NUM*WIDTH-1 : 0] mem_2_o;
wire [RAIL_NUM*WIDTH-1 : 0] mem_1_i;
wire [RAIL_NUM*WIDTH-1 : 0] mem_2_i;


wire mem_1_ack_o;
wire mem_1_ack_i;
wire mem_2_ack_o;
wire mem_2_ack_i;


generate
	for (bus_idx = 2; bus_idx < RAIL_NUM*WIDTH; bus_idx = bus_idx + 2)
	begin 
		
		assign mem_1_o_b [bus_idx+0] = !mem_1_o [bus_idx+0];
		assign mem_1_o_b [bus_idx+1] = mem_1_o [bus_idx+1];
		
		assign mem_2_o_b [bus_idx+0] = !mem_2_o [bus_idx+0];
		assign mem_2_o_b [bus_idx+1] = mem_2_o [bus_idx+1];
		
		
	end
endgenerate 

assign mem_1_o_b [0] = mem_1_o [0];
assign mem_1_o_b [1] = !mem_1_o [1];

assign mem_2_o_b [0] = mem_2_o [0];
assign mem_2_o_b [1] = !mem_2_o [1] && start;


assign mem_1_i = out_s;

assign mem_2_i = mem_1_o_b;

assign in_a = mem_1_o_b;

assign in_b = mem_2_o_b;

assign in_c[0] = !ack_c_o; 
assign in_c[1] = 0; 

assign ack_c = ^out_c;

assign ack_o = ack_c_o;



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
	//.ack_s_i(ack_s),
	.out_s(out_s),
//---------LINK-C-OUT----------
	//.ack_c_i(ack_c),
	.out_c(out_c),
//-----------------------------
	.ack_i(ack_s)
);


/*

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
	.out_s(),
//---------LINK-C-OUT----------
	.out_c(),
//-----------------------------
	.ack_i(ack_s)
);




//assign ack_a = 0;
//assign ack_b = 0;
//assign ack_c_o = 0;

assign out_s = 0;
assign out_c = 0;
*/


assign out = mem_2_o;


c_elem#
(
	.IN_NUM(2)
)
c_join_mem1
(
	.rst(rst),
	
	.in({ack_a,mem_2_ack_o}),
	.out(mem_1_ack_i)
);


c_elem#
(
	.IN_NUM(2)
)
c_join_mem2
(
	.rst(rst),
	
	.in({ack_c_o,ack_i}),
	.out(mem_2_ack_i)
);



el_link#
(
	.LINK_WIDTH(WIDTH),
	.RAIL_NUM(RAIL_NUM)
)
mem_1
(
	.rst(rst),
	
	.ack_o(mem_1_ack_o),
	.in(mem_1_i),
	
	.ack_i(!mem_1_ack_i),
	.out(mem_1_o)
);
		
el_link#
(
	.LINK_WIDTH(WIDTH),
	.RAIL_NUM(RAIL_NUM)
)
mem_2
(
	.rst(rst),
	
	.ack_o(mem_2_ack_o),
	.in(mem_2_i),
	
	.ack_i(!mem_2_ack_i),
	.out(mem_2_o)
);		

assign ack_s = mem_1_ack_o;



endmodule
