//------------------------------------------------------------------------------------------------------------
//
//  VCPU-32
//
//------------------------------------------------------------------------------------------------------------
// 
// - contains a lot of modules in one file...
// - test benches are however separate...
//
//
//------------------------------------------------------------------------------------------------------------
//
// VCPU-32 - A 32bit CPU - Verilog
// Copyright (C) 2022 - 2024 Helmut Fieres
//
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU
// General Public License as published by the Free Software Foundation, either version 3 of the License,
// or any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even
// the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
// License for more details. You should have received a copy of the GNU General Public License along with
// this program.  If not, see <http://www.gnu.org/licenses/>.
//
//------------------------------------------------------------------------------------------------------------




//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------

///



// ?????? need to adopt the [31:0] how the whole Verilog world does approach :-(. 


// ??? put it into a cmake / vscode environment

// ???? rework for the 32-bit code ...... TO DO .....

///
//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------



// ??? over time we need to split into several files.... e.g.
// ??? VCPU-32Def.v
// ??? VCPU-32Util.v
// ??? VCPU-32Core.v
// ??? VCPU-32L1ICache.v
// ??? VCPU-32L1DCache.v
// ??? VCPU-32L2Cache.v
// ??? CPU2Mem.v
// ??? VCPU-32Io.v


//------------------------------------------------------------------------------------------------------------
// Global definitions.
//
//
//------------------------------------------------------------------------------------------------------------
`define BYTE_LENGTH           8
`define HALF_WORD_LENGTH      16
`define WORD_LENGTH           32
`define DBL_WORD_LENGTH       64
`define SEG_ID_WORD_LENGTH    16


//------------------------------------------------------------------------------------------------------------
// The reset vector. Upon reset, execution starts at this address in real mode.
//
//------------------------------------------------------------------------------------------------------------
`define RESET_IA_SEG          32'h0
`define RESET_IA_OFS          32'hF0000000


//------------------------------------------------------------------------------------------------------------
// ALU operation codes.
//
//
//------------------------------------------------------------------------------------------------------------
`define LOP_AND   3'b000
`define LOP_CAND  3'b001
`define LOP_XOR   3'b010
`define LOP_OR    3'b011
`define LOP_NAND  3'b100
`define LOP_COR   3'b101
`define LOP_XNOR  3'b110
`define LOP_NOR   3'b111


//------------------------------------------------------------------------------------------------------------
// Instruction Set OpCodes.
//
// ??? cross check ...
//------------------------------------------------------------------------------------------------------------
`define OP_BRK          6'h00       // break for debug
`define OP_LDIL         6'h01       // load immediate left
`define OP_ADDIL        6'h02       // add immediate left
`define OP_LDO          6'h03       // load offset
`define OP_LSID         6'h04       // load segment ID register
`define OP_EXTR         6'h05       // extract bit field of operand
`define OP_DEP          6'h06       // extract bit field into operand
`define OP_DSR          6'h07       // double register shift right
`define OP_SHLA         6'h08       // shift left and add
`define OP_CMR          6'h09       // conditional move register or value
`define OP_MR           6'h0a        // move to or from a segment or control register
`define OP_MST          6'h0b       // set or clear status bits

`define OP_ADD          6'h10       // target = target + operand ; options ovl trap, etc.
`define OP_ADC          6'h11       // target = target + operand + carry; options for ovl trap, etc.
`define OP_SUB          6'h12       // target = target - operand ;options for ovl trap, etc.
`define OP_SBC          6'h13       // target = target - operand - carry ;options for ovl trap, etc.
`define OP_AND          6'h14       // target = target & operand ; option to negate the result
`define OP_OR           6'h15       // target = target | operand ; option to negate the result
`define OP_XOR          6'h16       // target = target ^ operand ; option to negate the result
`define OP_CMP          6'h17       // subtract reg2 from reg1 and set condition codes
`define OP_CMPU         6'h18       // subtract reg2 from reg1 and set condition codes - unsigned

`define OP_B            6'h20       // branch
`define OP_GATE         6'h21       // gateway instruction
`define OP_BR           6'h22       // branch register
`define OP_BV           6'h23       // branch vectored
`define OP_BE           6'h24       // branch external
`define OP_BVE          6'h25       // branch vectored external
`define OP_CBR          6'h26       // compare and branch
`define OP_CBRU         6'h27       // compare and branch - unsigned

`define OP_LD           6'h30       // target = [ operand ]
`define OP_ST           6'h31       // [ operand ] = target
`define OP_LDA          6'h32       // load from absolute address
`define OP_STA          6'h33       // store to absolute adress
`define OP_LDR          6'h34       // load referenced
`define OP_STC          6'h35       // store conditional
    
`define OP_LDPA         6'h39       // load physical address
`define OP_PRB          6'h3a       // probe access
`define OP_ITLB         6'h3b       // insert into TLB
`define OP_PTLB         6'h3c       // remove from TLB
`define OP_PCA          6'h3d       // purge and flush cache
`define OP_DIAG         6'h3e       // diagnostics instruction, tbd.
`define OP_RFI          6'h3f       // return from interrupt


//------------------------------------------------------------------------------------------------------------
// The "VCPU32" module is the actual CPU. The top level module. Below we will have the cpu cores with the 
// the two L1 caches, the TLBs, perhaps a joint L2 cache and the system bus interfaces. In addition, we 
// will feature an intercace to the visible instruction register and teh syste switch register. Also, a JTAG
// interface would be nice. Well, quite a list....
//
//
// ??? need an idea of a memory.
// ??? need an idea of a system bus.
//
//
//------------------------------------------------------------------------------------------------------------
module VCPU32 ( 

   input wire  clk,
   input wire  rst,

   // ??? the system bus
   // ??? need an address output
   // ??? need a data input/putput
   // ??? need control lines for the bus



   // ??? need an output port for the insztruction register ( :-) I want it on a panel... )

   output   wire[0:`WORD_LENGTH-1]  outInstrReg, 
   
   // ??? need an input and ouput for the system switch register switches / display.
   
   input    wire[0:`WORD_LENGTH-1]  inSwtReg,
   output   wire[0:`WORD_LENGTH-1]  outSwtReg,

   // ??? need a serial interface for the scan chain.

   input    wire  sMode,
   input    wire  sIn,
   output   wire  sOut

   );

   CpuCoreUnit #( 

      . M_BLOCK_SIZE( 4 )

   ) cpuCore ( 

      .clk( clk ),
      .rst( rst ),
      .mReadOp( ),
      .mWriteOp( ),
      .mDataIn( ),  
      .mReady( ), 
      .mAdrCpuId( ),
      .mAdrBank( ),
      .mAdrOfs( ),
      .mDataOut( ));

endmodule
   

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
//    :  +------  MemoryAccessStage ( ComputeAddressSubStage -> ... -> DataAccessSubStage )        :
//    :                :                                                                           :
//    :                :              +--+---------------------------------------------------------+
//    :                :              :  :                                                         :
//    :                v              v  v                                                         :
//    :           PregMaEx [ P, O, I, A, B, X, S ]                                                 :
//    :                :                                                                           :
//    :                :                                                                           :
//    :                v                                                                           :
//    +---------  ExecuteStage ( ExecuteSubStage -> ... -> CommittSubStage )   --------------------+
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
module CpuCoreUnit #( 

   parameter M_BLOCK_SIZE = 4

   ) ( 

   input    wire                                clk,
   input    wire                                rst,
  
   output   wire                                mReadOp,
   output   wire                                mWriteOp,
   input    wire[0:M_BLOCK_SIZE*`WORD_LENGTH-1] mDataIn,  

   output   wire                                mReady, 
   output   wire[0:3]                           mAdrCpuId,
   output   wire[0:3]                           mAdrBank,
   output   wire[0:`WORD_LENGTH-1]              mAdrOfs,
   output   wire[0:M_BLOCK_SIZE*`WORD_LENGTH-1] mDataOut,

   input  wire                                  sClock,
   input  wire                                  sEnabled,
   input  wire                                  sIn,
   output wire                                  sOut 

   );

   // wires to connect the major modules...

   wire[0:`WORD_LENGTH-1] wIaReg1, wIaReg2, wIaReg3;
   wire[0:`WORD_LENGTH-1] wFdMaReg1, wFdMaReg2, wFdMaReg3, wFdMaReg4, wFdMaReg5, wFdMaReg6; 
   wire[0:`WORD_LENGTH-1] wExReg1, wExReg2, wExReg3, wExReg4, wExReg5, wExReg6, wExReg7; 
   
   wire[0:`WORD_LENGTH-1] wNi1, wNi2;
   wire[0:`WORD_LENGTH-1] wFsStage1;
   wire[0:`WORD_LENGTH-1] wDecStage1, wDecStage2, wDecStage3, wDecStage4, wDecStage5, wDecStage6, wDecStage7;
   wire[0:`WORD_LENGTH-1] wDaStage1, wDaStage2, wDaStage3, wDaStage4, wDaStage5, wDaStage6, wDaStage7; 
   wire[0:`WORD_LENGTH-1] wExStage1;
   wire[0:`WORD_LENGTH-1] wCsStage1, wCsStage2, wCsStage3, wCsStage4;

   // control wires...

   wire[0:1] nextIaSelect;

   assign nextIaSelect = 2'b00; // for testing, just increment the IA...

   // instances... 

   SelectNextInstrAdr nextInstrAdr ( 

      .clk( clk ), 
      .rst( rst ),
      .sel( nextIaSelect ),

      .inFdP( wDecStage1 ),
      .inFdO( wDecStage2 ),
      .inFdOfs( wDecStage7 ),
      .inMaO( wDaStage7 ),
      .inExP( wCsStage1 ),
      .inExO( wCsStage2 ),

      .outP( wNi1 ), 
      .outO( wNi2 ));

   // ??? what do we do about the status register ? will that also be just passed along ?

   PregInstrAdr pregInstrAdr ( 

      .clk( clk ), 
      .rst( rst ),

      .inP( wNi1 ), 
      .inO( wNi2 ),
     

      .outP( wIaReg1 ), 
      .outO( wIaReg2 ),

      .sClock( sClock ),
      .sEnable( sEnable ),
      .sIn( sIn ), 
      .sOut( sOut )
   );

   FetchSubStage fSubStage ( 

      .clk( clk ), 
      .rst( rst ), 

      .inP( wIaReg1 ),
      .inO( wIaReg2 ),

      .outI( wFsStage1 )
      );

   DecodeSubStage dSubStage ( 

      .clk( clk ), 
      .rst( rst ), 

      .inP( wIaReg1 ),
      .inO( wIaReg2 ),
      .inI( wFsStage1 ),
      .inBP( wCsStage3 ),

      .outP( wDecStage1 ),
      .outO( wDecStage2 ),
      .outI( wDecStage3 ), 
      .outA( wDecStage4 ), 
      .outB( wDecStage5 ), 
      .outX( wDecStage6 ),
      .outIaOfs( wDecStage7 )
   );

   PregFdMa pregFdMa ( 

      .clk( clk ), 
      .rst( rst ), 
     
      .inP( wIaReg1 ), 
      .inO( wIaReg2 ),
      .inI( wDecStage3 ),
      .inA( wDecStage4 ),
      .inB( wDecStage5 ),
      .inX( wDecStage6 ),
     
      .outP( wFdMaReg1 ), 
      .outO( wFdMaReg2 ), 
      .outI( wFdMaReg3 ),
      .outA( wFdMaReg4 ), 
      .outB( wFdMaReg5 ), 
      .outX( wFdMaReg6 ),
    
      .sClock( sClock ),
      .sEnable( sEnable ),
      .sIn( sIn ), 
      .sOut( sOut )
   );

   ComputeAddressSubStage caSubStage ( 

      .clk( clk ), 
      .rst( rst ),
      
      .inP( wFdMaReg1 ), 
      .inO( wFdMaReg2 ),
      .inI( wFdMaReg3 ),
      .inA( wFdMaReg4 ),
      .inB( wFdMaReg5 ),
      .inX( wFdMaReg6 )
      
      // ??? ouput to data access stage...

      );

   DataAccessSubStage daSubStage ( 

      .clk( clk ), 
      .rst( rst ),

      // ??? input from address computation substage

      .inBP( wCsStage4 ),

      .outI( wDaStage3 ), 
      .outA( wDaStage4 ), 
      .outB( wDaStage5 ), 
      .outX( wDaStage6 ),
      .outS( wDaStage7 ),
      .outDaOfs( wDecStage7 )
   );

   PregMaEx pregMaEx ( 

      .clk( clk ), 
      .rst( rst ), 
   
      .inP( wFdMaReg1 ), 
      .inO( wFdMaReg2 ),
      .inI( wDaStage3 ),
      .inA( wDaStage4 ),
      .inB( wDaStage5 ),
      .inX( wDaStage6 ),
      .inS( wDaStage7 ),
     
      .outP( wExReg1 ), 
      .outO( wExReg2 ), 
      .outI( wExReg3 ),
      .outA( wExReg4 ), 
      .outB( wExReg5 ), 
      .outX( wExReg6 ),
      .outS( wExReg7 ),
     
      .sClock( sClock ),
      .sEnable( sEnable ),
      .sIn( sIn ), 
      .sOut( sOut )
   );

   ExecuteSubStage exStage ( 

      .clk( clk ), 
      .rst( rst ), 
      
      .inP( wExReg1 ), 
      .inO( wExReg2 ),
      .inI( wExReg3 ),
      .inA( wExReg4 ),
      .inB( wExReg5 ),
      .inX( wExReg6 ),
      .inS( wExReg7 ),

      .outR( wExStage1 )
   );

   CommitSubStage csStage ( 

      .clk( clk ), 
      .rst( rst ), 
      
      .inR( wExStage1 ),

      .outP( wCsStage1 ),
      .outO( wCsStage2 ),
      .outST( wCsStage3 ),
      .outR( wCsStage4 )
   );

  
   // ??? the caches and TLBs are local to the substage where the are used. Nevertheless, these modules need
   // access to memory or L2 cache... how to model this ?
   // ??? memory interface stays local to this module ...

   ItlbUnit iTlb ( 
      
      .clk( clk ), 
      .rst( rst )

      );

   DtlbUnit dTlb ( 
      
      .clk( clk ), 
      .rst( rst )

      );

   ICacheUnit iCache ( 

      .clk( clk ), 
      .rst( rst )

      );

   DCacheUnit dCache ( 

      .clk( clk ), 
      .rst( rst )

      );

   MemoryInterface MEM ( 

   .clk( clk ), 
   .rst( rst ) 

   );

   always @( negedge rst ) begin

      // ??? what to perhaps do on a reset ?
      // ??? set the IA to 0:F0000000

   end

endmodule


//------------------------------------------------------------------------------------------------------------
// Pipeline register: instruction address. An instruction address consists of the segment and the offset. It
// is commonly also called the program counter. There is also the status word which together with the current
// instruction address make up the prgram state. Internally we have instances for each of the register parts.
// The registers a scan registers, which link serially for diagnostics and debugging.
//
//------------------------------------------------------------------------------------------------------------
module PregInstrAdr ( 

   input  wire                   clk,
   input  wire                   rst,
   
   input  wire[0:`WORD_LENGTH-1] inP,
   input  wire[0:`WORD_LENGTH-1] inO,
   input  wire[0:`WORD_LENGTH-1] inST,
 
   output wire[0:`WORD_LENGTH-1] outP,
   output wire[0:`WORD_LENGTH-1] outO, 
   output wire[0:`WORD_LENGTH-1] outST,

   input  wire                   sClock,
   input  wire                   sEnable,
   input  wire                   sIn,
   output wire                   sOut

   );

   wire w1, w2;

   ScanRegUnit iaSeg (  .clk( clk ), 
                        .rst( rst ), 
                       
                        .d( inP ),
                        .q( outP ), 

                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( sIn ), 
                        .sOut( w1 )
                     );

   ScanRegUnit iaOfs (  .clk( clk ), 
                        .rst( rst ), 
                        
                        .d( inO ),
                        .q( outO ),

                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( w1 ), 
                        .sOut( w2 )
                     );

   ScanRegUnit status ( .clk( clk ), 
                        .rst( rst ), 
                        
                        .d( inST ), 
                        .q( outST ),

                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( w2 ), 
                        .sOut( sOut )
                     );
   
endmodule

//------------------------------------------------------------------------------------------------------------
// Pipeline register INSTR. The fetch decode stage contains two major parts. The fetch sub-stage will fetch
// the next instruction from the current instruction address. The instruction will be teh inoput to the 
// decode sub-stage.
// 
//------------------------------------------------------------------------------------------------------------
module PregInstr (

   input  wire                   clk,
   input  wire                   rst,
   input  wire[0:`WORD_LENGTH-1] inInstr,
   
   output wire[0:`WORD_LENGTH-1] outInstr,

   input  wire                   sClock,
   input  wire                   sEnable,
   input  wire                   sIn,
   output wire                   sOut

   );

   ScanRegUnit iReg (   .clk( clk ), 
                        .rst( rst ), 

                        .d( inInstr ), 
                        .q( outInstr ),

                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( sIn ), 
                        .sOut( sOut )
                     );

endmodule

//------------------------------------------------------------------------------------------------------------
// Pipeline register: FD to MA Stage. The FD-MA pipeline register is between the fetch-decode and the memory
// access pipeline stage. Internally we have instances for each of the register parts.
// 
//------------------------------------------------------------------------------------------------------------
module PregFdMa ( 

   input  wire                   clk,
   input  wire                   rst,

   input  wire[0:`WORD_LENGTH-1] inP,
   input  wire[0:`WORD_LENGTH-1] inO,
   input  wire[0:`WORD_LENGTH-1] inI,
   input  wire[0:`WORD_LENGTH-1] inA,
   input  wire[0:`WORD_LENGTH-1] inB,
   input  wire[0:`WORD_LENGTH-1] inX,

   output wire[0:`WORD_LENGTH-1] outP,
   output wire[0:`WORD_LENGTH-1] outO,
   output wire[0:`WORD_LENGTH-1] outI,
   output wire[0:`WORD_LENGTH-1] outA,
   output wire[0:`WORD_LENGTH-1] outB,
   output wire[0:`WORD_LENGTH-1] outX,

   input  wire                   sClock,
   input  wire                   sEnable,
   input  wire                   sIn,
   output wire                   sOut

   );

   wire w1, w2, w3, w4, w5;

   ScanRegUnit iaSeg (  .clk( clk ), 
                        .rst( rst ), 
                        
                        .d( inP ), 
                        .q( outP ), 
                       
                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( sIn ), 
                        .sOut( w1 )
                     );

   ScanRegUnit iaOfs (  .clk( clk ), 
                        .rst( rst ), 
                        
                        .d( inO ), 
                        .q( outO ), 

                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( w1 ), 
                        .sOut( w2 )
                     );

   ScanRegUnit instr (  .clk( clk ), 
                        .rst( rst ), 
                        
                        .d( inI ), 
                        .q( outI ), 

                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( sw2 ), 
                        .sOut( w3 )
                     );

   ScanRegUnit valA  (  .clk( clk ), 
                        .rst( rst ), 
         
                        .d( inA ), 
                        .q( outA ), 

                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( w3 ), 
                        .sOut( w4 )
                     );

   ScanRegUnit valB  (  .clk( clk ), 
                        .rst( rst ), 
                        
                        .d( inB ), 
                        .q( outB ), 

                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( w4 ), 
                        .sOut( w5 )
                     );

   ScanRegUnit valX  (  .clk( clk ), 
                        .rst( rst ), 
                        
                        .d( inX ), 
                        .q( outX ), 

                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( w5 ), 
                        .sOut( sOut )
                     );

endmodule


//------------------------------------------------------------------------------------------------------------
// Pipeline register: MA to EX Stage. The MA-EX pipeline register is between the memory access and the execute
// stage. Internally we have instances for each of the register parts.
//
//------------------------------------------------------------------------------------------------------------
module PregMaEx ( 

   input  wire                   clk,
   input  wire                   rst,
  
   input  wire[0:`WORD_LENGTH-1] inP, // in_PregMaEx_P PregMaEx_P_in
   input  wire[0:`WORD_LENGTH-1] inO,
   input  wire[0:`WORD_LENGTH-1] inI,
   input  wire[0:`WORD_LENGTH-1] inA,
   input  wire[0:`WORD_LENGTH-1] inB,
   input  wire[0:`WORD_LENGTH-1] inX,
   input  wire[0:`WORD_LENGTH-1] inS,

   output wire[0:`WORD_LENGTH-1] outP, // regMaEx_P_out
   output wire[0:`WORD_LENGTH-1] outO,
   output wire[0:`WORD_LENGTH-1] outI,
   output wire[0:`WORD_LENGTH-1] outA,
   output wire[0:`WORD_LENGTH-1] outB,
   output wire[0:`WORD_LENGTH-1] outX, 
   output wire[0:`WORD_LENGTH-1] outS,
   
   input  wire                   sClock,
   input  wire                   sEnable,
   input  wire                   sIn,
   output wire                   sOut

   );

   wire w1, w2, w3, w4, w5, w6;

   ScanRegUnit iaSeg (  .clk( clk ), 
                        .rst( rst ), 
                        
                        .d( inP ), 
                        .q( outP ), 

                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( sIn ), 
                        .sOut( w1 )
                     );

   ScanRegUnit iaOfs (  .clk( clk ), 
                        .rst( rst ), 
                        
                        .d( inO ),              
                        .q( outO ), 

                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( w1 ), 
                        .sOut( w2 )
                     );

   ScanRegUnit instr (  .clk( clk ), 
                        .rst( rst ), 
   
                        .d( inI ), 
                        .q( outI ), 
    
                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( w2 ),  
                        .sOut( w3 )
                     );
   
   ScanRegUnit valA  (  .clk( clk ), 
                        .rst( rst ), 
   
                        .d( inA ),
                        .q( outA ), 

                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( w3 ),  
                        .sOut( w4 )
                     );

   ScanRegUnit valB  (  .clk( clk ), 
                        .rst( rst ), 
   
                        .d( inB ), 
                        .q( outB ), 
                        
                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( w4 ),
                        .sOut( w5 )
      );

   ScanRegUnit valX  (  .clk( clk ),
                        .rst( rst ), 
   
                        .d( inX ),
                        .q( outX ),

                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( w5 ), 
                        .sOut( w6 )
      );
   
   ScanRegUnit valS  (  .clk( clk ), 
                        .rst( rst ), 
   
                        .d( inS ),  
                        .q( outS ), 

                        .sClock( sClock ),
                        .sEnable( sEnable ),
                        .sIn( w6 ),  
                        .sOut( sOut ));

endmodule


//------------------------------------------------------------------------------------------------------------
// Before the next instruction is fetched, the address needs to be selected. It could be the current address
// incremented by four, a branch target or an excepetion handler instruction. Depending on the instruction, 
// the pipeline stages produce the next instruction address value. The FD stage is will directly compute the
// next instruction offset and in case of a conditional branch instruction a new instruction offset. The MA 
// stage  will produce the next instruction offset for unconditional branch instrucutions. FD and MA stage do
//  not change the instruction segment. The EX stage will potentially set a new segment and offset.
//
//    0 - instruction offset "inFdO" is incremented by "inFdOfs". "inFdP" selected.
//    1 - instruction offset "inMaO" and "inFdP" selected.
//    2 - instruction offset "inExO" and "inExP" selected.
//    3 - RESET vector.  
//
// Note that the setting of a new instruction address will perhaps also require to flush the pipeline. This
// is not handled in this module. All it does is to compute the next instruction address from the inputs of
// the pipeline stages.
//
//------------------------------------------------------------------------------------------------------------
module SelectNextInstrAdr( 

   input    wire                    clk,
   input    wire                    rst,
   input    wire[0:1]               sel,

   input    wire[0:`WORD_LENGTH-1]  inFdP,
   input    wire[0:`WORD_LENGTH-1]  inFdO,
   input    wire[0:`WORD_LENGTH-1]  inFdOfs,

   input    wire[0:`WORD_LENGTH-1]  inMaO,

   input    wire[0:`WORD_LENGTH-1]  inExP,
   input    wire[0:`WORD_LENGTH-1]  inExO,

   output   wire[0:`WORD_LENGTH-1]  outP,
   output   wire[0:`WORD_LENGTH-1]  outO 

   );

   wire[0:`WORD_LENGTH-1] tmpOfs;

   reg [0:1] tmpSel;

   AdderUnit   U0 (  .a( inFdO ), .b( inFdOfs ), .inC( 1'b0 ), .s( tmpOfs )); 

   Mux_4_1     U1 (  .a0( inFdP ), 
                     .a1( inExP ), 
                     .a2( `WORD_LENGTH'h0 ),
                     .a3( `RESET_IA_SEG ),
                     .sel( tmpSel ), 
                     .enb( 1'b1 ), 
                     .y( outP ));

   Mux_4_1     U2 (  .a0( { 2'b00, tmpOfs[2:`WORD_LENGTH-1] } ), 
                     .a1( inMaO ), 
                     .a2( inExO ), 
                     .a3( `RESET_IA_OFS ), 
                     .sel( tmpSel ), 
                     .enb( 1'b1 ), 
                     .y( outO ));


   always @( posedge clk or negedge rst ) begin

      if ( ~ rst )   tmpSel = 2'b11;
      else           tmpSel = sel;
   
   end

endmodule

//------------------------------------------------------------------------------------------------------------
// "FetchSubStage" is the first part of the fetch and decode stage. 
//
// ??? do we have another regfile unit write for two regfile writes ?
//------------------------------------------------------------------------------------------------------------
module FetchSubStage( 
   
   input  wire                   clk,
   input  wire                   rst, 
   
   input  wire[0:`WORD_LENGTH-1] inP,
   input  wire[0:`WORD_LENGTH-1] inO,

   output wire[0:`WORD_LENGTH-1] outI

   // MEM interface...
   
   );

   assign outI = 32'h77; // for a quick test ...

   
endmodule

//------------------------------------------------------------------------------------------------------------
// "DecodeSubStage" is the second part of the fetch and decode stage. The mai task is to analyze the 
// instruction and to read the data from the register files, if required. The decode unit also produce the
// immediate value encoded in the instruction if required. 
//
// In general there are two options for the instruction decode. We could do all the decoding work in this 
// module and pass on the derived control codes to the stages to follow. As an alternative, each substage 
// could  do its own decoding if necessary. The latter would however imply that each stage needs to also
// decode each possible instruction opcode. 
//
//
// ??? triggered by negedge of clk, i.e. second half of the pipeline clock.
// ??? do we need to pass also the fast clock for regfile write operation ?
// ??? what is a good strategy to do the opCode analysis ? all in one huge case statement ? grouping ?
// ??? the cases are actually control lines to select the unit that has the data....
// 
// ??? we also need to read the general register file
// ??? regfile needs to become a version with a serial scan option...
//------------------------------------------------------------------------------------------------------------
module DecodeSubStage( 
   
   input  wire                   clk,
   input  wire                   rst, 
   
   input  wire[0:`WORD_LENGTH-1] inP,
   input  wire[0:`WORD_LENGTH-1] inO,
   input  wire[0:`WORD_LENGTH-1] inI,
   input  wire[0:`WORD_LENGTH-1] inBP,
   
   output wire[0:`WORD_LENGTH-1] outP,
   output wire[0:`WORD_LENGTH-1] outO,
   output wire[0:`WORD_LENGTH-1] outI,
   output wire[0:`WORD_LENGTH-1] outA,
   output wire[0:`WORD_LENGTH-1] outB,
   output wire[0:`WORD_LENGTH-1] outX,
   output wire[0:`WORD_LENGTH-1] outIaOfs
   
   );

   reg                     aMuxsel, rMuxsel, rfWrite;
   reg[0:1]                bMuxsel, xMuxsel;

   reg[0:`WORD_LENGTH-1]   valA, valB, valX;

   wire[0:5]               opCode;
   wire[0:2]               regIdR, regIdA, regIdB, regWriteAdr, regReadAdrA, regReadAdrB;

   wire[0:`WORD_LENGTH-1]  immVal;

   Mux_2_1                 #( .WIDTH( 3 )) muxR ( .a0( regIdA ), .a1( regIdR ), .sel( rMuxsel ), .y( ));
   Mux_2_1                 muxA  ( .a0( inBP ), .a1( ), .sel( aMuxsel ), .y( outA ));
   Mux_4_1                 muxB  ( .a0( inBP ), .a1( ), .a2( inO ), .a3( ), .sel( bMuxsel ), .y( outB ));
   Mux_4_1                 muxX  ( .a0( inBP ), .a1( ), .a2( inO ), .a3( ), .sel( xMuxsel ), .y( outX ));

   ImmGenUnit              immU  ( .instr( inI ), .y( immVal ));

   ScanRegFileUnit         rFile ( .clk( clk ), .rst( rst ), .write( rfWrite ), .wrAddr( regWriteAdr ),
                                   .rdAddrA( regReadAdrA ), .rdAddrB( regReadAdrB ), 
                                   .wrData( ), .rdDataA( ), .rdDataB( ));

   assign opCode     = inI[0:5];
   assign regIdR     = inI[6:9];
   assign regIdA     = inI[24:27];
   assign regIdB     = inI[28:31];

   assign outA       = valA;
   assign outB       = valB;
   assign outX       = valX;
   assign outI       = inI;

   assign outP       = inP;
   assign outO       = inO;
   assign outIaOfs   = 4;

   always @( negedge clk or negedge rst ) begin 
      
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


//------------------------------------------------------------------------------------------------------------
// Data address calculation sub stage. It is the frst part of the memory access stage for instructions that 
// access the L1 data cache or calculate a branch target offsets. We also use this sub stage and its resources
// to do branch adddress computations, etc.
// 
//
// ??? input .... what is required ?
// ??? fix scan input
//------------------------------------------------------------------------------------------------------------
module ComputeAddressSubStage ( 

   input  wire                   clk,
   input  wire                   rst,

   input  wire[0:`WORD_LENGTH-1] inP,
   input  wire[0:`WORD_LENGTH-1] inO,
   input  wire[0:`WORD_LENGTH-1] inI,
   input  wire[0:`WORD_LENGTH-1] inA,
   input  wire[0:`WORD_LENGTH-1] inB,
   input  wire[0:`WORD_LENGTH-1] inX
   
   // ??? output ?
   
   );

   AdderUnit         U0 ( .a( ), .b( ), .inC( 1'b0 ), .s( )); 

   ScanRegFileUnit   U1 (  .clk( clk ), 
                           .rst( rst ), 
                           .write( ), 
                           .wrAddr( ),
                           .rdAddrA( ), 
                           .rdAddrB( ), 
                           .wrData( ), 
                           .rdDataA( ), 
                           .rdDataB( ),
                           
                           .sClock( ),
                           .sEnable( ),
                           .sIn( ),
                           .sOut( )
                        );

endmodule

//------------------------------------------------------------------------------------------------------------
// Data access sub stage. 
//
//
// ??? input .... what is required ?
// ??? what output ?
//------------------------------------------------------------------------------------------------------------
module DataAccessSubStage ( 

   input  wire                   clk,
   input  wire                   rst,

   input  wire[0:`WORD_LENGTH-1] inP,
   input  wire[0:`WORD_LENGTH-1] inO,
   input  wire[0:`WORD_LENGTH-1] inI,
   input  wire[0:`WORD_LENGTH-1] inA,
   input  wire[0:`WORD_LENGTH-1] inB,
   input  wire[0:`WORD_LENGTH-1] inX,
   input  wire[0:`WORD_LENGTH-1] inBP,

   output wire[0:`WORD_LENGTH-1] outI,
   output wire[0:`WORD_LENGTH-1] outA,
   output wire[0:`WORD_LENGTH-1] outB,
   output wire[0:`WORD_LENGTH-1] outX,
   output wire[0:`WORD_LENGTH-1] outS,
   output wire[0:`WORD_LENGTH-1] outDaOfs


   // D-cache interface

   // D-TLB interface

   );

   // ??? need the D-cache unit interface
   // ??? need the I-TLB interface
   // ??? how to stall the pipeline ?
   // ??? how to communicate the "DTLB miss" ?

   Mux_2_1 U0 ( .a0( ), .a1( ), .sel( ), .y( outA ));
   Mux_8_1 U1 ( .a0( ), .a1( ), .a2( ), .a3( ), .a4( ), .sel( ), .y( outB ));
   Mux_4_1 U2 ( .a0( ), .a1( ), .a2( ), .a3( ), .sel( ), .y( outX ));
   Mux_4_1 U3 ( .a0( ), .a1( ), .a2( ), .a3( ), .sel( ), .y( outS ));

endmodule

//------------------------------------------------------------------------------------------------------------
// Execute sub stage logic.
//
// ??? include the arithmetic unit, the logic unit, the shift/merge unit
// ??? work from instruction or already decoded operations ? 
//
// The execte substage is the place where we deal with overflows.
//
// addition signed
// (( ~ a[0] ) & ( ~ b[0] ) & ( s[0] )) | (( a[0] ) & ( b[0] ) & ( ~ s[0] )) 
//
// subtraction signed
// (( ~ a[0] ) & ( b[0] ) & ( s[0] )) | (( a[0] ) & ( ~ b[0] ) & ( ~ s[0] )) 
//
//
// ??? use logicUnit and Adder ?
//------------------------------------------------------------------------------------------------------------
module ExecuteSubStage ( 

   input  wire                   clk,
   input  wire                   rst,

   input  wire[0:`WORD_LENGTH-1] inP,
   input  wire[0:`WORD_LENGTH-1] inO,
   input  wire[0:`WORD_LENGTH-1] inI,
   input  wire[0:`WORD_LENGTH-1] inA,
   input  wire[0:`WORD_LENGTH-1] inB,
   input  wire[0:`WORD_LENGTH-1] inX,
   input  wire[0:`WORD_LENGTH-1] inS,

   output wire[0:`WORD_LENGTH-1] outI,
   output wire[0:`WORD_LENGTH-1] outR

   );

   AluUnit        U0    ( .a( ), .b( ), .ac( ), .r( ), .c( ), .n( ), .z( ), .err( ));
   ShiftMergeUnit U1    ( .a( ), .b( ), .instr( ), .r( ), .err( ));
   Mux_2_1        U2    ( .a0( ), .a1( ), .sel( ), .y( ));

   // assign tOvl = tCout ^ tmpA[0] ^ tmpB[0] ^ tAdd[0]; 

   assign outR = 99; // for a quick test ...

endmodule


//------------------------------------------------------------------------------------------------------------
// Commit sub stage logic. The stage is the secod part of the execute stage. The first siubstage computed any
// results. This sub stage will commit the results, i.e. update the states of registers and so on.
//
// 
// ??? also set any segment or control register value ?
// ??? what do we do best about writing two values for LDw.M, etc. type instructions ?
//------------------------------------------------------------------------------------------------------------
module CommitSubStage ( 

   input  wire                   clk,
   input  wire                   rst,

   input  wire[0:`WORD_LENGTH-1] inR,

   output wire[0:`WORD_LENGTH-1] outP,
   output wire[0:`WORD_LENGTH-1] outO,
   output wire[0:`WORD_LENGTH-1] outST,
   output wire[0:`WORD_LENGTH-1] outR

   );

   
    // ??? have ouputs to feed into the registers files, nextIA logic, etc.
    // ??? instantiate an ALU and Shift-Merge Unit


endmodule


//------------------------------------------------------------------------------------------------------------
// Instruction TLB.
//
// ??? to decide: a small fully associative TLB, in combination with a larger joint TLB for both instruction
// and data, or a single 2-way associative TLB.
//------------------------------------------------------------------------------------------------------------
module ItlbUnit #(

   parameter   T_ENTRIES         = 512,
               TLB_TAG_WIDTH     = 20
   
   ) ( 

   input    wire                       clk, 
   input    wire                       rst,
   input    wire [0:`WORD_LENGTH-1]    inSeg,
   input    wire [0:`WORD_LENGTH-1]    inOfs,

   output   wire                       found,
   output   wire [0:`WORD_LENGTH-1]    outAdr

   );

   always @( posedge clk or negedge rst ) begin 

      if ( ~ rst ) begin

      end else begin

      end

   end

endmodule


//------------------------------------------------------------------------------------------------------------
// Data TLB.
//
// ??? to decide a combo with I-TLB ?
//------------------------------------------------------------------------------------------------------------
module DtlbUnit #(

   parameter   T_ENTRIES         = 512,
               TLB_TAG_WIDTH     = 20
   
   ) ( 

   input    wire     clk, 
   input    wire     rst

   );

   always @( posedge clk or negedge rst ) begin 

      if ( ~ rst ) begin

      end else begin

      end

   end

endmodule


//------------------------------------------------------------------------------------------------------------
// L1 instruction cache. The CPU features two L1 caches, instruction and data. The instruction cache is a 
// two-way set associative array using a LRU scheme for replacement. The cache is a write back type cache 
// with a default cache line size of four machine words.
//
// The unit has a set of arrays. There are two sets with bit arrays for the valid, dirty and lru bits and 
// cache tag and data. The data array is holds the actual cache line data with a word length of C_BLOCK_SIZE.
// Depending on the block size and the number of cache line entries, the tag has a number of bits.
//
// The cache controller is designed to return the data in case of a HIT within the same cycle. If the data
// is not in the cache, the cache line needs to be allocated. If we have an invalid entry in one of the sets, 
// just use it. If not, one of the cache line entry needs ot be allocated. The LRU bit indicates which one
// we will select. 
//
// The cache also contains the logic to compare the tag with the TLB tag data. We cannot perform an update
// on cache data before we know that it is truly the physical block that matches the TLB and cache tag.
// When address translation is turned off, the "tlbTag" paramater shild just contains the physical address
// that is to be accessed. CPU-ID and memory bank are by definition zero in this case.
//
// ??? should we rather define a two and four way cache to be used as see fit ?
// ??? do we need to support a write operation for an instruction cache ?
// ??? need a kind of protocol when memory is ready ...
// ??? how to do statistics ? could do a ton of counters, but how expensive is this ?
// ??? what would we do with a machine that has word and byte values ?
//------------------------------------------------------------------------------------------------------------
module ICacheUnit #(

   parameter   C_ENTRIES         = 1024,
               TLB_TAG_WIDTH     = 20
   
   ) ( 

   input    wire                                clk, 
   input    wire                                rst,
   input    wire[0:`WORD_LENGTH-1]              vSeg,
   input    wire[0:`WORD_LENGTH-1]              vOfs,
   input    wire[0:TLB_TAG_WIDTH-1]             tlbTag,
   input    wire[0:`WORD_LENGTH-1]              dataInCpu,
   input    wire                                cReadOp,
   input    wire                                cWriteOp,
   input    wire                                cFlushOp,
   input    wire                                cPurgeOp,

   input    wire[0:C_BLOCK_SIZE*`WORD_LENGTH-1] dataInMem,                             

   output   wire                                stallCpu, 
   output   wire[0:`WORD_LENGTH-1]              dataOutCpu,
   output   wire                                mReadOp,
   output   wire                                mWriteOp,
   output   wire[0:3]                           mAdrCpuId,
   output   wire[0:3]                           mAdrBank,
   output   wire[0:`WORD_LENGTH-1]              mAdrOfs,
   output   wire[0:C_BLOCK_SIZE*`WORD_LENGTH-1] dataOutMem         
   
   );

   //---------------------------------------------------------------------------------------------------------
   // The state machine states. A cache can be in the IDLE stage, ALLOCATEing a cache block or WRITE_BACK the
   // cache block.
   //
   //---------------------------------------------------------------------------------------------------------
   localparam  C_IDLE            = 3'b001;
   localparam  C_ALLOCATE        = 3'b010;
   localparam  C_WRITE_BACK      = 3'b100;
   
   //---------------------------------------------------------------------------------------------------------
   // Cache tag and indexing declarations. The virtual address offset is split into the the offset into the 
   // block, the block index and the tag portion. Note that we also store the CPU Id and the memory bank
   // offset in the tag. As we return this data, the pipeline stage will use this information to check with 
   // the TLB data, whether we have a real match. The cache is however not concerned with these two fields.
   //
   //---------------------------------------------------------------------------------------------------------
   `define     C_BLOCK_INDX      12:29  // muts match the cache size..
   `define     C_BLOCK_OFS       30:31

   wire[`C_BLOCK_INDX]           wBlockIndex;
   wire[`C_BLOCK_OFS]            wBlockOfs;

   assign wBlockIndex   = vOfs[`C_BLOCK_INDX];
   assign wBlockOfs     = vOfs[`C_BLOCK_OFS];

   //---------------------------------------------------------------------------------------------------------
   //
   // ??? need field declarations for the tag field. What will be compared, etc. ?
   // ??? TAG is: 4-bit CPU-ID, 4-bit Memory Bank, 32 - blockIndexBits - blockBits;  
   //---------------------------------------------------------------------------------------------------------
   localparam  C_TAG_WIDTH = TLB_TAG_WIDTH;

   //---------------------------------------------------------------------------------------------------------
   // A block is a set of four machine words. The declarations allow to access the correct word in the block.
   //
   //---------------------------------------------------------------------------------------------------------
   localparam                    C_BLOCK_SIZE      = 4;

   `define     C_WORD_1          0:31
   `define     C_WORD_2          32:63
   `define     C_WORD_3          64:95
   `define     C_WORD_4          95:127

   //---------------------------------------------------------------------------------------------------------
   // The cache data structures. There are two sets each of which cointain an array for the valid bit, the
   // dirty bit, the LRU bit, the tag and data array.
   //
   //---------------------------------------------------------------------------------------------------------
   reg                                 validBitArray1[0:C_ENTRIES-1];
   reg                                 dirtyBitArray1[0:C_ENTRIES-1];
   reg                                 lruBitArray1[0:C_ENTRIES-1];
   reg[0:C_TAG_WIDTH-1]                tagArray1[0:C_ENTRIES-1];
   reg[0:C_BLOCK_SIZE*`WORD_LENGTH]    dataArray1[0:C_ENTRIES-1];

   reg                                 validBitArray2[0:C_ENTRIES-1];
   reg                                 dirtyBitArray2[0:C_ENTRIES-1];
   reg                                 lruBitArray2[0:C_ENTRIES-1];
   reg[0:C_TAG_WIDTH-1]                tagArray2[0:C_ENTRIES-1];
   reg[0:C_BLOCK_SIZE*`WORD_LENGTH]    dataArray2[0:C_ENTRIES-1];


   //---------------------------------------------------------------------------------------------------------
   //
   //
   //---------------------------------------------------------------------------------------------------------
   reg[0:`WORD_LENGTH-1]               dataOutVal;
   reg[0:4]                            cState = C_IDLE;

   integer i;
   
   assign dataOutCpu    = dataOutVal;
   

   //---------------------------------------------------------------------------------------------------------
   // The cache controller state machine. On a reset signal, we clear the valid, dirty and lru data. No need
   // to also clear the tag and data array. If an operation requested, the block indexed is checked for being
   // valid with the matching tag. 
   //
   // 
   //
   //
   //---------------------------------------------------------------------------------------------------------
   always @( posedge clk or negedge rst ) begin 

      if ( ~ rst ) begin
         
         for ( i = 0; i < C_ENTRIES; i = i + 1 ) begin
      
            validBitArray1[ i ]  = 0;
            dirtyBitArray1[ i ]  = 0;
            lruBitArray1[ i ]    = 0;

            validBitArray2[ i ]  = 0;
            dirtyBitArray2[ i ]  = 0;
            lruBitArray2[ i ]    = 0;
     
         end

      end else begin

         case ( 1'b1 ) 

            cState[C_IDLE]: begin

               if (( ~ cReadOp ) && ( ~ cWriteOp ) && ( ~ cFlushOp ) && ( ~ cPurgeOp )) begin
               
                  cState <= C_IDLE;

               end else if ( validBitArray1[ wBlockIndex ] && matchTag( tlbTag, tagArray1[ wBlockIndex ])) begin

                  if ( cReadOp ) begin

                        dataOutVal =   ( wBlockOfs == 2'b00 ) ? dataArray1[ wBlockIndex ] [`C_WORD_1] :
                                       ( wBlockOfs == 2'b01 ) ? dataArray1[ wBlockIndex ] [`C_WORD_2] :
                                       ( wBlockOfs == 2'b10 ) ? dataArray1[ wBlockIndex ] [`C_WORD_3] : 
                                                                dataArray1[ wBlockIndex ] [`C_WORD_4];       

                  end else if ( cWriteOp ) begin

                     dirtyBitArray1[wBlockIndex] <= 1'b1;

                     if       (  wBlockOfs == 2'b00 ) dataArray1[ wBlockIndex ] [`C_WORD_1] <= dataInCpu;
                     else if  (  wBlockOfs == 2'b01 ) dataArray1[ wBlockIndex ] [`C_WORD_2] <= dataInCpu;
                     else if  (  wBlockOfs == 2'b10 ) dataArray1[ wBlockIndex ] [`C_WORD_3] <= dataInCpu;
                     else                             dataArray1[ wBlockIndex ] [`C_WORD_4] <= dataInCpu;

                  end else if ( cFlushOp ) begin
                     
                     cState = C_WRITE_BACK;

                  end else if ( cPurgeOp ) begin

                     validBitArray1[ wBlockIndex ] <= 0;

                  end

                  lruBitArray1[ wBlockIndex ] <= 0;
                  lruBitArray2[ wBlockIndex ] <= 1;
                  
               end else if ( validBitArray2[ wBlockIndex ] && matchTag( tlbTag, tagArray2[ wBlockIndex ])) begin
                  
                  if ( cReadOp ) begin

                        dataOutVal =   ( wBlockOfs == 2'b00 ) ? dataArray2[ wBlockIndex ] [`C_WORD_1] :
                                       ( wBlockOfs == 2'b01 ) ? dataArray2[ wBlockIndex ] [`C_WORD_2] :
                                       ( wBlockOfs == 2'b10 ) ? dataArray2[ wBlockIndex ] [`C_WORD_3] : 
                                                                dataArray2[ wBlockIndex ] [`C_WORD_4];                  

                  end else if ( cWriteOp ) begin

                     dirtyBitArray2[wBlockIndex] <= 1'b1;

                     if       (  wBlockOfs == 2'b00 ) dataArray2[ wBlockIndex ] [`C_WORD_1] <= dataInCpu;
                     else if  (  wBlockOfs == 2'b01 ) dataArray2[ wBlockIndex ] [`C_WORD_2] <= dataInCpu;
                     else if  (  wBlockOfs == 2'b10 ) dataArray2[ wBlockIndex ] [`C_WORD_3] <= dataInCpu;
                     else                             dataArray2[ wBlockIndex ] [`C_WORD_4] <= dataInCpu;

                  end else if ( cFlushOp ) begin
                     
                     cState = C_WRITE_BACK;

                  end else if ( cPurgeOp ) begin

                     validBitArray2[ wBlockIndex ] <= 0;

                  end

                  lruBitArray1[ wBlockIndex ] <= 1;
                  lruBitArray2[ wBlockIndex ] <= 0;

               end else begin 

                  // ??? do the decision for WRITE_BACK or ALLOCATE here ?

                  if ( cReadOp || cWriteOp ) cState = C_ALLOCATE;

               end

            end 

            cState[C_ALLOCATE]: begin 


               // ??? we have a miss, callocate a free block
               // ??? how do we access memory ? a new state ?
               // ??? set the next state in any case ?

               if ( ~ validBitArray1[ wBlockIndex ] ) begin
                  
                   // use set 1, invalid
                   // just a MEM fetch

               end else if ( ~ validBitArray2[ wBlockIndex ] ) begin

                  // use set 2, invalid
                  // just a MEM fetch
                  
               end else if ( lruBitArray1[ wBlockIndex ] == 1 ) begin

                  if ( dirtyBitArray1[ wBlockIndex ] ) begin

                      cState = C_WRITE_BACK;
                     
                  end

                  // use set 1, LRU
                  
               end else if ( lruBitArray2[ wBlockIndex ] == 1 ) begin
                  
                 
                  if ( dirtyBitArray2[ wBlockIndex ] ) begin

                     cState = C_WRITE_BACK;
                     
                  end

                   // use set 2, LRU
                 
               end

            end

            cState[C_WRITE_BACK]: begin



               // ??? write back the block assumed to be dirty, mark the block invalid
               

            end 

            default: begin

            end

         endcase 

      end

   end

   function matchTag;

      input[0:TLB_TAG_WIDTH-1]   tlbTag;
      input[0:C_TAG_WIDTH-1]     cacheTag;

      begin

         matchTag = ( tlbTag == cacheTag );

      end

   endfunction

endmodule


//------------------------------------------------------------------------------------------------------------
// L1 data cache. The CPU features two L1 caches, instruction and data. The data cache is a four-way set 
// associative cache, very similar to the instruction cache. There are however four instead of two sets
// and the LRU array has two bits per entry.
//
// ??? how to do statistics ? could do a ton of counters, but how expensive is this ?
//------------------------------------------------------------------------------------------------------------
module DCacheUnit #(

   parameter C_ENTRIES    = 1024,
   parameter C_TAG_WIDTH  = 32,
   parameter C_BLOCK_SIZE = 4

   ) ( 

   input    wire                                clk, 
   input    wire                                rst,

   input    wire[0:`WORD_LENGTH-1]              vSeg,
   input    wire[0:`WORD_LENGTH-1]              vOfs,
   input    wire[0:`WORD_LENGTH-1]              dataInCpu,
   input    wire                                cReadOp,
   input    wire                                cWriteOp,    
   input    wire[0:C_BLOCK_SIZE*`WORD_LENGTH-1] dataInMem,                             

   output   wire                                stallCpu, 
   output   wire[0:`WORD_LENGTH-1]              dataOutCpu,
   output   wire                                mReadOp,
   output   wire                                mWriteOp,
   output   wire[0:3]                           mAdrCpuId,
   output   wire[0:3]                           mAdrBank,
   output   wire[0:`WORD_LENGTH-1]              mAdrOfs,
   output   wire[0:C_BLOCK_SIZE*`WORD_LENGTH-1] dataOutMem         
   
   );

   parameter SETS = 4;

   parameter IDLE = 1'b0;
   parameter MISS = 1'b1;

   // ??? need more states for allocate and write back ?

   reg                                 validBitArray1[0:C_ENTRIES-1];
   reg                                 dirtyBitArray1[0:C_ENTRIES-1];
   reg[0:1]                            lruBitsArray1[0:C_ENTRIES-1];
   reg[0:C_TAG_WIDTH-1]                tagArray1[0:C_ENTRIES-1];
   reg[0:C_BLOCK_SIZE*`WORD_LENGTH]    dataArray1[0:C_ENTRIES-1];

   reg                                 validBitArray2[0:C_ENTRIES-1];
   reg                                 dirtyBitArray2[0:C_ENTRIES-1];
   reg[0:1]                            lruBitsArray2[0:C_ENTRIES-1];
   reg[0:C_TAG_WIDTH-1]                tagArray2[0:C_ENTRIES-1];
   reg[0:C_BLOCK_SIZE*`WORD_LENGTH]    dataArray2[0:C_ENTRIES-1];

   reg                                 validBitArray3[0:C_ENTRIES-1];
   reg                                 dirtyBitArray3[0:C_ENTRIES-1];
   reg[0:1]                            lruBitsArray3[0:C_ENTRIES-1];
   reg[0:C_TAG_WIDTH-1]                tagArray3[0:C_ENTRIES-1];
   reg[0:C_BLOCK_SIZE*`WORD_LENGTH]    dataArray3[0:C_ENTRIES-1];

   reg                                 validBitArray4[0:C_ENTRIES-1];
   reg                                 dirtyBitArray4[0:C_ENTRIES-1];
   reg[0:1]                            lruBitsArray4[0:C_ENTRIES-1];
   reg[0:C_TAG_WIDTH-1]                tagArray4[0:C_ENTRIES-1];
   reg[0:C_BLOCK_SIZE*`WORD_LENGTH]    dataArray4[0:C_ENTRIES-1];

   integer i;

   reg cState = IDLE;


   always @( posedge clk or negedge rst ) begin 

       if ( ~ rst ) begin
         
         for ( i = 0; i < C_ENTRIES; i = i + 1 ) begin
      
            validBitArray1[ i ]  = 0;
            dirtyBitArray1[ i ]  = 0;
            lruBitsArray1[ i ]   = 0;

            validBitArray2[ i ]  = 0;
            dirtyBitArray2[ i ]  = 0;
            lruBitsArray2[ i ]   = 0;

            validBitArray3[ i ]  = 0;
            dirtyBitArray3[ i ]  = 0;
            lruBitsArray3[ i ]   = 0;

            validBitArray4[ i ]  = 0;
            dirtyBitArray4[ i ]  = 0;
            lruBitsArray4[ i ]   = 0;

         end
     
      end else begin


      // ??? fill in when the I-cache is completed... leverage...

      end

   end 

endmodule


//------------------------------------------------------------------------------------------------------------
// The memory interface units is the interface betwen the I and D cache and the memory. There are two channels
// with channel "1" having priority over channel "2".
//
// ??? to do ...
//------------------------------------------------------------------------------------------------------------
module MemoryInterface #(

   parameter M_BLOCK_SIZE = 4

   ) ( 

   input    wire                                clk, 
   input    wire                                rst,

   input    wire                                mReadOp1,
   input    wire                                mWriteOp1,
   input    wire[0:M_BLOCK_SIZE*`WORD_LENGTH-1] mDataIn1,  

   input    wire                                mReadOp2,
   input    wire                                mWriteOp2,
   input    wire[0:M_BLOCK_SIZE*`WORD_LENGTH-1] mDataIn2,  

   output   wire                                mReady1, 
   output   wire[0:3]                           mAdrCpuId1,
   output   wire[0:3]                           mAdrBank1,
   output   wire[0:`WORD_LENGTH-1]              mAdrOfs1,
   output   wire[0:M_BLOCK_SIZE*`WORD_LENGTH-1] mDataOut1,   

   output   wire                                mReady2, 
   output   wire[0:3]                           mAdrCpuId2,
   output   wire[0:3]                           mAdrBank2,
   output   wire[0:`WORD_LENGTH-1]              mAdrOfs2,
   output   wire[0:M_BLOCK_SIZE*`WORD_LENGTH-1] mDataOut2   
    
   );

   // arbitrate between channel 1 and 2
   // data may be fetched in smaller chunks and then take more cycles...


endmodule 


//------------------------------------------------------------------------------------------------------------
// Content addressable memory. The instruction/data TLB will be implemented as a 16-entry dual ported fully 
// associative memory structure. 
//
// The content is a 37bit structure:
//
//    bit 0:               -> valid bit
//    bit 1..WDITH - 1:    -> virtual page number.
//
// The code has two major parts. The first compares all the entries for the the pattern. A positive result 
// will set the corresponding matchline. Next, the matchline is converted to the entry address using a 
// priority encoder. 
//
// ??? split pattern in the parts needed ?
// ??? change for 32-bit words, a virtual page is 16 + 32 - 14 = 34 bits
//------------------------------------------------------------------------------------------------------------
module DualPortedCamUnit_16 #(

   parameter WIDTH = 36
  
   ) ( 

   input    wire              clk, 
   input    wire              rst,
   input    wire[0:WIDTH - 1] patternA,
   input    wire[0:WIDTH - 1] patternB, 
   input    wire[0:3]         writeAdr, 
   input    wire              wEnable,
   output   wire[0:3]         matchAdrA, 
   output   wire[0:3]         matchAdrB, 
   output   wire              mFoundA, 
   output   wire              mFoundB 

   );

   reg [0:WIDTH]  ram [0:15];
   wire[0:15]     matchLineA;
   wire[0:15]     matchLineB;

   always @ ( posedge clk or negedge rst ) begin

      if ( ~ rst ) begin

         for ( integer k = 0; k < 15; k = k + 1 ) ram[ k ] = 0;

      end else begin
         
         if ( wEnable ) ram[ writeAdr ] <= { 1'b1, patternA };
      end
 
   end

   for ( genvar i = 0; i < 15; i = i + 1 ) begin
      
      assign matchLineA[ i ] = ( ram[ i ] == { 1'b1, patternA } );
   
   end

   for ( genvar j = 0; j < 15; j = j + 1 ) begin

      assign matchLineB[ j ] = ( ram[ j ] == { 1'b1, patternB } );
   
   end

   assign mFoundA = |matchLineA;
   assign mFoundB = |matchLineB;

   Encoder_16_4 encA ( .a( matchLineA ), .y( matchAdrA ));
   Encoder_16_4 encB ( .a( matchLineA ), .y( matchAdrA ));

endmodule


//------------------------------------------------------------------------------------------------------------
// Register file unit. The unit contains a set of registers. It is the building block for the general register
// set and segment register set. The ScanRegFileUnit supports two modes. The normal mode is a register with 
// a parallel input and output, set at the positive edge of the clock. In addition, there is a serial interface
// for reading the registers as a serial bit stream for analysis and diagnostics. As the bit vector could be
// quite large, a simple state machine will shift the data on a word by basis.
//
// ??? what do we do about the REG0 case ? shift it as a set of zeroes ?
//------------------------------------------------------------------------------------------------------------
module ScanRegFileUnit #(

   parameter SIZE    = 8,
   parameter WIDTH   = `WORD_LENGTH
 
   ) (
      
   input    wire                       clk,
   input    wire                       rst,
   
   input    wire                       write,
   input    wire [0:$clog2( SIZE )-1]  wrAddr,
   input    wire [0:WIDTH-1]           wrData,
   input    wire [0:$clog2( SIZE )-1]  rdAddrA,
   input    wire [0:$clog2( SIZE )-1]  rdAddrB,

   output   wire [0:WIDTH-1]           rdDataA,
   output   wire [0:WIDTH-1]           rdDataB,
   
   input    wire                       sClock,
   input    wire                       sEnable,
   input    wire                       sIn,
   output   reg                        sOut

   );

   reg [0:WIDTH-1]            regFile [0:SIZE-1];  // REG0 ???
   reg [0:$clog2( SIZE )-1]   shiftAdr;
   reg [0:SIZE-1]             shiftReg;
   reg [0:5]                  shiftCnt;

   assign rdDataA = ( rdAddrA == 0 ) ? 32'h0 : regFile[rdAddrA];
   assign rdDataB = ( rdAddrB == 0 ) ? 32'h0 : regFile[rdAddrB];

   always @( negedge rst ) begin

      if ( ~ rst ) begin

         for ( integer i = 1; i < SIZE-1; i = i + 1 ) regFile[i] <= 0;

         sOut     <= 0;
         shiftAdr <= 0;
         shiftReg <= 0;
         shiftCnt <= 0;

      end 

   end

   always @( posedge clk ) begin

      if ( wrAddr != 0 ) begin
            
         if ( write ) regFile[wrAddr] <= wrData;

      end

   end

   always @( posedge sClock ) begin

      if ( sEnable ) begin

         if ( shiftCnt == 0 ) begin
      
            shiftReg <= regFile[ shiftCnt ];
            sOut     <= shiftReg[ 0 ];
            shiftReg <= shiftReg << 1;
            shiftCnt <= 1;

         end else if ( shiftCnt < WIDTH ) begin

            sOut     <= shiftReg[ 0 ];
            shiftReg <= { sIn, shiftReg[ 1:SIZE-1] };
            shiftCnt <= shiftCnt +1; 

         end else begin

            regFile[ shiftAdr ]  <= { sIn, shiftReg[1:SIZE-1]};
            shiftCnt             <= 0;

            if ( shiftAdr < SIZE -1 )  shiftAdr <= shiftAdr + 1;
            else                       shiftAdr <= 0;
         
         end

      end
   
   end

endmodule


//------------------------------------------------------------------------------------------------------------
// A general register. The register can be instatiated with different field widths. In addition, the ScanReg
// Unit can be operated in two modes. The normal mode ( 1'b0 ) is a register with a parallel input and output,
// set at the positive edge of the clock. In scan mode ( 1'b1 ), the register shifts one position to the right
// reading one bit the from the serial input, passing the highest bit to the serial output. The idea is that 
// a set of scan registers can be connected serially and shifted out as a big bit string for analysis and
// diagnostics. Note that the serial output of the last register needs to feed into the serial input of the 
// first register of the overial register chain. The number of clock cycles needs to match the sum of all 
// bits in the registers, such that the original content is restored. A scan register is used for example 
// for the  pipeline register so we can see the setting of them during debug.
//
//------------------------------------------------------------------------------------------------------------
module ScanRegUnit #( 

      parameter WIDTH = `WORD_LENGTH

   ) (

      input    wire                       clk,
      input    wire                       rst,
      input    wire[0:`WORD_LENGTH-1]     d,

      output   reg[0:`WORD_LENGTH-1]      q,
      
      input    wire                       sClock,
      input    wire                       sEnable,
      input    wire                       sIn,
      output   reg                        sOut

   );

   always @( negedge rst ) begin

       if ( ~ rst ) begin

         q     <= 0;
         sOut  <= 0;

       end

   end

   always @( posedge clk ) begin

       if ( ~ rst ) begin

         q     <= 0;
         sOut  <= 0;

      end else begin

         q     <= d;

      end
   
   end
      
   always @( posedge sClock ) begin

      if ( sEnable ) begin

         q     <= { sIn, q[`WORD_LENGTH-1] };
         sOut  <= q[`WORD_LENGTH-1];

      end 

   end

endmodule


//------------------------------------------------------------------------------------------------------------
// The arithmetic and logical unit is one of the central components of VCPU-32. Together with the shift-merge 
// unit it is the heart of the execution stage. The ALU is a 32-bit wide unit. The control parameter input 
// drives the operation of the ALU. The 8 bits of the control code are as follows:
//
//    - Bit 0:    Represents the carry in value.
//    - Bit 1:    the B input is inverted before operation              ( tmpB <- ~ B )
//    - Bit 2:    the ALU putput is inverted                            ( R    -> ~ tmpR )
//    - Bit 3..4: the A input is shifted left by zero to three bits     ( tmpA <- A << amount )
//
//    - Bit 5..7: The ALU operation code for procesing the A and B value as follows:
//
//          0 -   the ALU produces a zero result, subject to ouput inversion. ( R    -> ~ tmpR )
//          1 -   tmpA is just passed through.                                ( tmpR <- tmpA )
//          2 -   tmpB is just passed through.                                ( tmpR <- tmpB )   
//          3 -   tmpA and tmpB are the input to the adder module.            ( tmpR <- tmpa + tmpB + cIn )   
//          4 -   reserved, returns zero for now.                             ( tmpR <- 0 )   
//          5 -   tmpA and tmpB are input to the AND module.                  ( tmpR <- tmpa & tmpB )
//          6 -   tmpA and tmpB are input to the OR module.                   ( tmpR <- tmpa | tmpB )
//          7 -   tmpA and tmpB are input to the XOR module.                  ( tmpR <- tmpa ^ tmpB )
//
// Note that all these options can be combined. For example, a carry in of 1, the negation of B and a ALU 
// add operation will resuslt in a subtraction operation. The ALU does logical addition. The interpretation
// of overflow for signed and unsigned arithmetic is handed by the enclosing module.
// 
// ??? the shift operations for "a" could also result in an overflow. This should perhaps also be handled
// by the enclosing module, since this module will know whether this is a shift or unsigned shift. In this
// case, the err line my not be necessary.
//
//
// ??? rework.....
//------------------------------------------------------------------------------------------------------------
module AluUnit (

   input    wire[0:`WORD_LENGTH-1]  a,
   input    wire[0:`WORD_LENGTH-1]  b,
   input    wire[0:7]               ac,

   output   wire[0:`WORD_LENGTH-1]  r,
   output   wire                    c,
   output   wire                    n,
   output   wire                    z,
   output   wire                    err
   
   );

   wire[0:`WORD_LENGTH-1] tmpA, tmpB, tAnd, tOr, tXor, tAdd, tmpR;
   wire tCout;

   AdderUnit #( .WIDTH( `WORD_LENGTH )) U1 ( .a( tmpA ), .b( tmpB ), .inC( ac[0] ), .s( tAdd ), .outC( tCout )); 

   Mux_8_1  U2 (  .a0( 32'd0 ),
                  .a1( tmpA ),
                  .a2( tmpB ),
                  .a3( tAdd ),
                  .a4( 32'd0 ),
                  .a5( tAnd ),
                  .a6( tOr ),
                  .a7( tXor ),
                  .sel( ac[5:7] ), 
                  .enb( 1'b1 ),
                  .y( tmpR ));

   assign tmpA =  ( ac[3:4] == 2'b00 ) ? 0 :
                  ( ac[3:4] == 2'b01 ) ? { a[1:23], 1'b0 } :
                  ( ac[3:4] == 2'b10 ) ? { a[2:23], 2'b00 } :
                  ( ac[3:4] == 2'b11 ) ? { a[3:23], 3'b000 } :
                  1'bX;
        
   assign tmpB = ( ac[1] ? ( ~ b ) : ( b ));
   assign tAnd = tmpA & tmpB;
   assign tOr  = tmpA | tmpB;
   assign tXor = tmpA ^ tmpB;
   
   assign r    = ( ac[2] == 1'b1 ) ? ( ~ tmpR ) : ( tmpR );
   assign n    = r[0];
   assign z    = ( r == 32'd0 );
   assign c    = ( ac[5:7] == 3 ) ? tCout : 0;
   assign err  = 1'b0; // for now ... until we know what to do about the shift operation and overflow.
 
endmodule


//------------------------------------------------------------------------------------------------------------
// Shift-Merge Unit. VCPU-32 features instructions for extract and deposit operations n a word. We spend quite
// some HW on it. The shift and merge unit needs a shifter, a mask generator and some control logic, which
// computes the bit positions for the left and right boundary of the field to extract or deposit as well as 
// the field length to extract or deposit. The shift amount is also used for the DSR instruction. The bitmask 
// module generates a bitmask using the left and right bit positions decoded. The double shifter shifts the
// respective input. This module takes the pieces and assembles the result. 
//
//
// ??? rework ...
//------------------------------------------------------------------------------------------------------------
module ShiftMergeUnit (

   input    wire[0:31]     a,
   input    wire[0:31]     b,
   input    wire[0:31]     instr, 
   input    wire[0:4]      saReg,

   output   reg[0:31]      r,
   output   wire           err

   );

   wire[0:4]      sa, pl, pr;
   wire[0:5]      opCode;
   wire[0:31]     wShift, wMask;

   assign opCode = instr[0:5];

   ShiftMergeDecode        U0 ( .instr( instr ), .saReg( saReg ), .sa( sa ), .pl( pl ), .pr( pr ), .err( err ));
   DoubleShiftRight_64bit  U1 ( .a( a ), .b( b ), .sa( sa ), .y( wShift ));
   ShiftMergeMask_32bit    U2  ( .lft( pl ), .rht( pr ), .y( wMask ));
   
   always @ (*) begin

      if      ( opCode == `OP_DSR )    r = wShift;
      else if ( opCode == `OP_EXTR )   r = wShift & ( ~ wMask );
      else if ( opCode == `OP_DEP )    r = a | ( wShift | wMask );
      else                             r = 0;

   end

endmodule


//------------------------------------------------------------------------------------------------------------
// Shift-Merge decode circuit. This is actually the brains of the shift merge unit. We will take the 
// instruction, decode which one it is and compute the shift amount, left and right bit mask position. As
// input we will also have the shift amount register content for variable shifts.
//
// The instruction has a position field and a length field. The data field starts at the "position" field 
// and extends to the left for "len" bits. A position field value of 31 indicates that the SA Control Reg
// has the position value. In a 32-bit machine we cannot use any kind of binary modulo arithmetic, e.g.
// wrapping around modulo 5 bits. As a consequence, we need a lot of HW to do subtraction and addition. The 
// double shifter is used to move the bit field accordingly. Since we can only shift right, a left shift is 
// handled by putting the argument in the left half of the double shifter and shift by "pos" + 1. The shift 
// amount for teh doulbe shifter is returned in "sa". The following computations are done:
//    
// EXTR Instruction: 
//   
///   PR = ( pos == 31 ) ? SAREG : pos;
//    PL = PR - len + 1;
//    SA = 23 - PL ( input in right half )
// 
// DEP Instruction: 
//   
//    PR = ( pos == 31 ) ? SAREG : pos;
//    PL = PR - len + 1;
//    SA = PL + 1; ( Input in left half )
//
// DSR instruction:
// 
//    PR = 0;
//    PL = 0;
//    SA = ( len == 31 ) ? SAREG : len; ( Input is both halfs )
// 
// For the EXTR and DEP instruction, the position field value is checked to be a value between 0 and 23. For
// the DSR instruction, the length field is checked for being a value between 0 and 23. The code is written 
// in behavioural mode. Let the synthesizer do its magic.
// 
//
// ??? rework ...
//------------------------------------------------------------------------------------------------------------
module ShiftMergeDecode (

   input    wire[0:31]  instr,
   input    wire[0:4]   saReg,

   output   wire[0:4]   sa,
   output   wire[0:4]   pl,
   output   wire[0:4]   pr,
   output   wire        err

   );

   wire[0:5]   opCode;
   wire[0:4]   pos, len;
   wire        posErr;
   wire        lenErr;

   assign len     = (( instr[9:13] == 5'd31 ) ? saReg[19:23] : instr[9:13] );
   assign pos     = (( instr[14:18] == 5'd31 ) ? saReg[19:23] : instr[14:18] );

   assign opCode  = instr[0:5];
   assign posErr  = (( pos != 5'd31 ) && ( pos[0:1] == 2'b11 ));
   assign lenErr  = (( len != 5'd31 ) && ( len[0:1] == 2'b11 ));

   assign pl      = pos - len + 1;
   assign pr      = pos;
   assign sa      =  ( opCode == `OP_EXTR ) ? `WORD_LENGTH - 1 - pl : 
                     ( opCode == `OP_DEP  ) ? pl + 1 : 0;

   assign err     =  ( opCode == `OP_EXTR ) ? posErr :
                     ( opCode == `OP_DEP )  ? posErr :
                     ( opCode == `OP_DSR )  ? lenErr : 1'b0;

endmodule


//------------------------------------------------------------------------------------------------------------
// Immediate Value Generator. The immediate value generator creates the sign extended immediate value from 
// the instruction word bit fields for the particular instruction format. For instructions without an
// immediate field, the return value is zero. 
//
//
//
// ??? needs to change for new formats ...
// ??? should returh y zero as default and explicitly for some instructions, as the address adder relies on
// X being zero when needed...
//------------------------------------------------------------------------------------------------------------
module ImmGenUnit (   

   input    wire[0:`WORD_LENGTH-1]  instr,
   output   reg[0:`WORD_LENGTH-1]   y
   
   );

   always @( instr ) begin
   
      case ( instr[0:5] )

         `OP_LD, `OP_ST, `OP_LDR, `OP_STC: begin

            if ( instr[12:14] == 3'b011 ) begin

               y = {{ 18{ instr[15] }}, { instr[ 15:17], instr[9:11] }};
            
            end else begin

               y = {{ 12{ instr[15] }}, { instr[15:23], instr[9:11] }};

            end

         end

         `OP_CBR: begin

            y = {{ 15{ instr[15] }}, { instr[15:17], instr[9:14] }};

         end

         `OP_LDA, `OP_STA: begin

            y = {{ 12{ instr[15] }}, { instr[15:20], instr[9:14] }};

         end

         `OP_LDIL: begin 

             y = {{ 12{ instr[15] }}, { instr[15:23], instr[9:11] }};

         end   
      
         `OP_B, `OP_GATE: begin     

            y = {{ 9{ instr[15] }}, { instr[ 15:23], instr[9:14] }};

         end

         `OP_BE: begin     

            y = {{ 12{ instr[15] }}, { instr[ 15:17], instr[6:14] }};

         end

         `OP_ADD, `OP_SUB, `OP_ADC, `OP_SBC, `OP_AND, `OP_OR, `OP_XOR, `OP_CMP: begin

             if ( instr[12:14] == 3'b011 ) begin

               y = {{ 21{ instr[15] }}, { instr[ 15:17] }};
            
            end else begin

                y = {{ 15{ instr[15] }}, instr[15:23] };

            end

         end 

         `OP_CMR: begin

            y = {{ 18{ instr[15] }}, instr[15:20] };

         end

         default: y = 0;
   
      endcase
   
   end

endmodule


//------------------------------------------------------------------------------------------------------------
// Double Shift Unit. The unit takes two words, A and B, concatenates them and performs a logical shift right
// operation. We implement a barrel shifter type unit using 4 and 2 way multiplexers.
//
//------------------------------------------------------------------------------------------------------------
module DoubleShiftRight_64bit (

   input    wire[0:31]  a,
   input    wire[0:31]  b,
   input    wire[0:4]   sa,

   output   wire[0:31]  y

   );

   wire[0:63] w1, w2, w3, w4;

   assign w1 = { a, b };
   assign y  = w4[`WORD_LENGTH:`DBL_WORD_LENGTH-1];

   Mux_4_1 #( .WIDTH( `DBL_WORD_LENGTH )) U0 (  .a0( w1 ), 
                                                .a1( { 8'b0,  w1[0:64 - 8  - 1] } ), 
                                                .a2( { 16'b0, w1[0:64 - 16 - 1] } ), 
                                                .a3( { 32'b0, w1[0:64 - 32 - 1] } ),
                                                .sel( sa[ 0:1 ] ), 
                                                .enb( 1'b1 ),
                                                .y( w2 ));

   Mux_4_1 #( .WIDTH( `DBL_WORD_LENGTH )) U1 (  .a0( w2 ), 
                                                .a1( { 2'b0, w2[0:64 - 2 - 1] } ), 
                                                .a2( { 4'b0, w2[0:64 - 4 - 1] } ), 
                                                .a3( { 6'b0, w2[0:64 - 6 - 1] } ), 
                                                .sel( sa[2:3] ),
                                                .enb( 1'b1 ), 
                                                .y( w3 ));

   Mux_2_1 #( .WIDTH( `DBL_WORD_LENGTH )) U2 (  .a0( w3 ), 
                                                .a1( { 1'b0, w3[0:64 - 1 - 1 ] } ), 
                                                .sel( sa[4] ),
                                                .enb( 1'b1 ), 
                                                .y( w4 ));

endmodule


//------------------------------------------------------------------------------------------------------------
// BitMask generator. We construct a mask with a zero bit field between the left and right position. The bits
// named by the L and R value are included in the field. The outside bits to teh left and right are set to 
// one. The bit mask is primarily used by the shift/merge unit for extract and deposit instructions.
//
// In:      0 1 2 3 ...... 29 30 31
//                ^        ^    
//                L        R
//
// Out:     1 1 1 0 ...... 0  1  1
//
//------------------------------------------------------------------------------------------------------------
module ShiftMergeMask_32bit (

   input    wire [0:4]  lft,
   input    wire [0:4]  rht,

   output   wire [0:31] y
   
   );
    
   reg[0:23] maskLeft, maskRight;
   
   always @ ( lft, rht ) begin

      case ( lft )
    
         5'd00 : maskLeft = 32'h00000000;
         5'd01 : maskLeft = 32'h80000000;
         5'd02 : maskLeft = 32'hc0000000;
         5'd03 : maskLeft = 32'he0000000;
         5'd04 : maskLeft = 32'hF0000000;
         5'd05 : maskLeft = 32'hf8000000;
         5'd06 : maskLeft = 32'hfc000000;
         5'd07 : maskLeft = 32'hfe000000;
         5'd08 : maskLeft = 32'hff000000;
         5'd09 : maskLeft = 32'hff800000;
         5'd10 : maskLeft = 32'hffc00000;
         5'd11 : maskLeft = 32'hffe00000;
         5'd12 : maskLeft = 32'hfff00000;
         5'd13 : maskLeft = 32'hfff80000;
         5'd14 : maskLeft = 32'hfffc0000;
         5'd15 : maskLeft = 32'hfffe0000;
         5'd16 : maskLeft = 32'hffff0000;
         5'd17 : maskLeft = 32'hffff8000;
         5'd18 : maskLeft = 32'hffffc000;
         5'd19 : maskLeft = 32'hffffe000;
         5'd20 : maskLeft = 32'hfffff000;
         5'd21 : maskLeft = 32'hfffff800;
         5'd22 : maskLeft = 32'hfffffc00;
         5'd23 : maskLeft = 32'hfffffe00;
         5'd24 : maskLeft = 32'hffffff00;
         5'd25 : maskLeft = 32'hffffff80;
         5'd26 : maskLeft = 32'hffffffc0;
         5'd27 : maskLeft = 32'hffffffe0;
         5'd28 : maskLeft = 32'hfffffff0;
         5'd29 : maskLeft = 32'hfffffff8;
         5'd30 : maskLeft = 32'hfffffffc;
         5'd31 : maskLeft = 32'hfffffffe;

         default : maskLeft = 32'h00000000;
            
      endcase
    
   end

   always @ ( rht ) begin
        
      case ( rht )

         5'd00 : maskRight = 32'h7fffffff; 
         5'd01 : maskRight = 32'h3fffffff;
         5'd02 : maskRight = 32'h1fffffff;
         5'd03 : maskRight = 32'h0fffffff;
         5'd04 : maskRight = 32'h07ffffff;
         5'd05 : maskRight = 32'h03ffffff;
         5'd06 : maskRight = 32'h01ffffff;
         5'd07 : maskRight = 32'h00ffffff;
         5'd08 : maskRight = 32'h007fffff;
         5'd09 : maskRight = 32'h003fffff;
         5'd10 : maskRight = 32'h001fffff;
         5'd11 : maskRight = 32'h000fffff;
         5'd12 : maskRight = 32'h0007ffff;
         5'd13 : maskRight = 32'h0003ffff;
         5'd14 : maskRight = 32'h0001ffff;
         5'd15 : maskRight = 32'h0000ffff;
         5'd16 : maskRight = 32'h00007fff;
         5'd17 : maskRight = 32'h00003fff;
         5'd18 : maskRight = 32'h00001fff;
         5'd19 : maskRight = 32'h00000fff;
         5'd20 : maskRight = 32'h000007ff;
         5'd21 : maskRight = 32'h000003ff;
         5'd22 : maskRight = 32'h000001ff;
         5'd23 : maskRight = 32'h000000ff;
         5'd24 : maskRight = 32'h0000007f;
         5'd25 : maskRight = 32'h0000003f;
         5'd26 : maskRight = 32'h0000001f;
         5'd27 : maskRight = 32'h0000000f;
         5'd28 : maskRight = 32'h00000007;
         5'd29 : maskRight = 32'h00000003;
         5'd30 : maskRight = 32'h00000001;
         5'd31 : maskRight = 32'h00000000;

         default : maskRight = 32'h00000000;
            
      endcase
    
   end

   assign y = maskLeft | maskRight;

endmodule


//------------------------------------------------------------------------------------------------------------
// Variable sign extend unit for a 32-bit word. We create a bit mask with "ones" on the left side. If the bit
// at position "P" is zero, we AND the inverted bit mask with the input else we simply OR the mask such that 
// the sign bit is stored in the posituion left of the sign bit. The position P is the bit number in the word
//  with bit zero the MSB and bit 23 the LSB.
//
//------------------------------------------------------------------------------------------------------------
module SignExtend_32bit( 

   input    wire[0:31]  a, 
   input    wire[0:4]   pos, 
   output   reg[0:31]   y 
   
   );

   reg[0:`WORD_LENGTH-1] extMask;
 
   always @ (*) begin

      case ( pos ) 

         5'd00 : extMask = 32'h00000000;
         5'd01 : extMask = 32'h80000000;
         5'd02 : extMask = 32'hc0000000;
         5'd03 : extMask = 32'he0000000;
         5'd04 : extMask = 32'hF0000000;
         5'd05 : extMask = 32'hf8000000;
         5'd06 : extMask = 32'hfc000000;
         5'd07 : extMask = 32'hfe000000;
         5'd08 : extMask = 32'hff000000;
         5'd09 : extMask = 32'hff800000;
         5'd10 : extMask = 32'hffc00000;
         5'd11 : extMask = 32'hffe00000;
         5'd12 : extMask = 32'hfff00000;
         5'd13 : extMask = 32'hfff80000;
         5'd14 : extMask = 32'hfffc0000;
         5'd15 : extMask = 32'hfffe0000;
         5'd16 : extMask = 32'hffff0000;
         5'd17 : extMask = 32'hffff8000;
         5'd18 : extMask = 32'hffffc000;
         5'd19 : extMask = 32'hffffe000;
         5'd20 : extMask = 32'hfffff000;
         5'd21 : extMask = 32'hfffff800;
         5'd22 : extMask = 32'hfffffc00;
         5'd23 : extMask = 32'hfffffe00;
         5'd24 : extMask = 32'hffffff00;
         5'd25 : extMask = 32'hffffff80;
         5'd26 : extMask = 32'hffffffc0;
         5'd27 : extMask = 32'hffffffe0;
         5'd28 : extMask = 32'hfffffff0;
         5'd29 : extMask = 32'hfffffff8;
         5'd30 : extMask = 32'hfffffffc;
         5'd31 : extMask = 32'hfffffffe;
   
         default : extMask = 32'h00000000;

      endcase

      if ( a[ pos ] == 1'b0 ) begin

         y = a & ( ~ extMask );

      end else begin

         y = a | extMask;

      end

   end

endmodule 


//------------------------------------------------------------------------------------------------------------
// "TestCondUnit" tests the input word according to the condition selected. The defined conditions are
//
//    0 - EQ   -> a == 0
//    1 - NE   -> a != 0
//    2 - LT   -> a < 0
//    3 - GT   -> a >= 0
//    4 - LE   -> a <= 0
//    5 - GE   -> a >= 0
//    6 - EV   -> a is even
//    7 - OD   -> a is odd
//
//
// ??? we need to match to what the instructions need....
//------------------------------------------------------------------------------------------------------------
module TestCondUnit #( 

   parameter WIDTH = `WORD_LENGTH

   ) (

   input  wire [0:WIDTH-1] a,
   input  wire [0:2]       op,
   output reg              y

   );

   wire z = ( a == 0 );

   always @ (*) begin

         case ( op )
      
            3'd00 :  y = z;                     // data == 0
            3'd01 :  y = ~ z;                   // data != 0
            3'd02 :  y = a[0];                  // data < 0 
            3'd03 :  y = ( ~ a[0] ) & ( ~z );   // data > 0 
            3'd04 :  y = a[0] || z;             // data <= 0 
            3'd05 :  y = ( ~ a[0] ) || z;       // data >= 0 
            3'd06 :  y = ~ a[ WIDTH-1];         // even
            3'd07 :  y = a[ WIDTH-1 ];          // odd
            default: y = 0;
           
         endcase

   end

endmodule


//------------------------------------------------------------------------------------------------------------
// The Adder is a simple adder of two unsigned numbers including a carry in for multi-precision arithmetic.  
// Any interpretation of signd or unsigned must be handled in the instantiating layer. The Adder unit is
// implemented in behavioral verilog. There is also a version which explicitly implements a carry lookahead
// adder.
//
//------------------------------------------------------------------------------------------------------------
module AdderUnit #( 

   parameter WIDTH = `WORD_LENGTH

   ) ( 

   input    wire[0:WIDTH-1]   a, 
   input    wire[0:WIDTH-1]   b, 
   input    wire              inC,
  
   output   wire[0:WIDTH-1]   s,
   output   wire              outC

   );

   assign { outC, s } = a + b + inC;

endmodule


//------------------------------------------------------------------------------------------------------------
// The Incrementer unit is a simple adder of two unsigned numbers including a carry in for multi-precision
// arithmetic. Any interpretation of signd or unsigned must be handled in the instantiating layer. The unit
// is implemented in behavioral verilog.
//
//------------------------------------------------------------------------------------------------------------
module IncrementerUnit #( 

   parameter WIDTH = 32,
   parameter AMT   = 1

   ) (
   
   input    wire[0:WIDTH-1]   a,

   output   wire[0:WIDTH-1]   s,
   output   wire              outC

   );

   assign { outC, s } = a + AMT;
   
endmodule


//------------------------------------------------------------------------------------------------------------
// The 32-bit carry lookahead adder is built from 4-bit carry lookahead adders connected in ripple mode. 
// 
//------------------------------------------------------------------------------------------------------------
module Adder_CLA_32bit (   

   input    wire[0:31]  a, 
   input    wire[0:31]  b, 
   input                inC,

   output   wire[0:31]   s,
   output   wire         outC

   );

   wire[0:6] c;

   Adder_CLA_4bit F0 ( .a( a[28:31]), .b( b[28:31]), .inC( inC  ), .s( s[28:31]), .outC( c[6] ));
   Adder_CLA_4bit F1 ( .a( a[24:27]), .b( b[24:27]), .inC( c[6] ), .s( s[24:27]), .outC( c[5] ));
   Adder_CLA_4bit F2 ( .a( a[20:23]), .b( b[20:23]), .inC( c[5] ), .s( s[20:23]), .outC( c[4] ));
   Adder_CLA_4bit F3 ( .a( a[16:19]), .b( b[16:19]), .inC( c[4] ), .s( s[16:19]), .outC( c[3] ));
   Adder_CLA_4bit F4 ( .a( a[12:15]), .b( b[12:15]), .inC( c[3] ), .s( s[12:15]), .outC( c[2] ));
   Adder_CLA_4bit F5 ( .a( a[ 8:11]), .b( b[ 8:11]), .inC( c[2] ), .s( s[ 8:11]), .outC( c[1] ));
   Adder_CLA_4bit F6 ( .a( a[ 4: 7]), .b( b[ 4: 7]), .inC( c[1] ), .s( s[ 4: 7]), .outC( c[0] ));
   Adder_CLA_4bit F7 ( .a( a[ 0: 3]), .b( b[ 0: 3]), .inC( c[0] ), .s( s[ 0: 3]), .outC( outC ));

endmodule


//------------------------------------------------------------------------------------------------------------
// Carry Lookahead Adder - 4bit. A CLA computes the carry data for each bit position, so that we do not have
// to wait until the carry data is "rippled" through the four positions. The 4-bit adder is a building block
// for our 32-bit adder.
//
//------------------------------------------------------------------------------------------------------------
module Adder_CLA_4bit (

   input    wire[0:3]   a, 
   input    wire[0:3]   b, 
   input                inC,

   output   wire[0:3]   s, 
   output   wire        outC

   );
   
   wire [0:3] p, g, c;

   assign c[3] = inC;
   assign c[2] = g[3] | ( p[3] & c[3] );
   assign c[1] = g[2] | ( p[2] & c[2] );
   assign c[0] = g[1] | ( p[1] & c[1] );
   assign outC = g[0] | ( p[0] & c[0] );

   FullAdder_CLA U0 ( .a( a[0] ), .b( b[0] ), .inC( c[0] ), .s( s[0] ), .p( p[0] ), .g( g[0] ));
   FullAdder_CLA U1 ( .a( a[1] ), .b( b[1] ), .inC( c[1] ), .s( s[1] ), .p( p[1] ), .g( g[1] ));
   FullAdder_CLA U2 ( .a( a[2] ), .b( b[2] ), .inC( c[2] ), .s( s[2] ), .p( p[2] ), .g( g[2] ));
   FullAdder_CLA U3 ( .a( a[3] ), .b( b[3] ), .inC( c[3] ), .s( s[3] ), .p( p[3] ), .g( g[3] ));

endmodule


//------------------------------------------------------------------------------------------------------------
// "FullAdder_CLA" is a full adder building block which directly generates the carry lookahead generate and
// propagate signals. It is used for the carry lookahead adders.
//
//------------------------------------------------------------------------------------------------------------
module FullAdder_CLA (

   input wire a, 
   input wire b, 
   input wire inC,

   output wire s, 
   output wire p,
   output wire g
   
   );

   xor   ( s, a, b, inC );
   or    ( p, a, b );
   and   ( g, a, b );

endmodule


//------------------------------------------------------------------------------------------------------------
// The logic unit implements the  logical functions of the CPU. The implementation is essentially a lookup 
// table for the function map and a 4:1 multiplexer that selects the respective function result for a bit 
// from the lookup table.
//
//------------------------------------------------------------------------------------------------------------
module logicUnit  #( 

   parameter WIDTH = `WORD_LENGTH

   ) ( 

      input wire[0:WIDTH-1]  a,
      input wire[0:WIDTH-1]  b,
      input wire[0:2]        op,
      output reg[0:WIDTH-1]  y
   );

   reg  [0:3] map;

   always @(*) begin
    
      case ( op ) 

         `LOP_AND:   map = 4'b0001;   
         `LOP_CAND:  map = 4'b0010;  
         `LOP_XOR:   map = 4'b0110;   
         `LOP_OR:    map = 4'b0111;  
         `LOP_NAND:  map = 4'b1110;  
         `LOP_COR:   map = 4'b1011;   
         `LOP_XNOR:  map = 4'b1001;  
         `LOP_NOR:   map = 4'b1000;   
         default:    map = 4'b0000;

      endcase

      for ( integer i = 0; i < WIDTH; i = i + 1 ) y[i] = map[{a[i], b[i]}];

   end

endmodule


//------------------------------------------------------------------------------------------------------------
// AND operation of A and B, parameterized with WORD_LENGTH-bit word by default. A simple set of AND gates.
//
//------------------------------------------------------------------------------------------------------------
module AndOp #(

      parameter WIDTH = `WORD_LENGTH
   
   ) ( 

      input    wire[0:WIDTH-1] a,
      input    wire[0:WIDTH-1] b,

      output   wire[0:WIDTH-1] y
   );

   for ( genvar i = 0; i < WIDTH; i = i + 1 ) and( y[i], a[i], b[i]);

endmodule


//------------------------------------------------------------------------------------------------------------
// OR operation of A and B, parameterized with WORD_LENGTH-bit word by default. A simple set of OR gates.
// 
//------------------------------------------------------------------------------------------------------------
module OrOp #(

      parameter WIDTH = `WORD_LENGTH
   
   ) ( 

      input    wire[0:WIDTH-1] a,
      input    wire[0:WIDTH-1] b, 

      output   wire[0:WIDTH-1] y
   );

   for ( genvar i = 0; i < WIDTH; i = i + 1 ) or( y[i], a[i], b[i]);

endmodule


//------------------------------------------------------------------------------------------------------------
// XOR operation of A and B, parameterized with WORD_LENGTH-bit word by default. A simple set of XOR gates.
//
//------------------------------------------------------------------------------------------------------------
module XorOp #(

      parameter WIDTH = `WORD_LENGTH
   
   ) ( 

      input    wire[0:WIDTH-1] a,
      input    wire[0:WIDTH-1] b, 

      output   wire[0:WIDTH-1] y
   );

   for ( genvar i = 0; i < WIDTH; i = i + 1 ) xor( y[i], a[i], b[i]);

endmodule


//------------------------------------------------------------------------------------------------------------
// Two to 1 multiplexer. The multiplexer is parameterized for re-use with different word lengths. The module
// is written in behavioral style. The module is parameterized for the word length. Let the synthesizer do 
// its work. 
//
//------------------------------------------------------------------------------------------------------------
module Mux_2_1 #( 

   parameter WIDTH = `WORD_LENGTH

   ) (

   input  wire[0:WIDTH - 1]   a0,
   input  wire[0:WIDTH - 1]   a1, 
   input  wire                sel, 
   input  wire                enb,

   output reg[0:WIDTH - 1]    y 

   );

   always @(*) begin

      if ( enb == 1'b0 ) begin

         y = 1'b0;

      end else begin
         
         y = ( sel == 1'b0 ) ? a0 : a1;

      end

   end

endmodule 


//------------------------------------------------------------------------------------------------------------
// Four to 1 multiplexer. The multiplexer is parameterized for re-use with different word lengths. The module
// is written in behavioral style. The module is parameterized for the word length. Let the synthesizer do 
// its work. 
//
//------------------------------------------------------------------------------------------------------------
module Mux_4_1 #( 

   parameter WIDTH = `WORD_LENGTH

   ) (

   input  wire[0:WIDTH-1]  a0,
   input  wire[0:WIDTH-1]  a1,
   input  wire[0:WIDTH-1]  a2,
   input  wire[0:WIDTH-1]  a3,
   input  wire[0:1]        sel, 
   input  wire             enb,

   output reg[0:WIDTH-1]   y 

   );
   
  always @(*) begin

      if ( enb == 1'b0 ) begin

         y = 1'b0;

      end else begin

         y =   ( sel == 2'b00 ) ? a0 :
               ( sel == 2'b01 ) ? a1 :
               ( sel == 2'b10 ) ? a2 :
               ( sel == 2'b11 ) ? a3 :
               1'bX;
      end

   end

endmodule 


//------------------------------------------------------------------------------------------------------------
// Eight to 1 multiplexer. The multiplexer is parameterized for re-use with different word lengths. The module
// is written in behavioral style. The module is parameterized for the word length. Let the synthesizer do 
// its work. 
//
//------------------------------------------------------------------------------------------------------------
module Mux_8_1 #( 

   parameter WIDTH = `WORD_LENGTH

   ) (

   input  wire[0:WIDTH-1]  a0,
   input  wire[0:WIDTH-1]  a1,
   input  wire[0:WIDTH-1]  a2,
   input  wire[0:WIDTH-1]  a3,
   input  wire[0:WIDTH-1]  a4,
   input  wire[0:WIDTH-1]  a5,
   input  wire[0:WIDTH-1]  a6,
   input  wire[0:WIDTH-1]  a7,
   input  wire[0:2]        sel, 
   input  wire             enb,

   output reg[0:WIDTH-1]   y 

   );

   always @(*) begin

      if ( enb == 1'b0 ) begin

         y = 1'b0;

      end else begin

         y =   ( sel == 3'b000 ) ? a0 :
               ( sel == 3'b001 ) ? a1 :
               ( sel == 3'b010 ) ? a2 :
               ( sel == 3'b011 ) ? a3 :
               ( sel == 3'b100 ) ? a4 :
               ( sel == 3'b101 ) ? a5 :
               ( sel == 3'b110 ) ? a6 :
               ( sel == 3'b111 ) ? a7 :
               1'bX;
      end

   end
  
endmodule 


//------------------------------------------------------------------------------------------------------------
// Priority encoder - 16 to 4. We return a zero for bit 0 up to a 15 for bit 15 in the input word. The 
// encoder is written in behavioral style. Let the synthesizer do its work.
// 
//------------------------------------------------------------------------------------------------------------
module Encoder_16_4 ( 

   input  wire[0:15] a,
   output wire[0:3]  y

   );

   assign y =  ( a[0]   == 1 ) ? 4'd15 :
               ( a[1]   == 1 ) ? 4'd14 :
               ( a[2]   == 1 ) ? 4'd13 :
               ( a[3]   == 1 ) ? 4'd12 : 
               ( a[4]   == 1 ) ? 4'd11 : 
               ( a[5]   == 1 ) ? 4'd10 :
               ( a[6]   == 1 ) ? 4'd9  :
               ( a[7]   == 1 ) ? 4'd8  :
               ( a[8]   == 1 ) ? 4'd7  :
               ( a[9]   == 1 ) ? 4'd6  :
               ( a[10]  == 1 ) ? 4'd5  :
               ( a[11]  == 1 ) ? 4'd4  :
               ( a[12]  == 1 ) ? 4'd3  :
               ( a[13]  == 1 ) ? 4'd2  :
               ( a[14]  == 1 ) ? 4'd1  :
               ( a[15]  == 1 ) ? 4'd0  :
               4'd0;   

endmodule


//------------------------------------------------------------------------------------------------------------
// Clock divider by two. The module takes the master clock and creates a clock rate divided by two.
//
//------------------------------------------------------------------------------------------------------------
module DivideByTwoUnit ( 

   input  wire clk,
   input  wire rst,
   output reg  hClk

   );

   always @ ( posedge clk ) begin
   
      if ( ~ rst )   hClk <= 0;
      else           hClk <= ~ hClk;

   end

endmodule


//------------------------------------------------------------------------------------------------------------
// Generic Clock divider. The generic clock divider implenents a divider with a configurable divide count.
//
//------------------------------------------------------------------------------------------------------------
module ClkDivideUnit #( 

   parameter DIV = 2

   ) ( 

   input    wire  clk,
   input    wire  rst,
   output   reg   dClk 

   );

   localparam  tCount = ( DIV - 1 );

   reg [0:15]  count;
   wire        tc;

   assign tc = ( count == tCount );

   always @ ( posedge clk ) begin
      
      if       ( ~rst ) count <= 0;
      else if  ( tc )   count <= 0;
      else              count <= count + 1;
   end

   always @ ( posedge clk ) begin
      
      if       ( rst )  dClk <= 0;
      else if  ( tc )   dClk <= ~ dClk;
      
   end

endmodule
