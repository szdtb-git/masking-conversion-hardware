`include "../rtl/define.v"

module ctrl_uartrx # (
    localparam K = `K,
    localparam N = `N
)
(
    input clk,
    input rst_n,
    input [7:0] data_in,                    
    input data_in_ena,                      
    input [1:0]state,
    output reg succ_recv,               
    output [N*K-1:0] data_xA,                                           
//    output [K-1:0] data_p,                                           
    output [216:0] data_r                        
);


    localparam l = N*K + 217;
    localparam r = l%8;
    localparam all = r ? l + 8 - r : l;
    localparam max_flag = all/8;
    
    reg [10:0]flag;                             
    reg [all-1:0] data_all;
    
    
    assign data_xA = data_all[0 +: N*K];
//    assign data_p = data_all[N*K +: K];
    assign data_r = data_all[N*K +: 217];
    
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)
            flag <= 0;
        else if (state == `RECV) begin 
            if (data_in_ena)
                flag <= flag + 1;
            else
                flag <= flag;
        end else 
            flag <= 0;         
    end 


    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            data_all <= 0;
        else if (state == `RECV) begin
            if (data_in_ena) begin
//                if (flag < max_flag)
                    data_all <= {data_in, data_all[all-1:8]};
//                else if (flag == max_flag) begin 
//                    if (r > 0)
//                        data_all <= {data_in[r-1:0], data_all[g-1:r]};
//                    else
//                        data_all <= {data_in[7:0], data_all[g-1:8]};
//                end 
            end
        end
    end
    
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)
            succ_recv <= 0;
        else if (flag == max_flag)
            succ_recv <= 1;
        else 
            succ_recv <= 0;
    end
    
    
endmodule