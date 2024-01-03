module %template% (
    soln1,
    soln2,
    soln3,
    out
);

input   soln1, soln2, soln3;
output  out;

wire  

// Soln1
serpentine_100px_0  serp10  (.in_fluid(soln1), .out_fluid(connect10));

// Soln2
serpentine_100px_0  serp20   (.in_fluid(soln2), .out_fluid(connect20));

// Soln3
serpentine_200px_0  serp30   (.in_fluid(soln3), .out_fluid(connect30));

// Mixers
diffmix_25px_0      mix0    (.a_fluid(connect20), .b_fluid(connect10), .out_fluid(connect_m0));
diffmix_25px_0      mix1    (.a_fluid(connect_m0), .b_fluid(connect30), .out_fluid(connect_m1));

serpentine_200px_0  serp7  (.in_fluid(connect_m1), .out_fluid(out));


endmodule

