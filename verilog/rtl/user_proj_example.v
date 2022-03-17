// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */


module user_proj_example #(
	parameter BITS = 32
)(
`ifdef USE_POWER_PINS
	inout vccd1,	// User area 1 1.8V supply
	inout vssd1,	// User area 1 digital ground
`endif

	// Wishbone Slave ports (WB MI A)
	input wb_clk_i,
	input wb_rst_i,
	input wbs_stb_i,
	input wbs_cyc_i,
	input wbs_we_i,
	input [3:0] wbs_sel_i,
	input [31:0] wbs_dat_i,
	input [31:0] wbs_adr_i,
	output wbs_ack_o,
	output [31:0] wbs_dat_o,

	// Logic Analyzer Signals
	input  [127:0] la_data_in,
	output [127:0] la_data_out,
	input  [127:0] la_oenb,

	// IOs
	input  [`MPRJ_IO_PADS-1:0] io_in,
	output [`MPRJ_IO_PADS-1:0] io_out,
	output [`MPRJ_IO_PADS-1:0] io_oeb,

	// IRQ
	output [2:0] irq
);

	parameter RAIL_NUM = 2;


	// IO
	assign io_out = {{(`MPRJ_IO_PADS-1-BITS){1'b0}},count};
	//assign io_out = {(`MPRJ_IO_PADS-1){1'b0}};
	assign io_oeb = {(`MPRJ_IO_PADS-1){1'b0}};

	wire [`MPRJ_IO_PADS-1:0] io_in;
	wire [`MPRJ_IO_PADS-1:0] io_out;
	wire [`MPRJ_IO_PADS-1:0] io_oeb;

	
	// FIB lines
	
	wire start;

	wire ack_i;
	wire ack_o;

	wire [BITS*RAIL_NUM-1 : 0] out;
	wire [BITS-1 : 0] count;


	// IRQ
	assign irq = 3'b000;	// Unused

	// LA
	assign la_data_out = {{((128-1)-((1 + RAIL_NUM)*BITS)){1'b1}}, ack_o, count, out};  //ack_o @ 96
	
	//assign ack_o = 0;
	//assign count = 0;
	//assign out = 0;
		
	//assign la_data_out = 0;
	assign start = la_data_in[124];
	assign ack_i = la_data_in[125];

	//assign start = 0;
	//assign ack_i = 0;

	assign wbs_ack_o = 0;
	assign wbs_dat_o = 0;

//---------------------------------------------------------------------------------------//

	genvar bus_idx;
	
	generate
		for (bus_idx = 0; bus_idx < BITS ; bus_idx = bus_idx + 1)
		begin 
		
			el_sync sync
			(
				.rst(wb_rst_i),
				.clk(wb_clk_i),
				
				.in_async(out[2*bus_idx +: 2]),
				.in_ack(ack_o),
				
				.out_sync(count[bus_idx])
				
			);
			
		end
	endgenerate 

	

	
	el_fib#
	(
		.WIDTH(BITS)
	)
	FIB
	(
	    .rst(wb_rst_i),
	    .start(start),
	    
	    .ack_i(ack_i),
	    .ack_o(ack_o),
	    .out(out)
	    
	);
	
//---------------------------------------------------------------------------------------//	


endmodule

`default_nettype wire







































