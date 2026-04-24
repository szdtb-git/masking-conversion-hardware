
(*keep_hirearchy = "true",dont_touch = "true"*) module SecAnd 
(
    input [7:0] tb_and,
    input [1:0] x,
    input [1:0] y,
    output [1:0] z
);


    assign z[1] = (x[0] & y[0] & tb_and[4]) | 
                  (x[0] & y[1] & tb_and[5]) | 
                  (x[1] & y[0] & tb_and[6]) |
                  (x[1] & y[1] & tb_and[7]);
                       
    assign z[0] = (x[0] & y[0] & tb_and[0]) | 
                  (x[0] & y[1] & tb_and[1]) | 
                  (x[1] & y[0] & tb_and[2]) |
                  (x[1] & y[1] & tb_and[3]);

        

endmodule