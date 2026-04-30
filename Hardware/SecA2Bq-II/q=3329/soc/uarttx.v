module uarttx # (
    parameter BPS = 115200, 
    parameter CLK_FREQ = 5_000_000
)
(
    input clk,
    input rst_n,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_done
);


    localparam CNT_MAX = CLK_FREQ/BPS - 1;

    reg tx_en;
    wire done_flag;
    assign done_flag = (bit_cnt == 9 && bps_cnt == CNT_MAX);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            tx_en <= 0;
        else if (tx_start)
            tx_en <= 1;
        else if (done_flag)
            tx_en <= 0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            tx_done <= 0;
        else if (done_flag)
            tx_done <= 1;
        else
            tx_done <= 0;
    end 



    reg [9:0] bps_cnt;          
    reg [3:0] bit_cnt; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bps_cnt <= 0;
        else if (tx_en)
            bps_cnt <= (bps_cnt == CNT_MAX) ? 0 : bps_cnt + 1;
        else
            bps_cnt <= 0;
    end

    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bit_cnt <= 0;
        else if (bps_cnt == CNT_MAX) begin 
            if (bit_cnt == 9)
                bit_cnt <= 0;
            else
                bit_cnt <= bit_cnt + 1;
        end 
    end



    reg [7:0] r_data;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            r_data <= 8'b0;
        else if (tx_start)
            r_data <= tx_data;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            tx <= 1;
        else if (tx_en) begin
            case(bit_cnt)
                0: tx <= 1'b0;
                1: tx <= r_data[0];
                2: tx <= r_data[1];
                3: tx <= r_data[2];
                4: tx <= r_data[3];
                5: tx <= r_data[4];
                6: tx <= r_data[5];
                7: tx <= r_data[6];
                8: tx <= r_data[7];
                9: tx <= 1'b1;
                default: tx <= 1'b1;
            endcase
        end
    end

endmodule