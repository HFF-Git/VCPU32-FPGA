//------------------------------------------------------------------------------------------------------------
//
//  VCPU-32
//
//  Copyright (C) 2022 - 2024 Helmut Fieres, see License file.
//------------------------------------------------------------------------------------------------------------
// 
// 
// - test benches are however separate...
//
//
//------------------------------------------------------------------------------------------------------------
`include "defines.vh"

//------------------------------------------------------------------------------------------------------------
//
//
//------------------------------------------------------------------------------------------------------------
module vcpu32(

    input logic     clk,
    input logic     rst

    );


    Register pState0 ( );
    Register pState1 ( );

    // ??? a boat load of registers, all the pipeline registers...

    // ??? should the general register file be decared here ?
    // ??? should the segment register file be decared here ?
    // ??? should the control registers be decared here ?

    // ??? the consequence is a lot of wires to pass around... the pipelien logic is then combinatorial ?

    always @( negedge clk ) begin

    end

    always @( posedge clk ) begin

    end


endmodule


