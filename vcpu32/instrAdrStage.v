//------------------------------------------------------------------------------------------------------------
//
//  VCPU32-FPGA
//
//  Copyright (C) 2022 - 2024 Helmut Fieres, see License file.
//------------------------------------------------------------------------------------------------------------
// This file contains the instruction address generation logic. 
//
//------------------------------------------------------------------------------------------------------------
`include "defines.vh"

//------------------------------------------------------------------------------------------------------------
// Mapping cheat sheet: Our CPU thinks 0 ... 31, Verilog conventions: 31 : 0.
//
// 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
// 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
//------------------------------------------------------------------------------------------------------------


//------------------------------------------------------------------------------------------------------------
// "InstrAdrStage" is a combinatorial logic block that selects the next instruction address to pass to the 
// fetch and decode stage. 
//
// ??? one day it may host a branch prediction function...
// ??? should the adder be in this module ? 
// ??? what to pass from FD, OF and EX ?
//------------------------------------------------------------------------------------------------------------
module InstrAdrStage ( 

    input logic rst,

    input  logic[WORD_LENGTH-1:0]   inFdPstate0,
    input  logic[WORD_LENGTH-1:0]   inFdPstate1,

    input  logic[WORD_LENGTH-1:0]   inMaPstate0,
    input  logic[WORD_LENGTH-1:0]   inMaPstate1,

    input  logic[WORD_LENGTH-1:0]   inExPstate0,
    input  logic[WORD_LENGTH-1:0]   inExPstate1,

    output logic[WORD_LENGTH-1:0]   iaFdPstate0,
    output logic[WORD_LENGTH-1:0]   iaFdPstate1

    );

    // ??? just a big selector ?


endmodule