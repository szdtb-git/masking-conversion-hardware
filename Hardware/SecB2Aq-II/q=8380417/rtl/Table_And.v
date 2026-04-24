(*keep_hirearchy = "true",dont_touch = "true"*) module Table_And(
    input x1,
    input y1,
    input r,
    output [7:0] pack_tz
);


    wire [3:0] tz;
    wire [1:0] dual_tz [3:0];
    
    genvar i;
    
    assign tz[0] = ((0 ^ x1) & (0 ^ y1)) ^ r;
    assign tz[1] = ((0 ^ x1) & (1 ^ y1)) ^ r;
    assign tz[2] = ((1 ^ x1) & (0 ^ y1)) ^ r;
    assign tz[3] = ((1 ^ x1) & (1 ^ y1)) ^ r;

    assign dual_tz[0] = {tz[0], ~tz[0]};
    assign dual_tz[1] = {tz[1], ~tz[1]};
    assign dual_tz[2] = {tz[2], ~tz[2]};
    assign dual_tz[3] = {tz[3], ~tz[3]};
    
    
    for (i = 0; i < 4; i = i + 1) begin 
        assign pack_tz[i] = dual_tz[i][0];
        assign pack_tz[4+i] = dual_tz[i][1];
    end 


endmodule
