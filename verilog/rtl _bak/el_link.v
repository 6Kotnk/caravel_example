`timescale 1ns / 1ps


module el_link#(
	parameter						LINK_WIDTH = 2,
	parameter						RAIL_NUM   = 2
)
(
//---------CTRL-----------------------
	input									rst,
//---------LINK-IN--------------------
	output									ack_o,
	input	[LINK_WIDTH*RAIL_NUM-1 : 0]		in,
//---------LINK-OUT-------------------
	input									ack_i,
	output	[LINK_WIDTH*RAIL_NUM-1 : 0]		out
//------------------------------------
);

genvar pk_idx;
genvar unpk_idx;

`define PACK_ARRAY(PK_WIDTH,PK_LEN,PK_SRC,PK_DEST) generate for (pk_idx=0; pk_idx<(PK_LEN); pk_idx=pk_idx+1) begin assign PK_DEST[((PK_WIDTH)*pk_idx+((PK_WIDTH)-1)):((PK_WIDTH)*pk_idx)] = PK_SRC[pk_idx][((PK_WIDTH)-1):0]; end endgenerate

`define UNPACK_ARRAY(PK_WIDTH,PK_LEN,PK_DEST,PK_SRC) generate for (unpk_idx=0; unpk_idx<(PK_LEN); unpk_idx=unpk_idx+1) begin assign PK_DEST[unpk_idx][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*unpk_idx+(PK_WIDTH-1)):((PK_WIDTH)*unpk_idx)]; end endgenerate

// pack input
wire [RAIL_NUM-1 : 0] in_up [LINK_WIDTH-1 : 0];
`UNPACK_ARRAY(RAIL_NUM,LINK_WIDTH,in_up,in)

// unpack output
wire [RAIL_NUM-1 : 0] out_up [LINK_WIDTH-1 : 0];
`PACK_ARRAY(RAIL_NUM,LINK_WIDTH,out_up,out)


wire [LINK_WIDTH-1:0] ack_bit;
wire ack_link;
wire lat_en;

assign lat_en = ack_link ^ ack_i;
assign ack_o = ack_link;

genvar bit_idx;

generate
	for (bit_idx = 0; bit_idx < LINK_WIDTH ; bit_idx = bit_idx + 1)
	begin 
	
		el_latch#
		(
			.RAIL_NUM(RAIL_NUM)
		)
		latch
		(
			.rst(rst),
			
			.in(in_up[bit_idx]),
			.lat_i(lat_en),
			
			.ack_o(ack_bit[bit_idx]),
			.out(out_up[bit_idx])
		);
		
	end
endgenerate 


c_elem#
(
	.IN_NUM(LINK_WIDTH)
)
c_collector
(
	.rst(rst),
	
	.in(ack_bit),
	.out(ack_link)
);




endmodule
