`timescale 1ns / 1ps

module rs_lat
(
//---------CTRL-----------------------
	input							rst,
//---------IN-------------------------
	input							r,
	input							s,
//---------OUT------------------------
	output							out
//------------------------------------
);
/*
LDCE #(
	.INIT(0), // Initial value of latch, 1’b0, 1’b1
	// Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
	.IS_CLR_INVERTED(1'b0), // Optional inversion for CLR
	.IS_G_INVERTED(1'b0) // Optional inversion for G
)
LDCE_inst (
	.Q(out), // 1-bit output: Data
	.CLR(r), // 1-bit input: Asynchronous clear
	.D(1'b1), // 1-bit input: Data
	.G(s), // 1-bit input: Gate
	.GE(1'b1) // 1-bit input: Gate enable
);
*/

endmodule
