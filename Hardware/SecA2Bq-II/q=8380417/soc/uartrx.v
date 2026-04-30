module uartrx # (
    parameter BPS = 115200, 
    parameter CLK_FREQ = 5_000_000
)
(
    input clk,
    input rst_n,
    input rx,
    output reg [7:0] rx_data,
    output reg rx_done
);


    localparam CNT_MAX = CLK_FREQ/BPS - 1;


    reg [1:0] r_rx;

    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)
            r_rx <= 1'b0;
        else
            r_rx <= {r_rx[0], rx};
    end

    assign nege_rx = !r_rx[0] && r_rx[1];


    reg rx_en;
    wire done_flag;
    assign done_flag = (bps_cnt == CNT_MAX >> 1 && bit_cnt == 9);

    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rx_en <= 0;
        else if (nege_rx)
            rx_en <= 1;
        else if (bit_cnt == 0 && (bps_cnt == CNT_MAX >> 1) && rx == 1)  // Ã«´Ì
            rx_en <= 0;
        else if (done_flag)
            rx_en <= 0;
    end
    
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rx_done <= 0;
        else if (done_flag)
            rx_done <= 1;
        else
            rx_done <= 0;
    end



    reg [15:0] bps_cnt;       
    reg [3:0] bit_cnt;    

    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bps_cnt <= 0;
        else if (rx_en)
            bps_cnt <= (bps_cnt == CNT_MAX) ? 0 : bps_cnt + 1;
        else
            bps_cnt <= 0;
    end
    
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bit_cnt <= 0;
        else if (done_flag)
            bit_cnt <= 0;
        else if (bps_cnt == CNT_MAX)
            bit_cnt <= bit_cnt + 1; 
    end


    reg [7:0] r_data;  
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)
            r_data <= 0;
        else if (bps_cnt == CNT_MAX >> 1) begin 
            case (bit_cnt)
                1:  r_data[0] <= r_rx[1];
                2:  r_data[1] <= r_rx[1];
                3:  r_data[2] <= r_rx[1];
                4:  r_data[3] <= r_rx[1];
                5:  r_data[4] <= r_rx[1];
                6:  r_data[5] <= r_rx[1];
                7:  r_data[6] <= r_rx[1];
                8:  r_data[7] <= r_rx[1];
                default: r_data <= r_data;
            endcase
        end
    end
   
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rx_data <= 8'b0;
        else if (done_flag) begin
            rx_data <= r_data;
        end 
    end
   
endmodule