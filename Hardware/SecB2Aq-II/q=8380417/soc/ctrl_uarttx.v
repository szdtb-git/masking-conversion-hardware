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


    localparam CNT_MAX = N*(K+1)/8 - 1;

    reg [N*(K+1)-1:0] r_data_out; 
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