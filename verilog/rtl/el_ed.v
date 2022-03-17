`timescale 1ns / 1ps

module el_ed
(
//---------CTRL-----------------------
	input							rst,
//---------IN-------------------------
	input							en,
	input							fb,
	input							in,
//---------OUT------------------------
	output							out
//------------------------------------
);

reg state_r = 0;

assign out = state_r ^ in;

always@(*)
begin
	if(rst)
	begin
		state_r = 0;
	end
	else
	begin
		if(en)
		begin
			state_r = in ^ fb;
		end
	end
end



endmodule
