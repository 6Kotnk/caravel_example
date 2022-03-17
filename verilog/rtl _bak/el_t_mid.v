`timescale 1ns / 1ps

module el_t_mid#(
	parameter						IN_NUM = 3
)
(
//------------------------------------
	input	[IN_NUM-1 : 0]			in,
//---------OUT------------------------
	output							out
//------------------------------------
);

localparam SUM_W = 32; //Could use clog2, dont want to risk it being unsuported

reg [SUM_W - 1:0] sum = 0;
reg out_r = 0;
assign out = out_r;

integer in_idx;

always@(*)
begin
	sum = 0;
	for (in_idx = 0; in_idx < IN_NUM; in_idx = in_idx + 1)
	begin 
		sum = sum + in[in_idx];
	end
	if(sum >= ((IN_NUM+1)/2) )
	begin
		out_r = 1;
	end
	else
	begin
		out_r = 0;
	end
	
	
end

endmodule
