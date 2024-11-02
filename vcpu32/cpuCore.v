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

// ??? check ...
//------------------------------------------------------------------------------------------------------------
// VCPU-32Core is the CPU core for our pipelined CPU design. This module will instantiate the major building
// blocks such as pipeline registers and pipeline stages. These objects are connected with wires and form the 
// overall pipeline core skeleton. The following figure is a simplified picture of the major modules.
//
//
//    +------------------+
//    :  +-------------+ :
//    :  :  +--------+ : :
//    :  :  :        : : :
//    :  :  :        v v v
//    :  :  :
//    :  :  :     InstrAdrStage 
//    :  :  :          :
//    :  :             :
//    :  :  :          v
//    :  :  :     PregInstrAdr [ P, O ]
//    :  :  :          :
//    :  :  :          :
//    :  :  :          v
//    :  :  +---  FetchDecodeStage
//    :  :             :
//    :  :             :              +--+--+---------------------------------------------------+    
//    :  :             :              :  :  :                                                   :
//    :  :             v              v  v  v                                                   :
//    :  :        PregFdMa [ P, O, I, A, B, X ]                                                 :
//    :  :             :                                                                        :
//    :  :             :                                                                        :
//    :  :             v                                                                        :
//    :  +------  OperandFetchStage                                                             :
//    :                :                                                                        :
//    :                :              +--+------------------------------------------------------+
//    :                :              :  :  :                                                   :
//    :                v              v  v  v                                                   :
//    :           PregMaEx [ P, O, I, A, B, X, S ]                                              :
//    :                :                                                                        :
//    :                :                                                                        :
//    :                v                                                                        :
//    +---------  ExecuteStage        ----------------------------------------------------------+
// 
// 
// The pipeline stages consist of combinatorial logic and pipeline registers. The only exception is the 
// the execute stage which does not have a pipeline register. Its result are directly fed to the 
// instruction address stage or the CPU registers. The values passed along have uppercase names used
// throughout the pipeline:
//
//    P -> instruction address segment.
//    O -> instruction address offset.
//    I -> instruction
//
//    A -> value A passed to next stage.
//    B -> value B passed to next stage.
//    X -> value X passed to next stage.
//    S -> value S passed to next stage.
//    R - Ex stage computation result.
//
// The stages are each built from two sub stages with internal registers set to pass data from the first
// half substage to the second substage. These register trigger on the "posEdge" of the first half. The 
// pipeline register trigger on the "posEdge" of the second half.

//
//
// Besides the pipeline stage units, the core has three more key building blocks. There are the instructions 
// cache, data cache and the memory interface unit for both caches. A cache miss will result in stalling 
// the pipeline. The I-Cache has priority over the D-cache requests.
//
// ??? quite some ways to go ... need control lines... 
// ??? basic question: do we decode all control lines in the FD stage or distribute it ?
// ??? L1 caches, TLBs, RegFile and memory interface are part of the core...
//
// ??? a core will connect to the a shared L2 cache and also the system bus.
// ??? initially we will have one core and no L2 cache.
//
// 
//------------------------------------------------------------------------------------------------------------
module CpuCore (   
    
    input logic clk,
    input logic rst 
                  
    );

    logic[WORD_LENGTH-1:0] wIaFdPstate0, wIaFdPstate1;
    logic[WORD_LENGTH-1:0] wFdMaPstate0, wFdMaPstate1;
    logic[WORD_LENGTH-1:0] wMaExPstate0, wMaExPstate1;

    RegisterFile_3R_2W GREG (   .rst( rst ),
                                .clk( clk )


                            );

    RegisterFile_1R_1W SREG (   .rst( rst ),
                                .clk( clk )


                            );

    InstrAdrStage I_STAGE   (   .rst( rst), 
                                .outPstate0( wIaFdPstate0 ), 
                                .outPstate1( wIaFdPstate1 ) 

                            );

    FetchDecodeStage FD_STAGE ( .rst( rst ), 
                                .clk( clk ),
                                .inPstate0( wIaFdPstate0 ), 
                                .inPstate1( wIaFdPstate1 )

                              );

    MemoryAccessStage MA_STAGE ( .rst( rst ), 
                                .clk( clk ),
                                .inPstate0( wFdMaPstate0 ), 
                                .inPstate1( wFdMaPstate1 )

                              );

    ExecuteStage EX_STAGE ( .rst( rst ), 
                            .clk( clk ),
                            .inPstate0( wMaExPstate0 ), 
                            .inPstate1( wMaExPstate1 )

                            );

    
    // ??? interfaces with caches and tlb ... 
    // ??? separate I and D modules for cache and TLB.

    // ??? IO Mem space access ?
    

endmodule