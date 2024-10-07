//------------------------------------------------------------------------------------------------------------
//
//  VCPU-32
//
//  Copyright (C) 2022 - 2024 Helmut Fieres, see License file.
//------------------------------------------------------------------------------------------------------------
// 
//
//
//------------------------------------------------------------------------------------------------------------
`include "defines.vh"


//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------
module AluUnit( 


);


endmodule


//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------
module ShiftMergeUnit( 


);


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
module AluUnit_old (

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
// The logic unit implements the  logical functions of the CPU. The implementation is essentially a lookup 
// table for the function map and a 4:1 multiplexer that selects the respective function result for a bit 
// from the lookup table.
//
//------------------------------------------------------------------------------------------------------------
module logicUnit  #( 

    parameter WIDTH = `WORD_LENGTH

    ) ( 

        input  logic[WIDTH-1:0]   a,
        input  logic[WIDTH-1:0]   b,
        input  logic[0:2]         op,
        output logic[WIDTH-1:0]   y
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
//
//
//------------------------------------------------------------------------------------------------------------
module extractUnit32( 

    input   logic[31:0]   valIn,
    input   logic[4:0]    pos,
    input   logic[4:0]    len,
    input   logic         sign,

    output  logic[31:0]   valOut

    );

    reg [31:0] temp;

    always @(*) begin

        if (len == 0)
            temp = 32'b0;
        else
            temp = ( valIn >> ( 31 - pos )) & ((1 << len) - 1 );

        // ??? sign extension ?
    
    end

    assign valOut = temp;

endmodule


//------------------------------------------------------------------------------------------------------------
//
//
//------------------------------------------------------------------------------------------------------------
module depositUnit32( 

    input   logic[31:0]     valIn,
    input   logic[31-1:0]   valArg,
    input   logic[4:0]      pos,
    input   logic[4:0]      len,
    
    output  logic[31-1:0]   valOut

    );

    reg [31:0] mask, temp;
   
    always @(*) begin

        if ( len == 0 ) begin

            mask = 32'b0;
            temp = valIn;
        
        end else begin
            
            mask = ((1 << len) - 1 ) << ( 31 - pos );
            temp = ( valIn & ~mask ) | ( valArg << (( 31- pos ) & mask ));
        end
    end

    assign valOut = temp;

endmodule


//------------------------------------------------------------------------------------------------------------
// Double Shift Unit. The unit takes two words, A and B, concatenates them and performs a logical shift right
// operation. We implement a barrel shifter type unit using 4 and 2 way multiplexers.
//
// ??? rework ....
//------------------------------------------------------------------------------------------------------------
module doubleShiftUnit64 (

   input    logic[31:0]  a,
   input    logic[31:0]  b,
   input    logic[5:0]   sa,

   output   logic[31:0]  y

   );

   logic[63:0] w1, w2, w3, w4;

   assign w1 = { a, b };
   assign y  = w4[31:0];

   Mux_4_1 #( .WIDTH( 64 )) U0  (   .a0( w1 ), 
                                    .a1( { 8'b0,  w1[63:8 ] } ), 
                                    .a2( { 16'b0, w1[63:16] } ), 
                                    .a3( { 32'b0, w1[63:32] } ),
                                    .sel( sa[5:4] ), 
                                    .enb( 1'b1 ),
                                    .y( w2 ));

   Mux_4_1 #( .WIDTH( 64 )) U1  (   .a0( w2 ), 
                                    .a1( { 2'b0, w2[63:2] } ), 
                                    .a2( { 4'b0, w2[63:4] } ), 
                                    .a3( { 6'b0, w2[63:6] } ), 
                                    .sel( sa[3:2] ),
                                    .enb( 1'b1 ), 
                                    .y( w3 ));

   Mux_2_1 #( .WIDTH( 64 )) U2  (   .a0( w3 ), 
                                    .a1( { 1'b0, w3[63:1] } ), 
                                    .sel( sa[0] ),
                                    .enb( 1'b1 ), 
                                    .y( w4 ));

endmodule



