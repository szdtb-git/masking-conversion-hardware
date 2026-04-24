module table_gen_12 #(
    localparam K = 12
)
(
    input [2*K-1:0] rf,  // refresh random
    input [30:0] rt,     // table random
    output [37*8-1:0] tb_and,
    output [K-1:0] z,
    output c
);


    genvar i;
    
    wire [K-1:0] rp0;
    wire [K/2-1:0] rg1;
    wire [K/4-1:0] rg2;
    wire [K/8-1:0] rg3;
    
    // L0: G
    for (i = 0; i < K; i = i + 1) begin 
        Table_And table_and_g0 (
            rf[i],
            rf[K+i], 
            rt[i],
            tb_and[8*i +: 8]
        );
        
        assign rp0[i] = rf[i] ^ rf[K+i];
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
            rt[2*K-1+i],
            tb_and[8*(2*K-1+i) +: 8]
        );
        
        assign rg2[i] = rt[2*K-1+i] ^ rg1[2*i+1];
    end 
    
    // L2: P 
    for (i = 0; i < K/4-1; i = i + 1) begin 
        Table_And table_and_p2 (
            rt[K+K/2+2+2*i], 
            rt[K+K/2+1+2*i],
            rt[2*K+K/4-1+i],
            tb_and[8*(2*K+K/4-1+i) +: 8]
        );
    end 
    
    // L3: G 
    Table_And table_and_g3 (
        rt[26], 
        rg2[0],
        rt[28],
        tb_and[8*28 +: 8]
     );
        
     assign rg3[0] = rt[28] ^ rg2[1];

    
    
    // Backward 
    Table_And table_and_2 (
        rp0[2], 
        rg1[0],
        rt[29],
        tb_and[8*29 +: 8]
    );
    
    Table_And table_and_4 (
        rp0[4], 
        rg2[0],
        rt[29],
        tb_and[8*30 +: 8]
    );
    
    Table_And table_and_5 (
        rt[19], 
        rg2[0],
        rt[29],
        tb_and[8*31 +: 8]
    );
    
    Table_And table_and_8 (
        rp0[8], 
        rg3[0],
        rt[29],
        tb_and[8*32 +: 8]
    );
    
    Table_And table_and_9 (
        rt[21], 
        rg3[0],
        rt[29],
        tb_and[8*33 +: 8]
    );
    
    Table_And table_and_11 (
        rt[27], 
        rg3[0],
        rt[29],
        tb_and[8*34 +: 8]
    );
    
    
    Table_And table_and_6 (
        rp0[6], 
        rt[29] ^ rg1[2],
        rt[30],
        tb_and[8*35 +: 8]
    );
    
    Table_And table_and_10 (
        rp0[10], 
        rt[29] ^ rg1[4],
        rt[30],
        tb_and[8*36 +: 8]
    );
    

    
    assign z[0] = rp0[0];
    assign z[1] = rp0[1] ^ rt[0];
    assign z[2] = rp0[2] ^ rg1[0];
    assign z[3] = rp0[3] ^ rt[29] ^ rt[2];
    assign z[4] = rp0[4] ^ rg2[0];
    assign z[5] = rp0[5] ^ rt[29] ^ rt[4];
    assign z[6] = rp0[6] ^ rt[29] ^ rg1[2];
    assign z[7] = rp0[7] ^ rt[30] ^ rt[6];
    assign z[8] = rp0[8] ^ rg3[0];
    assign z[9] = rp0[9] ^ rt[29] ^ rt[8];
    assign z[10] = rp0[10] ^ rt[29] ^ rg1[4];
    assign z[11] = rp0[11] ^ rt[30] ^ rt[10];
    assign c = rt[29] ^ rg2[2];


endmodule
