//------------------------------------------------------------------------------------------------------------
//
//  VCPU32-FPGA
//
//  Copyright (C) 2022 - 2024 Helmut Fieres, see License file.
//------------------------------------------------------------------------------------------------------------
// This file contains the fetch and decode pipeline stage logic.
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
// The fetch and decode stage is a two part stage. The first part will access the instruction memory interface
// and obtain the instruction. The second part will decode the instruction and prepare the information to 
// access the general register file.
//
// 
//------------------------------------------------------------------------------------------------------------
module FetchDecodeStage( 
   
    input   logic                       clk,
    input   logic                       rst, 
    
    input   logic[`WORD_LENGTH-1:0]     inPstate0,
    input   logic[`WORD_LENGTH-1:0]     inPstate1,

    input   logic[`WORD_LENGTH-1:0]     regByPassVal,
    
    output  logic[`WORD_LENGTH-1:0]     outPstate0,
    output  logic[`WORD_LENGTH-1:0]     ourPstate1,
    output  logic[`WORD_LENGTH-1:0]     instr,

    // ??? interface to the GREG register file

    output  logic[3:0]                  readRegIdA,
    input   logic[`WORD_LENGTH-1:0]     readRegA,

    output  logic[3:0]                  readRegIdB,
    input   logic[`WORD_LENGTH-1:0]     readRegB,

    output  logic[3:0]                  readRegIdX, 
    input   logic[`WORD_LENGTH-1:0]     readRegX,

    // ??? pipeline output regs values
    
    output  reg[`WORD_LENGTH-1:0]       valA,
    output  reg[`WORD_LENGTH-1:0]       valB,
    output  reg[`WORD_LENGTH-1:0]       valX

    // Trap interface ?

    // JTAG interface ?

    // I-MEM unit interface ?
  
    );

    localparam              ZERO            = {`WORD_LENGTH{1'b0}};
    
    localparam              SEL_ZERO_VAL    = 2'b00;
    localparam              SEL_NORMAL_REG  = 2'b01;
    localparam              SEL_BYPASS_REG  = 2'b10;
    localparam              SEL_IMM_VAL     = 2'b11;
    
   
    //--------------------------------------------------------------------------------------------------------
    //
    //
    //--------------------------------------------------------------------------------------------------------
   
    logic[`WORD_LENGTH-1:0]     immVal;

    logic                       wEnable;
    logic                       validInstr;

    //--------------------------------------------------------------------------------------------------------
    //  
    //
    //  ??? set the register values...
    //--------------------------------------------------------------------------------------------------------
    always @( posedge clk or negedge rst ) begin

        if ( ! rst ) begin

            // ??? clear all regs...

            valA <= ZERO;
            valB <= ZERO;
            valX <= ZERO;

        end else if ( wEnable ) begin 

            // ??? set other regs...

            valA <= ZERO;
            valB <= ZERO;
            valX <= ZERO;
            
        end 

    end

    //--------------------------------------------------------------------------------------------------------
    // "decode" is the combinatorial logic that decodes from the instruction word for the register numbers 
    // and the immediate value if there is one in the instruction. If the instruction opCode is not defined, 
    // the "valid" line is set to zero.
    //
    //--------------------------------------------------------------------------------------------------------
    task decode;

        readRegIdA      = 4'b0;
        readRegIdB      = 4'b0;
        readRegIdX      = 4'b0;
        immVal          = ZERO;
        validInstr      = 1'b1;
    
        case ( instr[31:26] )
        
            `OP_ADD, `OP_ADC, `OP_SBC, `OP_SUB, `OP_AND, `OP_OR, `OP_XOR, `OP_CMP: begin

                case ( instr[19:18] ) 

                    2'b00: begin 

                        readRegIdA  = instr[25:22];
                        immVal      = {{ 15{ instr[0]}}, { instr[17:0] }};
                    end

                    2'b01,  2'b10: begin 

                        readRegIdA  = instr[7:4];
                        readRegIdB  = instr[3:0];
                    end

                    2'b11: begin 
                        
                        readRegIdB  = instr[3:0];
                        immVal      = {{ 21{ instr[4]}}, { instr[15:5] }};
                    end

                endcase

            end

            `OP_LDIL: begin 

            end

            `OP_ADDIL: begin 

            end

            `OP_LSID: begin

            end

            `OP_EXTR, `OP_DEP: begin 

            end

            `OP_DS: begin
            
            end

            `OP_DSR: begin 

            end

            `OP_SHLA: begin

            end

            `OP_LD: begin

            end

            `OP_ST: begin

            end

            `OP_LDA: begin

            end 

            `OP_STA: begin

            end 

            `OP_LDR: begin

            end

            `OP_STC: begin

            end

            `OP_B: begin

            end 

            `OP_BR: begin

            end

            `OP_BE: begin

            end 

            `OP_BV: begin

            end

            `OP_BVE: begin

            end

            `OP_CBR: begin

            end 

            `OP_CMR: begin

            end

            `OP_MR: begin 

            end

            `OP_MST: begin 

            end

            `OP_LDPA: begin 

            end

            `OP_PRB: begin 

            end

            `OP_GATE: begin 

            end

            `OP_ITLB: begin 

            end

            `OP_PTLB: begin 

            end

            `OP_PCA: begin 

            end

            `OP_RFI: begin 

            end

            `OP_DIAG: begin 

            end

            `OP_BRK: begin 

            end

            default: begin

                validInstr  = 1'b0;

            end

        endcase

    endtask


    //--------------------------------------------------------------------------------------------------------
    //
    // ??? have a function that sets one of the reg values A, B or X. 

    //--------------------------------------------------------------------------------------------------------
    function setRegVal( 

        input logic                     sel,

        input logic[3:0]                regValId,
        input logic[`WORD_LENGTH-1:0]   regVal,

        input logic[3:0]                bypassId,
        input logic[`WORD_LENGTH-1:0]   bypassVal,

        input logic[`WORD_LENGTH-1:0]   immVal
  
        );

        // ??? if sel == 1 use regs else use immVal



    endfunction

endmodule



