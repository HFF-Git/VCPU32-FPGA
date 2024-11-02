//------------------------------------------------------------------------------------------------------------
//
//  VCPU-32
//
//  Copyright (C) 2022 - 2024 Helmut Fieres, see License file.
//------------------------------------------------------------------------------------------------------------
// This file contains the general register and a family of register files. They feature one or more read 
// ports and one or two write ports. The read operation is an asynchronous operation, the write operation 
// takes place synchronous to the clock signal. In addition. the registers feature  a serial shift capability,
// to implement a read/write JTAG interface.
//
//------------------------------------------------------------------------------------------------------------
`include "defines.vh"


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

   input    wire                        clk, 
   input    wire                        rst,
   input    wire [WORD_LENGTH-1:0]      inSeg,
   input    wire [WORD_LENGTH-1:0]      inOfs,

   output   wire                        found,
   output   wire [WORD_LENGTH-1:0]      outAdr

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
