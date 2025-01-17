//------------------------------------------------------------------------------------------------------------
//
//  VCPU-32
//
//  Copyright (C) 2022 - 2025 Helmut Fieres, see License file.
//------------------------------------------------------------------------------------------------------------
// 
//
//
//
//------------------------------------------------------------------------------------------------------------
`ifndef TB_HELPERS_VH
`define TB_HELPERS_VH

// Task to display an error message and terminate simulation
task display_error;
    input string msg;
    begin
        $display("ERROR: %s", msg);
        $finish;
    end
endtask

// Task to compare two values and report a mismatch
task compare;
    input [31:0] expected, actual;
    begin
        if (expected !== actual) begin
            $display("Mismatch: expected = %h, actual = %h", expected, actual);
            `display_error("Test failed due to mismatch");
        end
    end
endtask

`endif // TB_HELPERS_VH
