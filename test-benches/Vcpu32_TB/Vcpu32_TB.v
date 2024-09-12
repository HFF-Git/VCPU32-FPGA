module Module1_TB(


);

// ??? a bit ugly to specify the dedicated path. cmake offers a possibility to replace 
// a token with cmae variables...

initial begin
    $dumpfile("../../build/test-benches/Module1_TB/Module1_TB.vcd");  
    $dumpvars(0, Module1_TB);
    // Other initialization code...
end

// add some coding to see vvp and vcd files being created....



endmodule