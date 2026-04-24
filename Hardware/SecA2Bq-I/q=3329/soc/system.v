`include "../rtl/define.v"

module system # (
    localparam K = `K,
    localparam N = `N
)
(
    input clk,                      
    input sys_rst,                  
    input rx,                     
//    output reg trigger,               
    output reg tx              
);

 

//    (*DONT_TOUCH = "TRUE"*)wire sys_clk;                   
//    divisor udvs(                                           
//        .clk (clk),                                                 
//        .rstn (sys_rst),
//        .clk_div (sys_clk)
//    );


    (*DONT_TOUCH = "TRUE"*)wire succ_recv;         
    (*DONT_TOUCH = "TRUE"*)wire succ_exec;                 
    (*DONT_TOUCH = "TRUE"*)wire succ_send;                
    (*DONT_TOUCH = "TRUE"*)wire trigger;                     
    (*DONT_TOUCH = "TRUE"*)wire [1:0] state;                
    (*DONT_TOUCH = "TRUE"*)wire tx;                     


    ctrl_design ucd(
        .clk (clk),                                         
        .rst_n (sys_rst),
        .succ_recv (succ_recv),
        .succ_exec (succ_exec),
        .succ_send (succ_send),
        .trigger (trigger),
        .state (state)
    );



    (*DONT_TOUCH = "TRUE"*)wire [7:0] data_fifo;            
    (*DONT_TOUCH = "TRUE"*)wire [7:0] data_out;            
    (*DONT_TOUCH = "TRUE"*)wire uart_rx_done;              
    (*DONT_TOUCH = "TRUE"*)wire uart_tx_done;              
    (*DONT_TOUCH = "TRUE"*)wire uart_tx_en;                 
    
    (*DONT_TOUCH = "TRUE"*)wire [N*K-1:0] data_xA;
    (*DONT_TOUCH = "TRUE"*)wire [N*K-1:0] data_xB;
    (*DONT_TOUCH = "TRUE"*)wire [111:0] data_r;

    
//    uartrx urx(
//        .sys_clk (clk),
//        .sys_rst_n (sys_rst),
//        .uart_rxd (rx),
//        .uart_rx_done (uart_rx_done),
//        .uart_rx_data (data_fifo)
//    );

//    ctrl_uartrx crx(
//        .clk (clk),
//        .rst_n (sys_rst),
//        .data_in (data_fifo),
//        .data_in_ena (uart_rx_done),
//        .state (state),
//        .succ_recv (succ_recv),
//        .data_xA(data_xA),
//        .data_r(data_r)
//    );


    uartrx urx(
        .clk (clk),
        .rst_n (sys_rst),
        .rx (rx),
        .rx_done (uart_rx_done),
        .rx_data (data_fifo)
    );

    ctrl_uartrx crx(
        .clk (clk),
        .rst_n (sys_rst),
        .rx_data (data_fifo),
        .rx_done (uart_rx_done),
        .state (state),
        .succ_recv (succ_recv),
        .data_xA(data_xA),
        .data_r(data_r)
    );
    
     A2Bp_top2 top
    (
        .clk(clk),
        .rst_n(sys_rst),
        .state(state),
        .data_xA(data_xA),
        .data_r(data_r),
        .data_xB(data_xB),
        .succ_exec(succ_exec)
    );

       
//     uarttx utx(
//        .sys_clk (clk),
//        .sys_rst_n (sys_rst),
//        .uart_tx_data (data_out),
//        .uart_tx_en (uart_tx_en),
//        .uart_tx_rdy (),
//        .uart_txd (tx)
//    );
    
//    ctrl_uarttx uct(
//        .clk (clk),
//        .rst_n (sys_rst),
//        .data_in (data_xB),
//        .state (state),
//        .data_out (data_out),
//        .succ_send (succ_send),
//        .data_out_vld(uart_tx_en)
//    );

    uarttx utx(
        .clk (clk),
        .rst_n (sys_rst),
        .tx_start (uart_tx_en),
        .tx_data (data_out),
        .tx_done (uart_tx_done),
        .tx (tx)
    );
    
    ctrl_uarttx uct(
        .clk (clk),
        .rst_n (sys_rst),
        .data_out (data_xB),
        .succ_exec (succ_exec),
        .tx_done(uart_tx_done),
        .tx_data (data_out),
        .succ_send (succ_send),
        .tx_start(uart_tx_en)
    );
    
endmodule