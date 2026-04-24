`timescale 1ns / 1ps
`include "../rtl/define.v"


module testbench();

    localparam K = `K;
    localparam N = `N;
    
    localparam total = (N*K) + 112;
    
    reg clk;
    reg rst;
    reg rx;
    wire trigger;
    wire tx;
    
    reg [N*K-1:0] data_xA;
    reg [111:0] data_r;
    reg [K-1:0] data_p;
    reg [total-1:0] data_all;
    
    always #50 clk = ~clk;
    
    integer i, j;
    
    initial begin 
        clk = 0;
        rst = 0;
        rx = 1;
        

        for (i = 0; i < 112; i++)
            data_r[i] = {$random} % 2;

        
        data_xA = 24'h382_c41;

        data_all = {data_r, data_xA};
        
        #300 
        rst = 1;
        
        #8680
        rx <= 0;
        for (i = 0; i < total / 8; i = i + 1)begin
            for(j = 0; j < 8; j = j + 1) begin
                #8680
                rx <= data_all[i*8+j];
            end
            #8680
            rx <= 1;
            #8680
            rx <= 0;
        end
        
//       #8400
//       rx <= data_all[3*K+0];
//       #8400 
//       rx <= data_all[3*K+1];
//       #8400 
//       rx <= data_all[3*K+2];
//       #8400 
//       rx <= data_all[3*K+3];
//       #8400 
//       rx <= data_all[3*K+4];
//       #8400 
//       rx <= data_all[3*K+5];
//       #8400 
//       rx <= 0;
//       #8400 
//       rx <= 0;
     
//       #8400
//       rx <= 1;
//       #8400
//       rx <= 0;
       
    end     



system sys (
    clk,
    rst,
    rx,
//    trigger,
    tx
);



endmodule

