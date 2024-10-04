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

    reg[`WORD_LENGTH-1:0]   valA, valB, valX;

    assign opCode     = inInstr[31:26];
    assign regIdR     = inInstr[25:22];
    assign regIdA     = inInstr[8:4];
    assign regIdB     = inInstr[3:0];

    always @( posedge inClk or negedge inRst ) begin 
      
        case ( opCode )
           
            `OP_ADD, `OP_ADC, `OP_SBC, `OP_SUB: begin

            end

            `OP_AND, `OP_OR, `OP_XOR: begin

            end

            `OP_LDIL: begin 

            end

            `OP_ADDIL: begin 

            end

            `OP_CMP: begin

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


            end

        endcase

   end

endmodule


module decode ( 

    input  logic[`WORD_LENGTH-1:0]  instr,

    output logic[5:0]               opCode,
    output logic[3:0]               regIdR,
    output logic[3:0]               regIdA,
    output logic[3:0]               regIdB,
    output logic[`WORD_LENGTH-1:0]  immVal,

    );

    assign opCode     = instr[31:26];
    assign opMode     = instr[19:18];
    assign regIdR     = instr[25:22];
    assign regIdA     = instr[7:4];
    assign regIdB     = instr[3:0];

    // ??? primraily set the immediate filed value ... regs are fixed...

    always @(*) begin 
      
        case ( opCode )
           
            `OP_ADD, `OP_ADC, `OP_SBC, `OP_SUB: begin

                if ( opMode == 2'b0 ) begin

                    // basic idea: the sign bit fills to the right, the other part is simply extracted...
                    // ??? perhaps write a function with bit length and pos ?
                    // y = {{ 21{ instr[15] }}, { instr[ 15:17] }};

                    // 

                end
    

            end

            `OP_AND, `OP_OR, `OP_XOR: begin

            end

            `OP_LDIL: begin 

            end

            `OP_ADDIL: begin 

            end

            `OP_CMP: begin

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

                immVal = 32'b0;

            end

        endcase

   end


endmodule


module ImmGenUnit( 


);

endmodule

