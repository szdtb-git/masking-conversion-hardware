module table_gen_23 #(
    localparam K = 23
)
(
    input [K-1:0] xB0,  
    input [59:0] rt, 
    output [75*8-1:0] tb_and,
    output [K-1:0] z,
    output c
);


    genvar i;
    
    wire [K-1:0] rp0;
    wire [K/2-1:0] rg1;
    wire [K/4-1:0] rg2;
    wire [K/8-1:0] rg3;
    wire [K/16-1:0] rg4;
    
    // L0: G
    for (i = 0; i < K; i = i + 1) begin 
        Table_And table_and_g0 (
            xB0[i],
            1'b0, 
            rt[i],
            tb_and[8*i +: 8]
        );
        
        assign rp0[i] = xB0[i] ^ 1'b0;
    end 
    
    // L1: G 
    for (i = 0; i < K/2; i = i + 1) begin 
        Table_And table_and_g1 (
            rp0[2*i+1], 
            rt[2*i],
            rt[K+i],
            tb_and[8*(K+i) +: 8]
        );
        
        assign rg1[i] = rt[K+i] ^ rt[2*i+1];
    end 
    
    // L1: P 
    for (i = 0; i < K/2-1; i = i + 1) begin 
        Table_And table_and_p1 (
            rp0[2*i+2+1], 
            rp0[2*i+2],
            rt[K+K/2+i],
            tb_and[8*(K+K/2+i) +: 8]
        );
    end 
    
    // L2: G 
    for (i = 0; i < K/4; i = i + 1) begin 
        Table_And table_and_g2 (
            rt[K+K/2+2*i], 
            rg1[2*i],
            rt[2*K-2+i],
            tb_and[8*(2*K-2+i) +: 8]
        );
        
        assign rg2[i] = rt[2*K-2+i] ^ rg1[2*i+1];
    end 
    
    // L2: P 
    for (i = 0; i < K/4-1; i = i + 1) begin 
        Table_And table_and_p2 (
            rt[K+K/2+2+2*i], 
            rt[K+K/2+1+2*i],
            rt[2*K+K/4-2+i],
            tb_and[8*(2*K+K/4-2+i) +: 8]
        );
    end 
    
    // L3: G 
    for (i = 0; i < K/8; i = i + 1) begin 
        Table_And table_and_g3 (
            rt[2*K+K/4-2+2*i], 
            rg2[2*i],
            rt[2*K+K/2-4+i],
            tb_and[8*(2*K+K/2-4+i) +: 8]
        );
        
        assign rg3[i] = rt[2*K+K/2-4+i] ^ rg2[2*i+1];
    end 
    
    // L3: P 
    for (i = 0; i < K/8-1; i = i + 1) begin 
        Table_And table_and_p3 (
            rt[2*K+K/4+2*i], 
            rt[2*K+K/4-1+2*i],
            rt[2*K+K/2+K/8-4+i],
            tb_and[8*(2*K+K/2+K/8-4+i) +: 8]
        );
    end 
    
    // L4: G 
    Table_And table_and_g4 (
        rt[2*K+K/2+K/8-4], 
        rg3[0],
        rt[2*K+K/2+K/4-6],
        tb_and[8*(2*K+K/2+K/4-6) +: 8]
    );
    
    assign rg4[0] = rt[2*K+K/2+K/4-6] ^ rg3[1];
    
    
    // Backward 
    Table_And table_and_2 (
        rp0[2], 
        rg1[0],
        rt[57],
        tb_and[8*57 +: 8]
    );
    
    Table_And table_and_4 (
        rp0[4], 
        rg2[0],
        rt[57],
        tb_and[8*58 +: 8]
    );
    
    Table_And table_and_5 (
        rt[35], 
        rg2[0],
        rt[57],
        tb_and[8*59 +: 8]
    );
    
    Table_And table_and_8 (
        rp0[8], 
        rg3[0],
        rt[57],
        tb_and[8*60 +: 8]
    );
    
    Table_And table_and_9 (
        rt[37], 
        rg3[0],
        rt[57],
        tb_and[8*61 +: 8]
    );
    
    Table_And table_and_11 (
        rt[50], 
        rg3[0],
        rt[57],
        tb_and[8*62 +: 8]
    );
    
    Table_And table_and_16 (
        rp0[16], 
        rg4[0],
        rt[57],
        tb_and[8*63 +: 8]
    );
    
    Table_And table_and_17 (
        rt[41], 
        rg4[0],
        rt[57],
        tb_and[8*64 +: 8]
    );
    
    Table_And table_and_19 (
        rt[52], 
        rg4[0],
        rt[57],
        tb_and[8*65 +: 8]
    );
    
    Table_And table_and_6 (
        rp0[6], 
        rt[57] ^ rg1[2],
        rt[58],
        tb_and[8*66 +: 8]
    );
    
    Table_And table_and_10 (
        rp0[10], 
        rt[57] ^ rg1[4],
        rt[58],
        tb_and[8*67 +: 8]
    );
    
    Table_And table_and_12 (
        rp0[12], 
        rt[57] ^ rg2[2],
        rt[58],
        tb_and[8*68 +: 8]
    );
    
    Table_And table_and_13 (
        rt[39], 
        rt[57] ^ rg2[2],
        rt[58],
        tb_and[8*69 +: 8]
    );
    
    Table_And table_and_18 (
        rp0[18], 
        rt[57] ^ rg1[8],
        rt[58],
        tb_and[8*70 +: 8]
    );
    
    Table_And table_and_20 (
        rp0[20], 
        rt[57] ^ rg2[4],
        rt[58],
        tb_and[8*71 +: 8]
    );
    
    Table_And table_and_21 (
        rt[43], 
        rt[57]  ^ rg2[4],
        rt[58],
        tb_and[8*72 +: 8]
    );
    
    Table_And table_and_14 (
        rp0[14], 
        rt[58] ^ rg1[6],
        rt[59],
        tb_and[8*73 +: 8]
    );
    
    Table_And table_and_22 (
        rp0[22], 
        rt[58]  ^ rg1[10],
        rt[59],
        tb_and[8*74 +: 8]
    );
    
    
    
    
    
//    Table_Xor table_xor_23 (
//        r[3],
//        r[21],
//        r[23],
//        tb_xor[104 +: 8]
//    );
    
    
//    wire [K-1:0] z;
    
    assign z[0] = rp0[0];
    assign z[1] = rp0[1] ^ rt[0];
    assign z[2] = rp0[2] ^ rg1[0];
    assign z[3] = rp0[3] ^ rt[57] ^ rt[2];
    assign z[4] = rp0[4] ^ rg2[0];
    assign z[5] = rp0[5] ^ rt[57] ^ rt[4];
    assign z[6] = rp0[6] ^ rt[57] ^ rg1[2];
    assign z[7] = rp0[7] ^ rt[58] ^ rt[6];
    assign z[8] = rp0[8] ^ rg3[0];
    assign z[9] = rp0[9] ^ rt[57] ^ rt[8];
    assign z[10] = rp0[10] ^ rt[57] ^ rg1[4];
    assign z[11] = rp0[11] ^ rt[58] ^ rt[10];
    assign z[12] = rp0[12] ^ rt[57] ^ rg2[2];
    assign z[13] = rp0[13] ^ rt[58] ^ rt[12];
    assign z[14] = rp0[14] ^ rt[58] ^ rg1[6];
    assign z[15] = rp0[15] ^ rt[59] ^ rt[14];
    assign z[16] = rp0[16] ^ rg4[0];
    assign z[17] = rp0[17] ^ rt[57] ^ rt[16];
    assign z[18] = rp0[18] ^ rt[57] ^ rg1[8];
    assign z[19] = rp0[19] ^ rt[58] ^ rt[18];
    assign z[20] = rp0[20] ^ rt[57] ^ rg2[4];
    assign z[21] = rp0[21] ^ rt[58] ^ rt[20];
    assign z[22] = rp0[22] ^ rt[58] ^ rg1[10];
    assign c = rt[59] ^ rt[22];


endmodule
