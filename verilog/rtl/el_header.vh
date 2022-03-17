//A gift from the god mrflibble
//https://www.edaboard.com/threads/how-to-declare-two-dimensional-input-ports-in-verilog.80929/
genvar pk_idx;
genvar unpk_idx;
//genvar tw_idx;
//genvar tl_idx;

`define PACK_ARRAY(PK_WIDTH,PK_LEN,PK_SRC,PK_DEST) generate for (pk_idx=0; pk_idx<(PK_LEN); pk_idx=pk_idx+1) begin assign PK_DEST[((PK_WIDTH)*pk_idx+((PK_WIDTH)-1)):((PK_WIDTH)*pk_idx)] = PK_SRC[pk_idx][((PK_WIDTH)-1):0]; end endgenerate

`define UNPACK_ARRAY(PK_WIDTH,PK_LEN,PK_DEST,PK_SRC) generate for (unpk_idx=0; unpk_idx<(PK_LEN); unpk_idx=unpk_idx+1) begin assign PK_DEST[unpk_idx][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*unpk_idx+(PK_WIDTH-1)):((PK_WIDTH)*unpk_idx)]; end endgenerate

//`define TRANSPOSE_ARRAY(WIDTH,LEN,SRC,DEST) generate for (tw_idx=0; tw_idx<(WIDTH); tw_idx=tw_idx+1) begin for (tl_idx=0; tl_idx<(WIDTH); tl_idx=tl_idx+1) begin assign DEST[tw_idx][tl_idx] = SRC[tl_idx][tw_idx]; end end endgenerate
