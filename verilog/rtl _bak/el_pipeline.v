`timescale 1ns / 1ps


module el_pipeline#(
	parameter						LINK_WIDTH  = 2,
	parameter						RAIL_NUM    = 2,
	parameter						PIPE_DEPTH  = 10
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

genvar pipe_idx;

wire [LINK_WIDTH*RAIL_NUM-1 : 0] pipe_data[PIPE_DEPTH : 0];
wire  pipe_ack [PIPE_DEPTH : 0];

assign pipe_data[0] = in;
assign out = pipe_data[PIPE_DEPTH];

assign pipe_ack[PIPE_DEPTH] = ack_i;
assign ack_o = pipe_ack[0];

generate
	for (pipe_idx = 0; pipe_idx < PIPE_DEPTH ; pipe_idx = pipe_idx + 1)
	begin 
	
		el_link#
		(
		    .LINK_WIDTH(LINK_WIDTH),
			.RAIL_NUM(RAIL_NUM)
		)
		el_link
		(
			.rst(rst),
			
			.ack_o(pipe_ack[pipe_idx]),
			.in(pipe_data[pipe_idx]),
			
			.ack_i(pipe_ack[pipe_idx+1]),
			.out(pipe_data[pipe_idx+1])
		);
		
	end
endgenerate 


endmodule
