//------------------------------------------------------------------------------------------------------------
//
//  VCPU-32
//
//  Copyright (C) 2022 - 2024 Helmut Fieres, see License file.
//------------------------------------------------------------------------------------------------------------
// This file contains a family of register files. They feature one or more read ports and one or two write
// ports. The read operation is an asynchronous operation, the write operation takles place synchronous to
// the clock signal.
//
//------------------------------------------------------------------------------------------------------------
`include "defines.vh"


//------------------------------------------------------------------------------------------------------------
// Mapping cheat sheet: Our CPU thinks 0 ... 31, Verilog conventions: 31 : 0.
//
// 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
// 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
//------------------------------------------------------------------------------------------------------------

// ??? note: control regs are not really a register file, they are to special. However we would like to 
// access them with a number in some cases.


//------------------------------------------------------------------------------------------------------------
//
//
//
// ??? all in one module ?
//------------------------------------------------------------------------------------------------------------
module OperandFetchStage ( 
   
    input  logic                   inClk,
    input  logic                   inRst, 
    
    input  logic[`WORD_LENGTH-1:0] inPstate0,
    input  logic[`WORD_LENGTH-1:0] inPstate1,
    input  logic[`WORD_LENGTH-1:0] inInstr,
   
    output logic[`WORD_LENGTH-1:0] outPstate0,
    output logic[`WORD_LENGTH-1:0] ourPstate1,
    output logic[`WORD_LENGTH-1:0] outI,
    output logic[`WORD_LENGTH-1:0] outA,
    output logic[`WORD_LENGTH-1:0] outB,
    output logic[`WORD_LENGTH-1:0] outX
  
    );

    reg[`WORD_LENGTH-1:0]   valA, valB, valX;

    logic [5:0] opCode;
    logic [3:0] regIdR;
    logic [3:0] regIdA;
    logic [3:0] regIdB;

    assign opCode     = inInstr[31:26];
    assign regIdR     = inInstr[25:22];
    assign regIdA     = inInstr[8:4];
    assign regIdB     = inInstr[3:0];

    assign outA       = valA;
    assign outB       = valB;
    assign outX       = valX;
    assign outI       = inInstr;


endmodule

//------------------------------------------------------------------------------------------------------------
//
//
//------------------------------------------------------------------------------------------------------------
module AdrSelect ( 


);


endmodule