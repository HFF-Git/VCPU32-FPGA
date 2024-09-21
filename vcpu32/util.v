//------------------------------------------------------------------------------------------------------------
//
//  VCPU-32
//
//  Copyright (C) 2022 - 2024 Helmut Fieres, see License file.
//------------------------------------------------------------------------------------------------------------
// This file contains several utility modules, such as multiplexers, logic gates and so on. 
//
//------------------------------------------------------------------------------------------------------------
`include "defines.vh"

//------------------------------------------------------------------------------------------------------------
// Two to one multiplexer, parameterized for re-use with different word lengths. The module is written in 
// behavioral style. The module is parameterized for the word length. Let the synthesizer do  its work. 
//
//------------------------------------------------------------------------------------------------------------
module Mux_2_1 #( 

   parameter WIDTH = `WORD_LENGTH

   ) (

   input  wire[WIDTH-1:0]   a0,
   input  wire[WIDTH-1:0]   a1, 
   input  wire              sel, 
   input  wire              enb,

   output reg[WIDTH-1:0]    y 

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
// Four to one multiplexer, parameterized for re-use with different word lengths. The module is written in 
// behavioral style. The module is parameterized for the word length. Let the synthesizer do its work. 
//
//------------------------------------------------------------------------------------------------------------
module Mux_4_1 #( 

   parameter WIDTH = `WORD_LENGTH

   ) (

   input  wire[WIDTH-1:0]  a0,
   input  wire[WIDTH-1:0]  a1,
   input  wire[WIDTH-1:0]  a2,
   input  wire[WIDTH-1:0]  a3,
   input  wire[1:0]        sel, 
   input  wire             enb,

   output reg[WIDTH-1:0]   y 

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
// Eight to 1 multiplexer, parameterized for re-use with different word lengths. The module is written in 
// behavioral style. The module is parameterized for the word length. Let the synthesizer do its work. 
//
//------------------------------------------------------------------------------------------------------------
module Mux_8_1 #( 

   parameter WIDTH = `WORD_LENGTH

   ) (

   input  wire[WIDTH-1:0]  a0,
   input  wire[WIDTH-1:0]  a1,
   input  wire[WIDTH-1:0]  a2,
   input  wire[WIDTH-1:0]  a3,
   input  wire[WIDTH-1:0]  a4,
   input  wire[WIDTH-1:0]  a5,
   input  wire[WIDTH-1:0]  a6,
   input  wire[WIDTH-1:0]  a7,
   input  wire[2:0]        sel, 
   input  wire             enb,

   output reg[WIDTH-1:0]   y 

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
// AND operation of A and B, parameterized with WORD_LENGTH-bit word by default. A simple set of AND gates.
//
//------------------------------------------------------------------------------------------------------------
module AndOp #(

      parameter WIDTH = `WORD_LENGTH
   
   ) ( 

      input    wire[WIDTH-1:0] a,
      input    wire[WIDTH-1:0] b,

      output   wire[WIDTH-1:0] y
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

      input    wire[WIDTH-1:0] a,
      input    wire[WIDTH-1:0] b, 

      output   wire[WIDTH-1:0] y
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

      input    wire[WIDTH-1:0] a,
      input    wire[WIDTH-1:0] b, 

      output   wire[WIDTH-1:0] y
   );

   for ( genvar i = 0; i < WIDTH; i = i + 1 ) xor( y[i], a[i], b[i]);

endmodule