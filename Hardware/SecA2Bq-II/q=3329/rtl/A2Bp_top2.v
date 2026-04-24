`include "define.v"

(*keep_hirearchy = "true",dont_touch = "true"*) module A2Bp_top2 # (
    localparam K = `K,
    localparam N = `N
)
(
    input clk,
    input rst_n,
    input [1:0] state,
    input [9:0] cnt,
    input [N*K-1:0] data_xA,
    input [70:0] data_r,
    output reg [N*K-1:0] data_xB,
    output reg succ_exec
);


     wire [37*8-1:0] tb_and_0;
     wire [8*2*K-1:0] tb_and_2;
    (* DONT_TOUCH="true" *) wire [K-1:0] u;
    (* DONT_TOUCH="true" *) wire c;
    (* DONT_TOUCH="true" *) reg [37*8-1:0] r_tb_and_0;
    (* DONT_TOUCH="true" *) reg [8*2*K-1:0] r_tb_and_2;
    (* DONT_TOUCH="true" *) reg [2*K-1:0] dual_x;
    (* DONT_TOUCH="true" *) reg [2*K-1:0] dual_y;
    (* DONT_TOUCH="true" *) reg [2*K-1:0] dual_y2;
    (* DONT_TOUCH="true" *) wire [2*K-1:0] dual_u;
    (* DONT_TOUCH="true" *) wire [2*K-1:0] dual_v;
    (* DONT_TOUCH="true" *) wire [2*K-1:0] dual_w1;
    (* DONT_TOUCH="true" *) wire [2*K-1:0] dual_w2;
    (* DONT_TOUCH="true" *) wire [2*K-1:0] dual_xB;
    (* DONT_TOUCH="true" *) wire [1:0] dual_c;
    (* DONT_TOUCH="true" *) reg [1:0] dual_s;
    (* DONT_TOUCH="true" *) reg [2*K-1:0] dual_ru;
    (* DONT_TOUCH="true" *) reg [2*K-1:0] dual_rv;
     
    reg [K-1:0] xA0;
    reg [K-1:0] xA1;
    reg [K-1:0] xA2;
    reg [3*K-1:0] rf;
    reg [34:0] rt;
    (* DONT_TOUCH="true" *) wire [K-1:0] ru;
    (* DONT_TOUCH="true" *) wire [K-1:0] rv;
    reg start;
    reg start_dly;
    
    genvar i, j;
    integer k;
    
    
    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin 
            start <= 0;
            xA0 <= 0;
            xA1 <= 0;
            xA2 <= 0;
            rt <= 0;
            rf <= 0;
        end else if (state == `EXEC) begin 
            start <= 1;
            xA0 <= data_xA[K-1:0];
            xA1 <= data_xA[2*K-1:K];
            xA2 <= data_xA[2*K-1:K] + `_P;
            rf <= data_r[0 +: 3*K];
            rt <= data_r[3*K +: 35];
        end else begin 
            start <= 0;
            xA0 <= 0;
            xA1 <= 0;
            xA2 <= 0;
            rt <= 0;
            rf <= 0;
        end 
    end

    always@(posedge clk) begin
        start_dly <= start;
    end 
    
    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin 
            r_tb_and_0 <= 0;
            r_tb_and_2 <= 0;
        end else if (start && !succ_exec) begin 
            r_tb_and_0 <= tb_and_0;
            r_tb_and_2 <= tb_and_2;
        end else begin 
            r_tb_and_0 <= 0;
            r_tb_and_2 <= 0;
        end 
    end
    
    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin 
            dual_x <= 0;
            dual_y <= 0;
            dual_y2 <= 0;
        end else if (start && !start_dly) begin 
            for (k = 0; k < 2*K; k = k + 2) begin
                dual_x[k+1] <= xA0[k/2] ^ rf[k/2];
                dual_x[k] <= ~xA0[k/2] ^ rf[k/2];
                dual_y[k+1] <= xA1[k/2] ^ rf[K+k/2];
                dual_y[k] <= ~xA1[k/2] ^ rf[K+k/2];
                dual_y2[k+1] <= xA2[k/2] ^ rf[K+k/2];
                dual_y2[k] <= ~xA2[k/2] ^ rf[K+k/2];
            end 
        end else begin
            dual_x <= 0;
            dual_y <= 0;
            dual_y2 <= 0;
        end 
    end
    
    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin 
            dual_ru <= 0;
            dual_rv <= 0;
            dual_s <= 0;
        end else if (start_dly && !succ_exec) begin 
            dual_ru <= dual_u ^ {2*K{rt[31]}};
            dual_rv <= dual_v ^ {2*K{rt[32]}};
            dual_s <= dual_c;
        end else begin
            dual_ru <= 0;
            dual_rv <= 0;
            dual_s <= 0;
        end 
    end
    
    table_gen_12 table_gen_0 (
        rf,
        rt[0 +: 31],
        tb_and_0,
        u,
        c
    );
    
    assign ru = u ^ {K{rt[31]}};
    assign rv = u ^ {K{rt[32]}};
    
    BK_12 bk_0 (
        dual_x, 
        dual_y, 
        r_tb_and_0, 
        dual_u,
    );     
    
    BK_12 bk_1 (
        dual_x, 
        dual_y2, 
        r_tb_and_0, 
        dual_v,
        dual_c
    );  
    
    
    for (i = 0; i < K; i = i + 1) begin 
        Table_And table_and_w1 (
            ~c,
            ru[i],
            rt[33],
            tb_and_2[8*i +: 8]
        );
        
        Table_And table_and_w2 (
            c,
            rv[i],
            rt[34],
            tb_and_2[8*(K+i) +: 8]
        );
    end 
    
    for (i = 0; i < K; i = i + 1) begin       
        SecAnd and_w1 (
           r_tb_and_2[8*i +: 8],
           dual_s,
           dual_ru[2*i+1:2*i],
           dual_w1[2*i+1:2*i]
        );
        
        SecAnd and_w2 (
           r_tb_and_2[8*(K+i) +: 8],
           dual_s,
           dual_rv[2*i+1:2*i],
           dual_w2[2*i+1:2*i]
        );
        
        dual_XOR xor_res (
            dual_w1[2*i+1:2*i],
            dual_w2[2*i+1:2*i],
            dual_xB[2*i+1:2*i]
        );
    end              
    

    wire [N*K-1:0] xB;
    for (i = 0; i < K; i = i + 1) begin
        assign xB[i] = dual_xB[2*i+1] ^ rf[2*K+i];
        assign xB[K+i] = rt[33] ^ rt[34] ^ rf[2*K+i];
    end
    
        
    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n) 
            data_xB <= 0;
        else if (state == `EXEC && succ_exec) 
            data_xB <= xB;
    end 
    
    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n) 
            succ_exec <= 0;
        else if (start_dly)
            succ_exec <= 1;
        else 
            succ_exec <= 0;
    end 

     
endmodule
