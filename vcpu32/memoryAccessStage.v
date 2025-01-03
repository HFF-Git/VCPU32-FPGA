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
//------------------------------------------------------------------------------------------------------------
module MemoryAccessStage ( 
   
    input  logic                    clk,
    input  logic                    rst, 
    
    //--------------------------------------------------------------------------------------------------------
    // Pipeline stage input.
    //-------------------------------------------------------------------------------------------------------- 
    input  logic[WORD_LENGTH-1:0]   fdMaPstate0,
    input  logic[WORD_LENGTH-1:0]   fdMaPstate1,
    input  logic[WORD_LENGTH-1:0]   fdMaInstr,
    input  logic[WORD_LENGTH-1:0]   fdMaValA,
    input  logic[WORD_LENGTH-1:0]   fdMaValB,
    input  logic[WORD_LENGTH-1:0]   fdMaValX,

    //--------------------------------------------------------------------------------------------------------
    // Pipeline stage output.
    //-------------------------------------------------------------------------------------------------------- 
    output logic[WORD_LENGTH-1:0]   maExPstate0,
    output logic[WORD_LENGTH-1:0]   maExPstate1,
    output logic[WORD_LENGTH-1:0]   maExInsr,
    output logic[WORD_LENGTH-1:0]   maExValA,
    output logic[WORD_LENGTH-1:0]   maExValB,
    output logic[WORD_LENGTH-1:0]   maExValX

     //--------------------------------------------------------------------------------------------------------  
    // Interface to the D-Cache
    //-------------------------------------------------------------------------------------------------------- 


    //--------------------------------------------------------------------------------------------------------  
    // Interface to the D-TLB
    //-------------------------------------------------------------------------------------------------------- 


    //--------------------------------------------------------------------------------------------------------      
    // Trap Interface
    //-------------------------------------------------------------------------------------------------------- 

  
    );


    reg  halfCycle;  

    //--------------------------------------------------------------------------------------------------------
    // "Always" block for the half cycle logic. Each pipeline stage is structured into two parts. A pipeline
    // cycle is therefore actually two cock cycles.
    // 
    //-------------------------------------------------------------------------------------------------------- 
     always @( posedge clk or negedge rst ) begin

        if (! rst ) halfCycle <= 0;
        else        halfCycle <= ~ halfCycle;
        
    end



endmodule
