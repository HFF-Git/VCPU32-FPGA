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
`ifndef PORT_MAPS_VH
`define PORT_MAPS_VH

// Commonly used port mappings, userful to have them as macros .....
`define CLOCK_RESET_MAP \
    .clk(clk), \
    .reset(reset)

`define COMMON_INPUTS_MAP \
    .data_in(data_in), \
    .addr(addr), \
    .enable(enable)

`endif // PORT_MAPS_VH
