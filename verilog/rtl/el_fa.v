`timescale 1ns / 1ps

module el_fa#(
	parameter						RAIL_NUM = 2,
	parameter						IN_NUM = 3,
	parameter						OUT_NUM = 2
)
(
//---------CTRL-----------------------
	input							rst,
//---------GLBL-----------------------
	output							lat_en_o,
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


//next stage
wire ack_join;
//curr stage
wire ack_done;

assign ack_a_o = ack_done;
assign ack_b_o = ack_done;
assign ack_c_o = ack_done;

wire [RAIL_NUM-1 : 0] ack_i;
assign ack_i = {ack_s_i, ack_c_i};

wire lat_en;
assign lat_en = ack_done ^ ack_join;

assign lat_en_o = lat_en;

wire [2**IN_NUM-1:0] min_bus;


genvar min_idx;

generate
	for (min_idx = 0; min_idx < 2**IN_NUM; min_idx = min_idx + 1)
	begin 
		
		
		el_min#
		(
			.IN_NUM(IN_NUM)
		)
		 min
		(

			.rst(rst),
			
			.en(lat_en),
			.in({in_a[min_idx[0]],in_b[min_idx[1]],in_c[min_idx[2]]}),
			
			.out(min_bus[min_idx])
		);
		
	end
endgenerate 

wire [RAIL_NUM-1:0] out_s_w;
wire [RAIL_NUM-1:0] out_c_w;

assign out_s = out_s_w;
assign out_c = out_c_w;

wire [OUT_NUM-1:0] out_done;


assign out_s_w[0] = ^{min_bus[0],min_bus[3],min_bus[5],min_bus[6]};
assign out_s_w[1] = ^{min_bus[1],min_bus[2],min_bus[4],min_bus[7]};
assign out_done[0] = ^out_s_w;

assign out_c_w[0] = ^{min_bus[0],min_bus[1],min_bus[2],min_bus[4]};
assign out_c_w[1] = ^{min_bus[3],min_bus[5],min_bus[6],min_bus[7]};
assign out_done[1] = ^out_c_w;

c_elem#
(
	.IN_NUM(OUT_NUM)
)
c_agg
(
	.rst(rst),
	
	.in(out_done),
	.out(ack_done)
);

c_elem#
(
	.IN_NUM(OUT_NUM)
)
c_join
(
	.rst(rst),
	
	.in(ack_i),
	.out(ack_join)
);

endmodule
