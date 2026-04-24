`include "define.v"

(*keep_hirearchy = "true",dont_touch = "true"*) module B2Ap_top # (
    localparam K = `K,
    localparam N = `N,
    localparam P = `P
)
(
    input clk,
    input rst_n,
    input [1:0] state,
    input [N*K-1:0] data_xB,
    input [75:0] data_r,
    output reg [N*K-1:0] data_xA,
    output reg succ_exec
);


    wire [37*8-1:0] tb_and_0;
    wire [37*8-1:0] tb_and_1;
    wire [8*2*K-1:0] tb_and_2;
    (* DONT_TOUCH="true" *) reg [37*8-1:0] r_tb_and_0;
    (* DONT_TOUCH="true" *) reg [37*8-1:0] r_tb_and_1;
    (* DONT_TOUCH="true" *) reg [8*2*K-1:0] r_tb_and_2;
    (* DONT_TOUCH="true" *) reg [2*K-1:0] dual_x;
    (* DONT_TOUCH="true" *) reg [2*K-1:0] dual_y;
    (* DONT_TOUCH="true" *) reg [2*K-1:0] dual_y2;
    (* DONT_TOUCH="true" *) wire [2*K-1:0] dual_u;
    (* DONT_TOUCH="true" *) wire [2*K-1:0] dual_v;
    (* DONT_TOUCH="true" *) wire [1:0] dual_c;
    (* DONT_TOUCH="true" *) wire [2*K-1:0] dual_w1;
    (* DONT_TOUCH="true" *) wire [2*K-1:0] dual_w2;
    (* DONT_TOUCH="true" *) wire [2*K-1:0] dual_xA;
    (* DONT_TOUCH="true" *) wire [K-1:0] u;
    (* DONT_TOUCH="true" *) wire [K-1:0] v;
    (* DONT_TOUCH="true" *) wire c;
    (* DONT_TOUCH="true" *) reg [K-1:0] t0;
    (* DONT_TOUCH="true" *) reg [K-1:0] t1;
    reg start;
    reg start_dly1;
    reg [K-1:0] xB0;
    reg [K-1:0] xB1;
    reg [63:0] r;
    wire [K-1:0] xA0;
    wire [K-1:0] xA1;
    reg [K-1:0] xR;
    wire [K-1:0] _xR;
    
    genvar i, j;
    integer k;
   
    
    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin 
            start <= 0;
            xB0 <= 0;
            xB1 <= 0;
            xR <= 0;
            r <= 0;
        end else if (state == `EXEC) begin 
            start <= 1;
            xB0 <= data_xB[K-1:0];
            xB1 <= data_xB[2*K-1:K];
            xR <= (data_r[0 +: K]) % P;
            r <= data_r[K +: 64];
        end else begin 
            start <= 0;
            xB0 <= 0;
            xB1 <= 0;
            xR <= 0;
            r <= 0;
        end 
    end
    
    assign _xR = xR + 2**K - P;
    
    always@(posedge clk) begin 
        start_dly1 <= start;
    end 

    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin 
            dual_x <= 0;
            dual_y <= 0;
            dual_y2 <= 0;
        end else if (start && !succ_exec) begin 
            for (k = 0; k < 2*K; k = k + 2) begin
                dual_x[k+1] <= xB1[k/2];
                dual_x[k] <= ~xB1[k/2];
                dual_y[k+1] <= xR[k/2];
                dual_y[k] <= ~xR[k/2];
                dual_y2[k+1] <= _xR[k/2];
                dual_y2[k] <= ~_xR[k/2];
            end 
        end else begin
            dual_x <= 0;
            dual_y <= 0;
            dual_y2 <= 0;
        end 
    end
    
    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin 
            r_tb_and_0 <= 0;
            r_tb_and_1 <= 0;
            r_tb_and_2 <= 0;
        end else if (start && !succ_exec) begin 
            r_tb_and_0 <= tb_and_0;
            r_tb_and_1 <= tb_and_1;
            r_tb_and_2 <= tb_and_2;
        end else begin 
            r_tb_and_0 <= 0;
            r_tb_and_1 <= 0;
            r_tb_and_2 <= 0;
        end 
    end
    
    
    table_gen_12 table_gen_0 (
        xB0,
        r[0 +: 31],
        tb_and_0,
        u,
    );
    
    table_gen_12 table_gen_1 (
        xB0,
        r[31 +: 31],
        tb_and_1,
        v, 
        c
    );
    
    BK_12 bk_0 (
        dual_x, 
        dual_y, 
        r_tb_and_0, 
//        rf[0 +: 2*K],
//        rt[0 +: 60],
        dual_u,
    );     
    
    BK_12 bk_1 (
        dual_x, 
        dual_y2, 
        r_tb_and_1, 
//        {rf[2*K +: K], rf[0 +: K]},
//        rt[60 +: 60],
        dual_v,
        dual_c
    );  
    
    
    for (i = 0; i < K; i = i + 1) begin 
        Table_And table_and_w1 (
            ~c,
            u[i],
            r[62],
            tb_and_2[8*i +: 8]
        );
        
        Table_And table_and_w2 (
            c,
            v[i],
            r[63],
            tb_and_2[8*(K+i) +: 8]
        );
    end 
    
    for (i = 0; i < K; i = i + 1) begin       
        SecAnd and_w1 (
           r_tb_and_2[8*i +: 8],
           dual_c,
           dual_u[2*i+1:2*i],
           dual_w1[2*i+1:2*i]
        );
        
        SecAnd and_w2 (
           r_tb_and_2[8*(K+i) +: 8],
           dual_c,
           dual_v[2*i+1:2*i],
           dual_w2[2*i+1:2*i]
        );
        
        dual_XOR xor_res (
            dual_w1[2*i+1:2*i],
            dual_w2[2*i+1:2*i],
            dual_xA[2*i+1:2*i]
        );
    end 
    
    
    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin
            t0 <= 0;
            t1 <= 0;
        end else if (start_dly1 && !succ_exec) begin 
            t0 <= {K{r[62] ^ r[63]}};
            for (k = 0; k <= K; k = k + 1)
                t1[k] <= dual_xA[2*k+1];
        end else begin 
            t0 <= 0;
            t1 <= 0;
        end 
    end 
    
    assign xA0 = P - xR;
    assign xA1 = t0 ^ t1;
    
    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n) 
            data_xA <= 0;
        else if (state == `EXEC && succ_exec) begin
            data_xA <= {xA1, xA0};
        end else if (state == `RECV)
            data_xA <= 0;
    end 
    
    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n) 
            succ_exec <= 0;
        else if (start_dly1)
            succ_exec <= 1;
        else 
            succ_exec <= 0;
    end 

     
endmodule
