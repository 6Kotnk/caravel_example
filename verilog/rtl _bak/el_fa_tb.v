`timescale 1ns / 1ps


module el_fa_tb();

parameter						RAIL_NUM = 2;
parameter						IN_NUM = 3;
parameter						OUT_NUM = 2;

wire ack_a_o_tb;
wire ack_b_o_tb;
wire ack_c_o_tb;

reg ack_s_i_tb = 0;
reg ack_c_i_tb = 0;

reg [1:0] in_a_tb = 0;
reg [1:0] in_b_tb = 0;
reg [1:0] in_c_tb = 0;

wire [1:0] out_s_tb;
wire [1:0] out_c_tb;



reg rst_tb;


el_fa_fl DUT
(
//---------CTRL----------------
	.rst(rst_tb),
//---------LINK-A-IN-----------
	.ack_a_o(ack_a_o_tb),
	.in_a(in_a_tb),
//---------LINK-B-IN-----------
	.ack_b_o(ack_b_o_tb),
	.in_b(in_b_tb),
//---------LINK-C-IN-----------
	.ack_c_o(ack_c_o_tb),
	.in_c(in_c_tb),
//---------LINK-S-OUT----------
	.ack_s_i(ack_s_i_tb),
	.out_s(out_s_tb),
//---------LINK-C-OUT----------
	.ack_c_i(ack_c_i_tb),
	.out_c(out_c_tb)
//-----------------------------
);

initial
begin

    rst_tb = 1;
    #100;    
    rst_tb = 0;
    #1000;
	

	
    //a.1
    in_a_tb[0] = !in_a_tb[0];
    #100;  
    //b.0
    in_b_tb[0] = !in_b_tb[0]; 
    #100;  
    //c.1
    in_c_tb[0] = !in_c_tb[0]; 
    #100;  
	
	//ack
    #2000;
	ack_s_i_tb = !ack_s_i_tb;
	#100; 
	ack_c_i_tb = !ack_c_i_tb;
	#2000;
	
	
	//a.0
    in_a_tb[0] = !in_a_tb[0];
    #100;  
    //b.0
    in_b_tb[0] = !in_b_tb[0]; 
    #100;  
    //c.0
    in_c_tb[1] = !in_c_tb[1]; 
    #100;  
	
	//ack
    #2000;
	ack_s_i_tb = !ack_s_i_tb;
	#100; 
	ack_c_i_tb = !ack_c_i_tb;
	#2000;
	
	
	
	//a.1
    in_a_tb[1] = !in_a_tb[1];
    #100;  
    //b.1
    in_b_tb[0] = !in_b_tb[0]; 
    #100;  
    //c.1
    in_c_tb[1] = !in_c_tb[1]; 
    #100;  
	
	//ack
    #2000;
	ack_s_i_tb = !ack_s_i_tb;
	#100; 
	ack_c_i_tb = !ack_c_i_tb;
	#2000;
	
		//a.1
    in_a_tb[0] = !in_a_tb[0];
    #100;  
    //b.1
    in_b_tb[1] = !in_b_tb[1]; 
    #100;  
    //c.1
    in_c_tb[1] = !in_c_tb[1]; 
    #100;  
	
	//ack
    #2000;
	ack_s_i_tb = !ack_s_i_tb;
	#100; 
	ack_c_i_tb = !ack_c_i_tb;
	#2000;
	
		//a.1
    in_a_tb[1] = !in_a_tb[1];
    #100;  
    //b.1
    in_b_tb[1] = !in_b_tb[1]; 
    #100;  
    //c.1
    in_c_tb[1] = !in_c_tb[1]; 
    #100;  
	
	//ack
    #2000;
	ack_s_i_tb = !ack_s_i_tb;
	#100; 
	ack_c_i_tb = !ack_c_i_tb;
	#2000;
	
    
    #1000;
    $finish;  
    
    
    
end

endmodule
