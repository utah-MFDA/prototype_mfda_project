module smart_toilet (out,
    soln1,
    soln2,
    soln3);
 output out;
 input soln1;
 input soln2;
 input soln3;

 wire connect0;
 wire connect01;
 wire connect02;
 wire connect1;
 wire connect2;
 wire connect3;
 wire connect31;
 wire connect32;
 wire connect33;
 wire connect34;
 wire connect35;
 wire connect36;
 wire connect37;
 wire connect5;
 wire connect6;

 diffmix_25px_0 mix0 (.a_fluid(soln1),
    .b_fluid(connect1),
    .out_fluid(connect2));
 diffmix_25px_0 mix1 (.a_fluid(connect2),
    .b_fluid(connect5),
    .out_fluid(connect6));
 serpentine_200px_0 serp1 (.in_fluid(soln2),
    .out_fluid(connect0));
 serpentine_200px_0 serp1_1 (.in_fluid(connect0),
    .out_fluid(connect01));
 serpentine_200px_0 serp1_2 (.in_fluid(connect01),
    .out_fluid(connect02));
 serpentine_200px_0 serp2 (.in_fluid(connect02),
    .out_fluid(connect1));
 serpentine_300px_2 serp4 (.in_fluid(soln3),
    .out_fluid(connect3));
 serpentine_300px_2 serp6 (.in_fluid(connect3),
    .out_fluid(connect31));
 serpentine_300px_2 serp6_1 (.in_fluid(connect31),
    .out_fluid(connect32));
 serpentine_300px_2 serp6_10 (.in_fluid(connect37),
    .out_fluid(connect5));
 serpentine_300px_2 serp6_2 (.in_fluid(connect32),
    .out_fluid(connect33));
 serpentine_300px_2 serp6_3 (.in_fluid(connect33),
    .out_fluid(connect34));
 serpentine_300px_2 serp6_4 (.in_fluid(connect34),
    .out_fluid(connect35));
 serpentine_300px_2 serp6_5 (.in_fluid(connect35),
    .out_fluid(connect36));
 serpentine_300px_2 serp6_6 (.in_fluid(connect36),
    .out_fluid(connect37));
 serpentine_200px_0 serp7 (.in_fluid(connect6),
    .out_fluid(out));
endmodule
