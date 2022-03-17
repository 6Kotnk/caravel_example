`timescale 1ns / 1ps


module el_fib_impl_top
(
//---------CTRL-----------------------
	input								btnC,
	input								CLK100MHZ,
//---------INPUTS---------------------
	input	[15:0]							sw,
//---------OUTPUTS--------------------
	output	[15:0]							LED
//------------------------------------
);

parameter WIDTH  	   	= 8;
parameter RAIL_NUM    		= 2;

parameter COUNT_MAX  		= 255;



wire									rst;
wire									start;

//vio
wire									ack_i;
wire									ack_o;

wire	[WIDTH*RAIL_NUM-1 : 0]						out;
wire	[WIDTH-1 : 0]							count;

assign rst = btnC;
assign LED = count;




//---------------------------------------------------//

vio_0
(
    .clk(CLK100MHZ),
    
    .probe_in0(ack_o),
    .probe_in1(out),
    .probe_in2(count),
    
    .probe_out0(ack_i),
    .probe_out1(start)
    
);


genvar bus_idx;

generate
	for (bus_idx = 0; bus_idx < WIDTH ; bus_idx = bus_idx + 1)
	begin 
	
		el_sync sync
		(
			.rst(rst),
			.clk(CLK100MHZ),
			
			.in_async(out[2*bus_idx +: 2]),
			.in_ack(ack_o ^ ack_i),
			
			.out_sync(count[bus_idx])
			
		);
		
	end
endgenerate 

el_fib#
(
	.WIDTH(WIDTH)
)
FIB
(
    .rst(rst),
    .start(start),
    
    .ack_i(ack_i),
    .ack_o(ack_o),
    .out(out)
    
);




endmodule
