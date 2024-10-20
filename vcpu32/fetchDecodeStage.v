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

    //--------------------------------------------------------------------------------------------------------
    // Pipeline stage input.
    //-------------------------------------------------------------------------------------------------------- 
    input   logic[`WORD_LENGTH-1:0]     inPstate0,
    input   logic[`WORD_LENGTH-1:0]     inPstate1,

    input   logic[3:0]                  bypassRegId,
    input   logic[`WORD_LENGTH-1:0]     bypassRegVal,

    //--------------------------------------------------------------------------------------------------------
    // Pipeline stage output.
    //-------------------------------------------------------------------------------------------------------- 
    output  logic[`WORD_LENGTH-1:0]     outPstate0,
    output  logic[`WORD_LENGTH-1:0]     outPstate1,
    output  logic[`WORD_LENGTH-1:0]     outInstr,

    output  reg[`WORD_LENGTH-1:0]       outValA,
    output  reg[`WORD_LENGTH-1:0]       outValB,
    output  reg[`WORD_LENGTH-1:0]       outValX,

    //--------------------------------------------------------------------------------------------------------  
    // Interface to the GREG register file.
    //-------------------------------------------------------------------------------------------------------- 
    output  reg[3:0]                    outRegIdA,
    input   logic[`WORD_LENGTH-1:0]     inRegValA,

    output  reg[3:0]                    outRegIdB,
    input   logic[`WORD_LENGTH-1:0]     inRegValB,

    output  reg[3:0]                    outRegIdX, 
    input   logic[`WORD_LENGTH-1:0]     inRegValX

    //--------------------------------------------------------------------------------------------------------  
    // Interface to the I-Cache
    //-------------------------------------------------------------------------------------------------------- 


    //--------------------------------------------------------------------------------------------------------  
    // Interface to the I-TLB
    //-------------------------------------------------------------------------------------------------------- 


    //--------------------------------------------------------------------------------------------------------      
    // Trap Interface
    //-------------------------------------------------------------------------------------------------------- 


    //--------------------------------------------------------------------------------------------------------      
    // JTAG Interface
    //-------------------------------------------------------------------------------------------------------- 
    
  
    );

    //--------------------------------------------------------------------------------------------------------
    // Local definitions.
    //
    //--------------------------------------------------------------------------------------------------------
    localparam                  ZERO            = {`WORD_LENGTH{1'b0}};
    localparam                  SEL_REG_VAL     = 1'b0;
    localparam                  SEL_IMM_VAL     = 1'b1;
    
    logic                       wEnable;
    logic                       validInstr;
    logic[`WORD_LENGTH-1:0]     instr; 
    logic[`WORD_LENGTH-1:0]     immVal;
    logic[1:0]                  valSelectA, valSelectB, valSelectX;


    //--------------------------------------------------------------------------------------------------------
    // "Always" block for the instruction decode combinatorial logic.
    //
    //-------------------------------------------------------------------------------------------------------- 
    always @( instr ) begin

        decodeInstr( );

    end
   
    //--------------------------------------------------------------------------------------------------------
    // "Always" block for the pipeline stage output. We pass on the PSTATE, INSTR, A, B and X. The values are
    // set on the rising edge of the clock.
    //
    //--------------------------------------------------------------------------------------------------------
    always @( posedge clk or negedge rst ) begin

        if ( ! rst ) begin
            
            outPstate0  <= ZERO;
            outPstate1  <= ZERO;
            outInstr    <= ZERO;
            outValA     <= ZERO;
            outValB     <= ZERO;
            outValX     <= ZERO;

        end else if ( wEnable ) begin 

            outPstate0  <= inPstate0;
            outPstate1  <= inPstate1;
            outInstr    <= instr;

            outValA     <= getVal(  valSelectA,
                                    outRegIdA,
                                    inRegValA,
                                    bypassRegId,
                                    bypassRegVal,
                                    immVal );

            outValB     <= getVal(  valSelectB,
                                    outRegIdB,
                                    inRegValB,
                                    bypassRegId,
                                    bypassRegVal,
                                    immVal );

            outValX     <= getVal(  valSelectX,
                                    outRegIdX,
                                    inRegValX,
                                    bypassRegId,
                                    bypassRegVal,
                                    immVal );

        end 

    end

    //--------------------------------------------------------------------------------------------------------
    // "decodeInstr" is the combinatorial logic that decodes from the instruction word for the register IDs 
    // and the immediate value if there is one in the instruction. The default values for a register is the
    // register zero, which always read as a zero value and a NOP when written to. The select variables are
    // set to either specify that the we either select the register value or the immediate value in the 
    // "always" block where the pipeline stage registers are set. If the instruction opCode is not defined, 
    // the "valid" line is set to zero. 
    //
    //--------------------------------------------------------------------------------------------------------
    task decodeInstr;

        valSelectA      = SEL_REG_VAL;  
        outRegIdA       = 4'b0;

        valSelectB      = SEL_REG_VAL; 
        outRegIdB       = 4'b0;
        
        valSelectX      = SEL_REG_VAL; 
        outRegIdX       = 4'b0;
        
        immVal          = ZERO;
        validInstr      = 1'b1;
    
        case ( instr[31:26] )
        
            `OP_ADD, `OP_ADC, `OP_SBC, `OP_SUB, `OP_AND, `OP_OR, `OP_XOR, `OP_CMP: begin

                case ( instr[19:18] ) 

                    2'b00: begin 

                        valSelectA  = SEL_REG_VAL;
                        outRegIdA  = instr[25:22];
                        immVal      = {{ 15{ instr[0]}}, { instr[17:0] }};
                    end

                    2'b01,  2'b10: begin 

                        valSelectA  = SEL_REG_VAL;      
                        outRegIdA  = instr[7:4];
                        valSelectB  = SEL_REG_VAL;
                        outRegIdB  = instr[3:0];
                    end

                    2'b11: begin 
                        
                        valSelectB  = SEL_REG_VAL;
                        outRegIdB  = instr[3:0];
                        valSelectX  = SEL_IMM_VAL;
                        immVal      = {{ 21{ instr[4]}}, { instr[15:5] }};
                    
                    end

                endcase

            end

            `OP_LDIL: begin 

                valSelectB  = SEL_IMM_VAL;
                immVal      = {{ 10{ 1'b0 }}, { instr[21:0] }};

            end

            `OP_ADDIL: begin 

                valSelectA  = SEL_REG_VAL;
                outRegIdA  = instr[25:22];
                valSelectX  = SEL_IMM_VAL;
                immVal      = {{ 10{ 1'b0 }}, { instr[21:0] }};

            end

            `OP_LSID: begin

                valSelectB  = SEL_REG_VAL;
                outRegIdB  = instr[3:0];

            end

            // ??? combine all opCodes that use A and B as input regs....

            `OP_EXTR, `OP_DEP: begin 

                valSelectA  = SEL_REG_VAL;
                outRegIdA  = instr[25:22];
                valSelectB  = SEL_REG_VAL;
                outRegIdB  = instr[3:0];

            end

            `OP_DS: begin

                valSelectA  = SEL_REG_VAL;
                outRegIdA  = instr[25:22];
                valSelectB  = SEL_REG_VAL;
                outRegIdB  = instr[3:0];
            
            end

            `OP_DSR: begin 

                valSelectA  = SEL_REG_VAL;
                outRegIdA  = instr[7:4];
                valSelectB  = SEL_REG_VAL;
                outRegIdB  = instr[3:0];

            end

            `OP_SHLA: begin

                // ??? we have a bit that selects IMM or REG in the instruction....

                validInstr = 1'b0;

            end

            `OP_LD: begin

                valSelectB  = SEL_REG_VAL;
                outRegIdB  = instr[3:0];

                // ??? check .....

                if ( instr[21] == 1'b0 ) begin

                    valSelectX  = SEL_REG_VAL;
                    outRegIdX  = instr[7:4];

                end else begin

                    valSelectX  = SEL_IMM_VAL;
                    immVal      = {{ 21{ instr[4]}}, { instr[15:5] }};

                end

            end

            `OP_ST: begin

                validInstr = 1'b0;

            end

            `OP_LDA: begin

                validInstr = 1'b0;

            end 

            `OP_STA: begin

                validInstr = 1'b0;

            end 

            `OP_LDR: begin

                validInstr = 1'b0;

            end

            `OP_STC: begin

                validInstr = 1'b0;

            end

            `OP_B: begin

                validInstr = 1'b0;

            end 

            `OP_BR: begin

                validInstr = 1'b0;

            end

            `OP_BE: begin

                validInstr = 1'b0;

            end 

            `OP_BV: begin

                validInstr = 1'b0;

            end

            `OP_BVE: begin

                validInstr = 1'b0;

            end

            `OP_CBR: begin

                validInstr = 1'b0;

            end 

            `OP_CMR: begin

                validInstr = 1'b0;

            end

            `OP_MR: begin 

                validInstr = 1'b0;

            end

            `OP_MST: begin 

                validInstr = 1'b0;

            end

            `OP_LDPA: begin 

                validInstr = 1'b0;

            end

            `OP_PRB: begin 

                validInstr = 1'b0;

            end

            `OP_GATE: begin 

                validInstr = 1'b0;

            end

            `OP_ITLB: begin 

                validInstr = 1'b0;

            end

            `OP_PTLB: begin 

                validInstr = 1'b0;

            end

            `OP_PCA: begin 

                validInstr = 1'b0;

            end

            `OP_RFI: begin 

                validInstr = 1'b0;

            end

            `OP_DIAG: begin 

                validInstr = 1'b0;

            end

            `OP_BRK: begin 

                validInstr = 1'b0;

            end

            default: begin

                validInstr  = 1'b0;

            end

        endcase

    endtask

    //--------------------------------------------------------------------------------------------------------
    // "getVal" is the combinatorial logic that selects the register values for the pipeline stage outputs
    // A, B or X. It select among the immediate value, the regular register or the bypass value for register
    // bypass situation.
    //
    //--------------------------------------------------------------------------------------------------------
    function [`WORD_LENGTH-1:0] getVal ( 

        input logic                     sel,
        input logic[3:0]                regId,
        input logic[`WORD_LENGTH-1:0]   regVal,
        input logic[3:0]                bypassRegId,
        input logic[`WORD_LENGTH-1:0]   bypassRegVal,
        input logic[`WORD_LENGTH-1:0]   immVal
  
        );

        if ( sel == SEL_IMM_VAL ) begin

            getVal = immVal;

        end else if ( sel == SEL_REG_VAL ) begin

            if ( regId == bypassRegId ) getVal = bypassRegVal;
            else                        getVal = regVal;

        end else begin

            getVal = ZERO;

        end

    endfunction

endmodule



