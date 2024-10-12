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

//------------------------------------------------------------------------------------------------------------
//
//
//
// ??? big question: should we just have one stage ? YES
// ??? how do we make sure that this is not a hugo source file ?
// ??? will functions help to encapsulate details ? E.g immGen.... 
//------------------------------------------------------------------------------------------------------------
module FetchDecodeStage( 
   
    input  logic                   clk,
    input  logic                   rst, 
    
    input  logic[`WORD_LENGTH-1:0] inPstate0,
    input  logic[`WORD_LENGTH-1:0] inPstate1,
    
    output logic[`WORD_LENGTH-1:0] outPstate0,
    output logic[`WORD_LENGTH-1:0] ourPstate1,
    output logic[`WORD_LENGTH-1:0] instr,
    output logic[`WORD_LENGTH-1:0] valA,
    output logic[`WORD_LENGTH-1:0] valB,
    output logic[`WORD_LENGTH-1:0] valX
  
    );

    Register instrReg ( .clk( clk ), .rst( rst ) );

    always @( negedge rst ) begin

    end

    always @( posedge clk ) begin

    end

endmodule


//------------------------------------------------------------------------------------------------------------
// "fetchSubStage" contains the logic for getting the next instruction.
//
//
//------------------------------------------------------------------------------------------------------------
module FetchSubStage( 

    input  logic                   clk,
    input  logic                   rst,

    input  logic[`WORD_LENGTH-1:0] inPstate0,
    input  logic[`WORD_LENGTH-1:0] inPstate1,

    output logic[`WORD_LENGTH-1:0] outPstate0,
    output logic[`WORD_LENGTH-1:0] ourPstate1,
    output logic[`WORD_LENGTH-1:0] instr

    // interface to I-cache
    // stall signal
    // trap logic

    );

    always @( negedge rst ) begin

    end

    always @( posedge clk ) begin

    end

endmodule

//------------------------------------------------------------------------------------------------------------
// "decodeSubStage" decodes the instruction fetched and fetches the values from the general register file.
//
//
//------------------------------------------------------------------------------------------------------------
module DecodeSubStage( 

    input  logic                   clk,
    input  logic                   rst,

    input  logic[`WORD_LENGTH-1:0] inPstate0,
    input  logic[`WORD_LENGTH-1:0] inPstate1,

    output logic[`WORD_LENGTH-1:0] instr

    // interface to genera register file
    // trap logic
    // stall logic

    );

    DecodeLogic decode ( );

    always @( negedge rst ) begin

    end

    always @( posedge clk ) begin

    end

endmodule

//------------------------------------------------------------------------------------------------------------
// "decodeLogic" is the combinatorila logic that decdes forn the instruction word the register numbers for
// the general register file. It also decodes the immediate value if there is one in the instruction. 
//
//------------------------------------------------------------------------------------------------------------
module DecodeLogic ( 

    input  logic[`WORD_LENGTH-1:0]  instr,

    output logic[3:0]               regIdA,
    output logic[3:0]               regIdB,
    output logic[3:0]               regIdX,
    output logic[`WORD_LENGTH-1:0]  immVal,

    output logic                    valid

    );

    assign opCode     = instr[31:26];
    assign opMode     = instr[19:18];
     
    always @(*) begin 

        regIdA  = 4'b0;
        regIdB  = 4'b0;
        regIdX  = 4'b0;
        immVal  = `WORD_LENGTH'b0;
        valid   = 1'b1;
      
        case ( opCode )
           
            `OP_ADD, `OP_ADC, `OP_SBC, `OP_SUB, `OP_AND, `OP_OR, `OP_XOR, `OP_CMP: begin

                case ( opMode ) 

                    2'b00: begin 

                        regIdA = instr[25:22];
                        immVal = {{ 15{ instr[0]}}, { instr[17:0] }};
                    end

                    2'b01,  2'b10: begin 

                        regIdA = instr[7:4];
                        regIdB = instr[3:0];
                    end

                    2'b11: begin 
                        
                        regIdB = instr[3:0];
                        immVal = {{ 21{ instr[4]}}, { instr[15:5] }};
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

                valid  = 1'b0;

            end

        endcase

    end

endmodule
