`timescale 1ns / 1ps

module el_sync
(
//---------CTRL-----------------------
	input							rst,
	input							clk,
//---------IN-------------------------
	input [1:0]						in_async,
	input							in_ack,
//---------OUT------------------------
	output							out_sync
//------------------------------------
);

reg [1:0] sync;

reg [1:0] ack_dly;

always@(posedge clk)
begin
	if(rst)
	begin
		ack_dly <= 0;
	end
	ack_dly[0] <= in_ack;
	ack_dly[1] <= ack_dly[0];
end


always@(posedge clk)
begin
	if(rst)
	begin
		sync <= 0;
	end
	else if(ack_dly[1] ^^ ack_dly[0])
	begin
		sync <= {sync[0],in_async[1]};
	end
end

assign out_sync = ^sync;

endmodule
