`include "../rtl/define.v"

module ctrl_design(
    input clk,
    input rst_n, 
    input succ_recv,        
    input succ_exec,           
    input succ_send,         
    output reg trigger,  
    output reg [9:0] cnt,                   
    output reg [1:0] state              
);


    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n)
            cnt <= 0;
        else if (state == `EXEC && !succ_exec)
            cnt <= cnt + 1;
        else
            cnt <= 0;
     end 


    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            trigger <= 0;
        else if(state == `EXEC && !succ_exec)
            trigger <= 1;
        else
            trigger <= 0;
    end

    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            state <= `RECV;
        else case (state) 
            `RECV: if (succ_recv) state <= `EXEC;
            `EXEC: if (succ_exec) state <= `SEND;
            `SEND: if (succ_send) state <= `RECV;
            default: ;
        endcase
    end 


endmodule