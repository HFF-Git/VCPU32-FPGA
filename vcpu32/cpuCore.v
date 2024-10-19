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
// overall pipeline core skeleton. The follwing figure is a simplified picture of the major modules.
//
//
//    +------------------+
//    :  +-------------+ :
//    :  :  +--------+ : :
//    :  :  :        : : :
//    :  :  :        v v v
//    :  :  :
//    :  :  :     nextInstrAdr 
//    :  :  :          :
//    :  :             :
//    :  :  :          v
//    :  :  :     PregInstrAdr [ P, O ]
//    :  :  :          :
//    :  :  :          :
//    :  :  :          v
//    :  :  +---  FetchDecodeStage ( FetchSubStage -> ... -> DecodeSubStage )
//    :  :             :
//    :  :             :              +--+--+------------------------------------------------------+    
//    :  :             :              :  :  :                                                      :
//    :  :             v              v  v  v                                                      :
//    :  :        PregFdMa [ P, O, I, A, B, X ]                                                    :
//    :  :             :                                                                           :
//    :  :             :                                                                           :
//    :  :             v                                                                           :
//    :  +------  OperandFetchStage ( ComputeAddressSubStage -> ... -> DataAccessSubStage )        :
//    :                :                                                                           :
//    :                :              +--+---------------------------------------------------------+
//    :                :              :  :                                                         :
//    :                v              v  v                                                         :
//    :           PregMaEx [ P, O, I, A, B, X, S ]                                                 :
//    :                :                                                                           :
//    :                :                                                                           :
//    :                v                                                                           :
//    +---------  ExecuteStage ( ComputeSubStage -> ... -> CommittSubStage )   --------------------+
// 
// 
// The pipeline register modules are simple collections of individual pipeline registers with no further 
// logic. The stages are the workhorses. The output of a pipeline register simply connects to the input of
// a stage and the output of a stage copnnects to the input of the pipeline register to follow. The values
// passed along have uppercase names used throughout the pipeline:
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
// The stages are each built from two sub stages with an internal register set to pass data from the first
// substage to the second substage. These register trigger on the "negEdge" of the master clock. The pipeline
// register trigger on the "posEdge" of the master clock. The clock is derived from the input clock. It is 
// half the speed of the input clock.
//
// Besides the pipeline stage units, the core has three more key building blocks. There are the instrucion 
// cache, data cache and the memory interface unit for both caches. A cache miss will result in stalling 
// the pipeline. The I-Cache has priority over the D-cache requests.
//
// The VCPU-32Core module is written in structural mode. We declare the building block instances and connect
// them with wires. The lower level buulding blocks, such as adders and multiplexers are mostly written in
// behavioral mode. Let the synthesis tool do its job.
//
//
// ??? quite some ways to go ... need control lines... 
// ??? basic question: do we decode all control lines in the FD stage or distribute it ?
// ??? L1 caches, TLBs, RegFile and memory interface are part of the core...
//
// ??? a core will connect to the a shared L2 cache and also the system bus.
// ??? initially we will habe one core and no L2 cache.
//
// ??? add a serial interface for the register dumps...
// 
//------------------------------------------------------------------------------------------------------------



module CpuCoreUnit ( 


    );

    // ??? stags and registers go here ... 
    // ??? should the pipeline registers be individual registers ? Naming ?

    // ??? interfaces with caches and tlb ... 
    // ??? separate I and D modules for cache and TLB.

    // ??? IO Memspace access ?
    

endmodule