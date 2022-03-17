`timescale 1ns / 1ps


module el_fib_tb();

parameter WIDTH	= 32;
parameter RAIL_NUM	= 2;

reg rst_tb = 0;
reg start_tb = 0;
 

reg ack_i_tb = 0;
wire ack_o_tb;

wire [WIDTH-1 : 0] count_tb;

genvar pk_idx;
genvar unpk_idx;

`define PACK_ARRAY(PK_WIDTH,PK_LEN,PK_SRC,PK_DEST) generate for (pk_idx=0; pk_idx<(PK_LEN); pk_idx=pk_idx+1) begin assign PK_DEST[((PK_WIDTH)*pk_idx+((PK_WIDTH)-1)):((PK_WIDTH)*pk_idx)] = PK_SRC[pk_idx][((PK_WIDTH)-1):0]; end endgenerate

`define UNPACK_ARRAY(PK_WIDTH,PK_LEN,PK_DEST,PK_SRC) generate for (unpk_idx=0; unpk_idx<(PK_LEN); unpk_idx=unpk_idx+1) begin assign PK_DEST[unpk_idx][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*unpk_idx+(PK_WIDTH-1)):((PK_WIDTH)*unpk_idx)]; end endgenerate

// unpack output
wire [RAIL_NUM-1 : 0] out_up_tb [WIDTH-1 : 0];
wire [WIDTH*RAIL_NUM-1 : 0] out_p_tb;
`UNPACK_ARRAY(RAIL_NUM,WIDTH,out_up_tb,out_p_tb)




el_fib#
(
	.WIDTH(WIDTH)
)
DUT
(
    .rst(rst_tb),
    .start(start_tb),
    
    .ack_i(ack_i_tb),
    .ack_o(ack_o_tb),
    .out(out_p_tb)
    
);

reg CLK = 0;
always
begin
    #5 CLK = !CLK;
end

genvar bus_idx;

generate
	for (bus_idx = 0; bus_idx < WIDTH ; bus_idx = bus_idx + 1)
	begin 
	
		el_sync sync
		(
			.rst(rst_tb),
			.clk(CLK),
			
			.in_async(out_up_tb[bus_idx]),
			.in_ack(ack_o_tb ^ ack_i_tb),
			
			.out_sync(count_tb[bus_idx])
			
		);
		
	end
endgenerate 


integer out_idx = 0;

initial
begin



    rst_tb = 1;
    #100;    
    rst_tb = 0;
    #1000; 
	
	start_tb = !start_tb;
	
	for (out_idx = 0; out_idx < 20 ; out_idx = out_idx + 1)
    begin
		@ack_o_tb;
		#500;
		ack_i_tb = !ack_i_tb;
    end
    
    #1000;
    $finish;  
    
    
    
end

endmodule
