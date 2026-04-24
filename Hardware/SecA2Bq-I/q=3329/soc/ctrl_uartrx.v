`include "../rtl/define.v"

module ctrl_uartrx #(
    localparam K = `K,
    localparam N = `N
)(
    input clk,
    input rst_n,
    input [1:0] state,
    input rx_done,
    input [7:0] rx_data,
    output reg succ_recv,
    output [N*K-1:0] data_xA,                                                                                   
    output [111:0] data_r  
);



    localparam l = N*K + 112;
    localparam r = l%8;
    localparam all = r ? l + 8 - r : l;
    localparam max_flag = all/8;

                                    
    reg [all-1:0] data_in;
    reg [9:0] cnt;
    
    assign data_xA = data_in[0 +: N*K];
    assign data_r = data_in[N*K +: 112];

    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n)
            cnt <= 0;
        else if (state == `RECV && rx_done)         
            cnt <= (cnt == max_flag-1) ? 0 : cnt + 1; 
    end 
    
    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n) 
            data_in <= 0;
        else if (state == `RECV && rx_done)
            data_in[cnt*8 +: 8] <= rx_data;
    end 
    
    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n)
            succ_recv <= 0;
        else if (cnt == max_flag-1 && rx_done)
            succ_recv <= 1;
        else 
            succ_recv <= 0;
    end 
    

endmodule
