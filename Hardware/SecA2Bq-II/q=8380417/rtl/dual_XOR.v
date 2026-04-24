(*keep_hirearchy = "true",dont_touch = "true"*) module dual_XOR 
(
    input [1:0] x,
    input [1:0] y,
    output [1:0] z
);


    assign z[1] = (x[1] & y[0]) | (x[0] & y[1]);
    assign z[0] = (x[0] & y[0]) | (x[1] & y[1]);


endmodule