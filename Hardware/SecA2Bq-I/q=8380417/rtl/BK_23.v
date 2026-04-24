`include "define.v"

(*keep_hirearchy = "true",dont_touch = "true"*) module BK_23 # (
    localparam N = `N,
    localparam K = `K
)
(
    input [2*K-1:0] x,
    input [2*K-1:0] y,
    input [75*8-1:0] tb_and,
    // debug
//    input [2*K-1:0] rf,
//    input [59:0] rt,
    output [2*K-1:0] z,
    output [1:0] mc
);
    
    
    (* DONT_TOUCH="true" *) wire [2*K-1:0] p0;
    (* DONT_TOUCH="true" *) wire [2*K-1:0] g0;
    (* DONT_TOUCH="true" *) wire [2*(K/2)-3:0] p1;
    (* DONT_TOUCH="true" *) wire [2*(K/2)-1:0] g1;
    (* DONT_TOUCH="true" *) wire [2*(K/4)-3:0] p2;
    (* DONT_TOUCH="true" *) wire [2*(K/4)-1:0] g2;
    (* DONT_TOUCH="true" *) wire [2*(K/8)-3:0] p3;
    (* DONT_TOUCH="true" *) wire [2*(K/8)-1:0] g3;
    (* DONT_TOUCH="true" *) wire [2*(K/16)-1:0] g4;
    (* DONT_TOUCH="true" *) wire [2*(K/2)-1:0] t0;
    (* DONT_TOUCH="true" *) wire [2*(K/4)-1:0] t1;
    (* DONT_TOUCH="true" *) wire [2*(K/8)-1:0] t2;
    (* DONT_TOUCH="true" *) wire [2*(K/16)-1:0] t3;
    (* DONT_TOUCH="true" *) wire [2*18-1:0] t;
    (* DONT_TOUCH="true" *) wire [2*K-1:0] c;
    

    genvar i, j;
    
    // debug
//    wire [K-1:0] data_g0;
//    wire [K-1:0] data_p0;
//    wire [K/2-1:0] data_g1;
//    wire [K/2-2:0] data_p1;
//    wire [K/4-1:0] data_g2;
//    wire [K/4-2:0] data_p2;
//    wire [K/8-1:0] data_g3;
//    wire [K/8-2:0] data_p3;
//    wire [K/16-1:0] data_g4;
//    wire [K-1:0] data_z;
//    wire [K-1:0] data_c;
    
//    wire [K/2-1:0] rg1;
//    wire [K/4-1:0] rg2;
//    wire [K/8-1:0] rg3;
//    wire [K/16-1:0] rg4;
   
//    for (i = 0; i < K; i = i + 1) begin
//        assign data_g0[i] = g0[2*i+1] ^ rt[i];
//        assign data_p0[i] = p0[2*i+1] ^ rf[i] ^ rf[K+i];
//    end
//    for (i = 0; i < K/2; i = i + 1) begin
//        assign data_g1[i] = g1[2*i+1] ^ rt[23+i] ^ rt[2*i+1];
//        assign rg1[i] = rt[23+i] ^ rt[2*i+1];
//        if (i < K/2-1)
//            assign data_p1[i] = p1[2*i+1] ^ rt[34+i];
//    end
//    for (i = 0; i < K/4; i = i + 1) begin
//        assign data_g2[i] = g2[2*i+1] ^ rt[44+i] ^ rg1[2*i+1];
//        assign rg2[i] = rt[44+i] ^ rg1[2*i+1];
//        if (i < K/4-1)
//            assign data_p2[i] = p2[2*i+1] ^ rt[49+i];
//    end
//    for (i = 0; i < K/8; i = i + 1) begin
//        assign data_g3[i] = g3[2*i+1] ^ rt[53+i] ^ rg2[2*i+1];
//        assign rg3[i] = rt[53+i] ^ rg2[2*i+1];
//        if (i < K/8-1)
//            assign data_p3[i] = p3[2*i+1] ^ rt[55+i];
//    end
//    for (i = 0; i < K/16; i = i + 1) begin
//        assign data_g4[i] = g4[2*i+1] ^ rt[56+i] ^ rg3[2*i+1];
//        assign rg4[i] = rt[56+i] ^ rg3[2*i+1];
//    end

//    assign data_c[0] = c[2*0+1] ^ rt[0];
//    assign data_c[1] = c[2*1+1] ^ rg1[0];
//    assign data_c[2] = c[2*2+1] ^ rt[57] ^ rt[2];
//    assign data_c[3] = c[2*3+1] ^ rg2[0];
//    assign data_c[4] = c[2*4+1] ^ rt[57] ^ rt[4];
//    assign data_c[5] = c[2*5+1] ^ rt[57] ^ rg1[2];
//    assign data_c[6] = c[2*6+1] ^ rt[58] ^ rt[6];
//    assign data_c[7] = c[2*7+1] ^ rg3[0];
//    assign data_c[8] = c[2*8+1] ^ rt[57] ^ rt[8];
//    assign data_c[9] = c[2*9+1] ^ rt[57] ^ rg1[4];
//    assign data_c[10] = c[2*10+1] ^ rt[58] ^ rt[10];
//    assign data_c[11] = c[2*11+1] ^ rt[57] ^ rg2[2];
//    assign data_c[12] = c[2*12+1] ^ rt[58] ^ rt[12];
//    assign data_c[13] = c[2*13+1] ^ rt[58] ^ rg1[6];
//    assign data_c[14] = c[2*14+1] ^ rt[59] ^ rt[14];
//    assign data_c[15] = c[2*15+1] ^ rg4[0];
//    assign data_c[16] = c[2*16+1] ^ rt[57] ^ rt[16];
//    assign data_c[17] = c[2*17+1] ^ rt[57] ^ rg1[8];
//    assign data_c[18] = c[2*18+1] ^ rt[58] ^ rt[18];
//    assign data_c[19] = c[2*19+1] ^ rt[57] ^ rg2[4];
//    assign data_c[20] = c[2*20+1] ^ rt[58] ^ rt[20];
//    assign data_c[21] = c[2*21+1] ^ rt[58] ^ rg1[10];
//    assign data_c[22] = c[2*22+1] ^ rt[59] ^ rt[22];
    
    /* ============= Forward Tree ============= */
    // level 0
    for (i = 0; i < K; i = i + 1) begin  
        SecAnd and_g0 (
            tb_and[8*i +: 8],
            x[2*i+1:2*i],
            y[2*i+1:2*i],
            g0[2*i+1:2*i]
        ); // 0,1,5
        
        dual_XOR xor_p0 (
            x[2*i+1:2*i],
            y[2*i+1:2*i],
            p0[2*i+1:2*i]
        ); // 0,1,3
    end 

    // level 1 
    for (i = 0; i < K/2; i = i + 1) begin 
        SecAnd and_g1 (
            tb_and[8*(K+i) +: 8],
            p0[4*i+3:4*i+2],
            g0[4*i+1:4*i],
            t0[2*i+1:2*i]
        ); 
        
        dual_XOR xor_g1 (
            t0[2*i+1:2*i],
            g0[4*i+3:4*i+2],
            g1[2*i+1:2*i]
        );
        
        if (i < K/2-1) begin 
            SecAnd and_p1 (
                tb_and[8*(K+K/2+i) +: 8],
                p0[4*(i+1)+3:4*(i+1)+2],
                p0[4*(i+1)+1:4*(i+1)],
                p1[2*i+1:2*i]
            );
        end 
    end 
    
    // level 2 
    for (i = 0; i < K/4; i = i + 1) begin 
        SecAnd and_g2 (
            tb_and[8*(2*K-2+i) +: 8],
            p1[4*i+1:4*i],
            g1[4*i+1:4*i],
            t1[2*i+1:2*i]
        ); 
        
        dual_XOR xor_g2 (
            t1[2*i+1:2*i],
            g1[4*i+3:4*i+2],
            g2[2*i+1:2*i]
        );
        
        if (i < K/4-1) begin 
            SecAnd and_p2 (
                tb_and[8*(2*K+K/4-2+i) +: 8],
                p1[4*i+5:4*i+4],
                p1[4*i+3:4*i+2],
                p2[2*i+1:2*i]
            );
        end 
    end 
    
    // level 3 
    for (i = 0; i < K/8; i = i + 1) begin 
        SecAnd and_g3 (
            tb_and[8*(2*K+K/2-4+i) +: 8],
            p2[4*i+1:4*i],
            g2[4*i+1:4*i],
            t2[2*i+1:2*i]
        ); 
        
        dual_XOR xor_g3 (
            t2[2*i+1:2*i],
            g2[4*i+3:4*i+2],
            g3[2*i+1:2*i]
        );
        
        if (i < K/8-1) begin 
            SecAnd and_p3 (
                tb_and[8*(2*K+K/2+K/8-4+i) +: 8],
                p2[4*i+5:4*i+4],
                p2[4*i+3:4*i+2],
                p3[2*i+1:2*i]
            );
        end 
    end 
    
    // level 4 
    SecAnd and_g4 (
        tb_and[8*(2*K+K/2+K/4-6) +: 8],
        p3[1:0],
        g3[1:0],
        t3[1:0]
    ); 
    
    dual_XOR xor_g4 (
        t3[1:0],
        g3[3:2],
        g4[1:0]
    );
   
    assign c[2*0+1:2*0] = g0[1:0];
    assign c[2*1+1:2*1] = g1[1:0];
    assign c[2*3+1:2*3] = g2[1:0];
    assign c[2*7+1:2*7] = g3[1:0];
    assign c[2*15+1:2*15] = g4[1:0];
    
    
    /* ============= Backward Tree ============= */
    // HW(i+1)==2 
   SecAnd and_2 (
        tb_and[8*57 +: 8],
        p0[2*2+1:2*2],
        g1[2*0+1:2*0],
        t[2*0+1:2*0]
    ); 
    
    dual_XOR xor_2 (
        t[2*0+1:2*0],
        g0[2*2+1:2*2],
        c[2*2+1:2*2]
    );
    
    SecAnd and_4 (
        tb_and[8*58 +: 8],
        p0[2*4+1:2*4],
        g2[2*0+1:2*0],
        t[2*1+1:2*1]
    ); 
    
    dual_XOR xor_4 (
        t[2*1+1:2*1],
        g0[2*4+1:2*4],
        c[2*4+1:2*4]
    );
    
    SecAnd and_5 (
        tb_and[8*59 +: 8],
        p1[2*1+1:2*1],
        g2[2*0+1:2*0],
        t[2*2+1:2*2]
    ); 
    
    dual_XOR xor_5 (
        t[2*2+1:2*2],
        g1[2*2+1:2*2],
        c[2*5+1:2*5]
    );
    
    SecAnd and_8 (
        tb_and[8*60 +: 8],
        p0[2*8+1:2*8],
        g3[2*0+1:2*0],
        t[2*3+1:2*3]
    ); 
    
    dual_XOR xor_8 (
        t[2*3+1:2*3],
        g0[2*8+1:2*8],
        c[2*8+1:2*8]
    );
    
    SecAnd and_9 (
        tb_and[8*61 +: 8],
        p1[2*3+1:2*3],
        g3[2*0+1:2*0],
        t[2*4+1:2*4]
    ); 
    
    dual_XOR xor_9 (
        t[2*4+1:2*4],
        g1[2*4+1:2*4],
        c[2*9+1:2*9]
    );
    
    SecAnd and_11 (
        tb_and[8*62 +: 8],
        p2[2*1+1:2*1],
        g3[2*0+1:2*0],
        t[2*5+1:2*5]
    ); 
    
    dual_XOR xor_11 (
        t[2*5+1:2*5],
        g2[2*2+1:2*2],
        c[2*11+1:2*11]
    );
    
    SecAnd and_16 (
        tb_and[8*63 +: 8],
        p0[2*16+1:2*16],
        g4[2*0+1:2*0],
        t[2*6+1:2*6]
    ); 
    
    dual_XOR xor_16 (
        t[2*6+1:2*6],
        g0[2*16+1:2*16],
        c[2*16+1:2*16]
    );
    
    SecAnd and_17 (
        tb_and[8*64 +: 8],
        p1[2*7+1:2*7],
        g4[2*0+1:2*0],
        t[2*7+1:2*7]
    ); 
    
    dual_XOR xor_17 (
        t[2*7+1:2*7],
        g1[2*8+1:2*8],
        c[2*17+1:2*17]
    );    
    
    SecAnd and_19 (
        tb_and[8*65 +: 8],
        p2[2*3+1:2*3],
        g4[2*0+1:2*0],
        t[2*8+1:2*8]
    ); 
    
    dual_XOR xor_19 (
        t[2*8+1:2*8],
        g2[2*4+1:2*4],
        c[2*19+1:2*19]
    );    
    
    // HW(i+1)==3 
    SecAnd and_6 (
        tb_and[8*66 +: 8],
        p0[2*6+1:2*6],
        c[2*5+1:2*5],
        t[2*9+1:2*9]
    ); 
    
    dual_XOR xor_6 (
        t[2*9+1:2*9],
        g0[2*6+1:2*6],
        c[2*6+1:2*6]
    );
    
    SecAnd and_10 (
        tb_and[8*67 +: 8],
        p0[2*10+1:2*10],
        c[2*9+1:2*9],
        t[2*10+1:2*10]
    ); 
    
    dual_XOR xor_10 (
        t[2*10+1:2*10],
        g0[2*10+1:2*10],
        c[2*10+1:2*10]
    );
    
    SecAnd and_12 (
        tb_and[8*68 +: 8],
        p0[2*12+1:2*12],
        c[2*11+1:2*11],
        t[2*11+1:2*11]
    ); 
    
    dual_XOR xor_12 (
        t[2*11+1:2*11],
        g0[2*12+1:2*12],
        c[2*12+1:2*12]
    );
    
    SecAnd and_13 (
        tb_and[8*69 +: 8],
        p1[2*5+1:2*5],
        c[2*11+1:2*11],
        t[2*12+1:2*12]
    ); 
    
    dual_XOR xor_13 (
        t[2*12+1:2*12],
        g1[2*6+1:2*6],
        c[2*13+1:2*13]
    );
    
    SecAnd and_18 (
        tb_and[8*70 +: 8],
        p0[2*18+1:2*18],
        c[2*17+1:2*17],
        t[2*13+1:2*13]
    ); 
    
    dual_XOR xor_18 (
        t[2*13+1:2*13],
        g0[2*18+1:2*18],
        c[2*18+1:2*18]
    );
    
    SecAnd and_20 (
        tb_and[8*71 +: 8],
        p0[2*20+1:2*20],
        c[2*19+1:2*19],
        t[2*14+1:2*14]
    ); 
    
    dual_XOR xor_20 (
        t[2*14+1:2*14],
        g0[2*20+1:2*20],
        c[2*20+1:2*20]
    );
    
    SecAnd and_21 (
        tb_and[8*72 +: 8],
        p1[2*9+1:2*9],
        c[2*19+1:2*19],
        t[2*15+1:2*15]
    ); 
    
    dual_XOR xor_21 (
        t[2*15+1:2*15],
        g1[2*10+1:2*10],
        c[2*21+1:2*21]
    );
    
    // HW(i+1)==3 
    SecAnd and_14 (
        tb_and[8*73 +: 8],
        p0[2*14+1:2*14],
        c[2*13+1:2*13],
        t[2*16+1:2*16]
    ); 
    
    dual_XOR xor_14 (
        t[2*16+1:2*16],
        g0[2*14+1:2*14],
        c[2*14+1:2*14]
    );
    
    SecAnd and_22 (
        tb_and[8*74 +: 8],
        p0[2*22+1:2*22],
        c[2*21+1:2*21],
        t[2*17+1:2*17]
    ); 
    
    dual_XOR xor_22 (
        t[2*17+1:2*17],
        g0[2*22+1:2*22],
        c[2*22+1:2*22]
    );
    
    
    // res 
    assign z[1:0] = p0[1:0];
    assign mc = c[2*22+1:2*22];
    
    for (i = 1; i < K; i = i + 1) begin 
        dual_XOR xor_res (
            p0[2*i+1:2*i],
            c[2*(i-1)+1:2*(i-1)],
            z[2*i+1:2*i]
        );
    end 
    
endmodule

