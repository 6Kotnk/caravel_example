`timescale 1ns / 1ps


module el_pipeline_tb();

parameter LINK_WIDTH  = 2;
parameter RAIL_NUM    = 2;
parameter PIPE_DEPTH  = 10;

wire [LINK_WIDTH*RAIL_NUM-1 : 0] in_p_tb;
reg ack_i_tb = 0;

reg rst_tb = 0;
 
wire [LINK_WIDTH*RAIL_NUM-1 : 0] out_p_tb;
wire ack_o_tb;

genvar pk_idx;
genvar unpk_idx;

`define PACK_ARRAY(PK_WIDTH,PK_LEN,PK_SRC,PK_DEST) generate for (pk_idx=0; pk_idx<(PK_LEN); pk_idx=pk_idx+1) begin assign PK_DEST[((PK_WIDTH)*pk_idx+((PK_WIDTH)-1)):((PK_WIDTH)*pk_idx)] = PK_SRC[pk_idx][((PK_WIDTH)-1):0]; end endgenerate

`define UNPACK_ARRAY(PK_WIDTH,PK_LEN,PK_DEST,PK_SRC) generate for (unpk_idx=0; unpk_idx<(PK_LEN); unpk_idx=unpk_idx+1) begin assign PK_DEST[unpk_idx][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*unpk_idx+(PK_WIDTH-1)):((PK_WIDTH)*unpk_idx)]; end endgenerate

// pack input
reg [RAIL_NUM-1 : 0] in_up_tb [LINK_WIDTH-1 : 0];


`PACK_ARRAY(RAIL_NUM,LINK_WIDTH,in_up_tb,in_p_tb)

// unpack output
wire [RAIL_NUM-1 : 0] out_up_tb [LINK_WIDTH-1 : 0];
`UNPACK_ARRAY(RAIL_NUM,LINK_WIDTH,out_up_tb,out_p_tb)




el_pipeline#
(
	.LINK_WIDTH(LINK_WIDTH),
	.RAIL_NUM(RAIL_NUM),
	.PIPE_DEPTH(PIPE_DEPTH)
)
DUT
(
    .rst(rst_tb),
    
    .ack_o(ack_o_tb),
    .in(in_p_tb),
    
    .ack_i(ack_i_tb),
    .out(out_p_tb)
);

integer in_idx;

initial
begin
    for (in_idx = 0; in_idx < RAIL_NUM ; in_idx = in_idx + 1)
    begin
        in_up_tb[in_idx] <= 0;
    end

    rst_tb = 1;
    #100;    
    rst_tb = 0;
    
    #1000;
    //in0.f
    in_up_tb[0][0] = !in_up_tb[0][0];
    #1000;  
    //in1.t
    in_up_tb[1][1] = !in_up_tb[1][1];   
    #1000;  
    
    #2000;
    //in0.f
    in_up_tb[1][0] = !in_up_tb[1][0];
    #1000;  
    //in1.t
    in_up_tb[0][1] = !in_up_tb[0][1];   
    #1000;
    
    #2000;
    ack_i_tb = !ack_i_tb;
    
    #1000;
    $finish;  
    
    
    
end

endmodule
