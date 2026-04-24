
//`include "../rtl/define.v"

//module ctrl_uarttx # (
//    localparam K = `K,
//    localparam N = `N
//)
//(
//    input clk,
//    input rst_n,                                                    
//    input [1:0]state, 
//    input [N*K-1:0] data_in,                       
//    output reg [7:0] data_out,                         
//    output reg succ_send,                            
//    output reg data_out_vld                            
//);

//    localparam remainder = N * K % 8;
//    localparam total = remainder ? N*K + 8-remainder : N*K;

//    reg [9:0] clk_cnt;
//    reg [9:0] bit_cnt;
    
//    wire end_send;
//    wire [total-1:0] t_data_in;
    
//    assign end_send = (bit_cnt == total / 8);
//    assign t_data_in = {{remainder{1'b0}}, data_in};
    
//    always@(posedge clk or negedge rst_n) begin 
//        if (!rst_n)
//            clk_cnt <= 0;
//        else if(state == `SEND) begin
//            if (clk_cnt == 800)
//                clk_cnt <= 0;
//            else
//                clk_cnt <= clk_cnt + 1;   
//        end else
//            clk_cnt <= 0;
//    end
    
//    always@(posedge clk or negedge rst_n) begin 
//        if (!rst_n)
//            bit_cnt <= 0;
//        else if(state == `SEND && clk_cnt == 800)
//            bit_cnt <= bit_cnt + 1;
//        else if (end_send)
//            bit_cnt <= 0;
//    end
    
//    always@(posedge clk or negedge rst_n) begin 
//        if (!rst_n)
//            data_out <= 0;
//        else if (state == `SEND)
//            data_out <= t_data_in[bit_cnt*8 +: 8];
//        else
//            data_out <= 0;
//    end 
    
//    always@(posedge clk or negedge rst_n) begin 
//        if (!rst_n)
//            data_out_vld <= 0;
//        else if(state == `SEND && clk_cnt == 20)
//            data_out_vld <= 1;
//        else 
//            data_out_vld <= 0;   
//    end
      
//    always@(posedge clk or negedge rst_n) begin 
//        if (!rst_n)
//            succ_send <= 0;
//        else if (end_send)
//            succ_send <= 1;
//        else
//            succ_send <= 0;
//    end
        
       
//endmodule


`include "../rtl/define.v"

module ctrl_uarttx # (
    localparam K = `K,
    localparam N = `N
)(
    input clk,
    input rst_n,
    input [N*K-1:0] data_out,
    input succ_exec,
    input tx_done,
    output [7:0] tx_data,
    output reg tx_start,
    output reg succ_send
);


    localparam CNT_MAX = N*K/8 - 1;

    reg [N*K-1:0] r_data_out; 
    reg r_succ_exec;
    reg [7:0] cnt;

    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)
            r_data_out <= 0;
        else if (succ_exec)
            r_data_out <= data_out;
    end
    
    always@(posedge clk) begin
        r_succ_exec <= succ_exec;
    end 
    
    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n)
            tx_start <= 0;
        else if (r_succ_exec || (tx_done && cnt < CNT_MAX))
            tx_start <= 1;
        else 
            tx_start <= 0;
    end 
    
    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n)
            cnt <= 0;
        else if (tx_done && cnt == CNT_MAX)
            cnt <= 0;
        else if (tx_done)
            cnt <= cnt + 1;
    end 
    
    assign tx_data = r_data_out[8*cnt +: 8];

    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n)
            succ_send <= 0;
        else if (tx_done && cnt == CNT_MAX)
            succ_send <= 1;
        else 
            succ_send <= 0;
    end 
    
endmodule