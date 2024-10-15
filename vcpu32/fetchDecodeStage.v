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
// and obtain the instruction. The secpnd part will dcode the instruction and prepare the information to 
// access the generaö register file.
//
//------------------------------------------------------------------------------------------------------------
module FetchDecodeStage( 
   
    input   logic                   clk,
    input   logic                   rst, 
    
    input   logic[`WORD_LENGTH-1:0] inPstate0,
    input   logic[`WORD_LENGTH-1:0] inPstate1,

    input   logic[`WORD_LENGTH-1:0] regByPassVal,
    
    output  logic[`WORD_LENGTH-1:0] outPstate0,
    output  logic[`WORD_LENGTH-1:0] ourPstate1,
    output  logic[`WORD_LENGTH-1:0] instr,
    output  logic[`WORD_LENGTH-1:0] valA,
    output  logic[`WORD_LENGTH-1:0] valB,
    output  logic[`WORD_LENGTH-1:0] valX

    // general register write back interface ?

    // Trap interface ?

    // JTAG interface ?

    // I-MEM unit interface ?
  
    );

    Register                instrReg ( .clk( clk ), .rst( rst ), .d( ), .q( instr ) );

    logic[`WORD_LENGTH-1:0] readDataA, readDataB, readDataX, writeDataR, writeDataX, immVal;
    logic[3:0]              readAddrA, readAddrB, readAddrX, writeAddrR, writeAddrX;

    Register_file_3R_2W     gregFile (  .clk( clk ), 
                                        .rst( rst),  
                                        .readAddr1( readAddrA ),
                                        .readData1( readDataA ),
                                        .readAddr2( readAddrB ),
                                        .readData2( readDataB ),
                                        .readAddr3( readAddrX ),
                                        .readData3( readDataX ),

                                        .writeAddr1( writeAddrR ),
                                        .writeData1( writeDataR ),
                                        .writeAddr2( writeAddrX ),
                                        .writeData2( writeDataX )
                                        
                                        );

    Mux_2_1  #( .WIDTH( `WORD_LENGTH )) muxValA (   .sel( ), 
                                                    .enb( ), 
                                                    .a0( regByPassVal ), 
                                                    .a1( readDataA ), 
                                                    .y( valA )); 

    Mux_4_1  #( .WIDTH( `WORD_LENGTH )) muxValB (   .sel( ), 
                                                    .enb( ), 
                                                    .a0( regByPassVal ), 
                                                    .a1( readDataB ), 
                                                    .a2( immVal ), 
                                                    .a3( ),
                                                    .y( valB )); 
                                
    Mux_4_1  #( .WIDTH( `WORD_LENGTH )) muxValX (   .sel( ), 
                                                    .enb( ), 
                                                    .a0( regByPassVal ), 
                                                    .a1( readDataX ), 
                                                    .a2( immVal ), 
                                                    .a3( ),
                                                    .y( valX ));

    FetchSubStage fetchSubStage (   .clk( clk ),
                                    .rst( rst ),
                                    .pState0( ),
                                    .pState1( ),
                                    
                                    .instr( ));

    DecodeSubStage decodeSubStage ( .clk( clk ),
                                    .rst( rst ),
                                    .instr( instr ), 
                                    .regIdA( readAddrA ), 
                                    .regIdB( readAddrB ), 
                                    .regIdX( readAddrX ), 
                                    .immVal( immVal ), 
                                    .valid( )


                                    );


endmodule


//------------------------------------------------------------------------------------------------------------
// "fetchSubStage" contains the logic for getting the next instruction.
//
//
//------------------------------------------------------------------------------------------------------------
module FetchSubStage( 

    input  logic                   clk,
    input  logic                   rst,

    input  logic[`WORD_LENGTH-1:0] pState0,
    input  logic[`WORD_LENGTH-1:0] pState1,

    output logic[`WORD_LENGTH-1:0] instr,

    output logic                   valid

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
    input  logic[`WORD_LENGTH-1:0] instr,


    output logic[3:0]               regIdA,
    output logic[3:0]               regIdB,
    output logic[3:0]               regIdX,
    output logic[`WORD_LENGTH-1:0]  immVal,

    output logic                    valid
   
    
    // trap logic
    // stall logic
    // next instrcution address logic ?

    );

    DecodeLogic decode  (   .instr( instr ), 
                            .regIdA( regIdA ), 
                            .regIdB( regIdB ), 
                            .regIdX( regIdX ), 
                            .immVal( immVal ), 
                            .valid( ));

    always @( negedge rst ) begin

    end

    always @( posedge clk ) begin

    end

endmodule

//------------------------------------------------------------------------------------------------------------
// "decodeLogic" is the combinatorila logic that decdes forn the instruction word the register numbers for
// the general register file. It also decodes the immediate value if there is one in the instruction. If 
// the instruction opCode is not defined, the "valid" line is set to zero.
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

    logic [5:0] opCode;
    logic [1:0] opMode;

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
