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
`ifndef MACROS_VH
`define MACROS_VH

// Macro for a simple AND gate
`define AND_GATE(a, b, y) \
    assign y = a & b;

// Macro to initialize memory or registers in testbenches
`define INIT_MEM(array, value) \
    integer i; \
    initial begin \
        for (i = 0; i < $size(array); i = i + 1) \
            array[i] = value; \
    end

// Macro for conditional simulation message
`define SIM_MSG(msg) \
    initial begin \
        $display(msg); \
    end

`endif // MACROS_VH
