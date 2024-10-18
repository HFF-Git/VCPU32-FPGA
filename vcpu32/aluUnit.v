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
//
//
//
//  ??? combines logic unit and adders...
//------------------------------------------------------------------------------------------------------------
module AluUnit( 

    input  logic[31:0]   valA,
    input  logic[31:0]   valB,

    output logic[31:0]   valR   
);


endmodule


//------------------------------------------------------------------------------------------------------------
//
//
// ??? combines double shift, extr and dep in one module...
//------------------------------------------------------------------------------------------------------------
module ShiftMergeUnit( 

    input  logic[31:0]   valA,
    input  logic[31:0]   valB,
    input  logic[4:0]    pos,
    input  logic[4:0]    len,


    output logic[31:0]   valR

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
// The execte substage is the place where we deal with overflows.
//
// addition signed
// (( ~ a[0] ) & ( ~ b[0] ) & ( s[0] )) | (( a[0] ) & ( b[0] ) & ( ~ s[0] )) 
//
// subtraction signed
// (( ~ a[0] ) & ( b[0] ) & ( s[0] )) | (( a[0] ) & ( ~ b[0] ) & ( ~ s[0] )) 
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
// "extractUnit32" is the logic for the extract operation. A bit field specified by the rightmost position 
// "pos" and a length "len" extending to the left will be extracted. If the sign option is set, the extracted
// bit field is sign extended. This module can also be used to implement a variable sign extension function 
// of a value. It is just a sign extension of a right justified field of "len".
//
//------------------------------------------------------------------------------------------------------------
module extractUnit32( 

    input   logic[31:0]   valIn,
    input   logic[4:0]    pos,
    input   logic[4:0]    len,
    input   logic         sign,

    output  logic[31:0]   valOut

    );

    logic [31:0] temp;

    always @(*) begin

        if (len == 0) begin

            temp = 32'b0;

        end else begin
       
            temp = ( valIn >> (31 - pos )) & ((1 << len) - 1 );

            if ( sign ) begin
                
                case( len )

                    1: valOut = {{31{temp[0]}}, temp[0:0]};
                    2: valOut = {{30{temp[1]}}, temp[1:0]};
                    3: valOut = {{29{temp[2]}}, temp[2:0]};
                    4: valOut = {{28{temp[3]}}, temp[3:0]};
                    5: valOut = {{27{temp[4]}}, temp[4:0]};
                    6: valOut = {{26{temp[5]}}, temp[5:0]};
                    7: valOut = {{25{temp[6]}}, temp[6:0]};
                    8: valOut = {{24{temp[7]}}, temp[7:0]};
                    9: valOut = {{23{temp[8]}}, temp[8:0]};
                    10: valOut = {{22{temp[9]}}, temp[9:0]};
                    11: valOut = {{21{temp[10]}}, temp[10:0]};
                    12: valOut = {{20{temp[11]}}, temp[11:0]};
                    13: valOut = {{19{temp[12]}}, temp[12:0]};
                    14: valOut = {{18{temp[13]}}, temp[13:0]};
                    15: valOut = {{17{temp[14]}}, temp[14:0]};
                    16: valOut = {{16{temp[15]}}, temp[15:0]};
                    17: valOut = {{15{temp[16]}}, temp[16:0]};
                    18: valOut = {{14{temp[17]}}, temp[17:0]};
                    19: valOut = {{13{temp[18]}}, temp[18:0]};
                    20: valOut = {{12{temp[19]}}, temp[19:0]};
                    21: valOut = {{11{temp[20]}}, temp[20:0]};
                    22: valOut = {{10{temp[21]}}, temp[21:0]};
                    23: valOut = {{9{temp[22]}}, temp[22:0]};
                    24: valOut = {{8{temp[23]}}, temp[23:0]};
                    25: valOut = {{7{temp[24]}}, temp[24:0]};
                    26: valOut = {{6{temp[25]}}, temp[25:0]};
                    27: valOut = {{5{temp[26]}}, temp[26:0]};
                    28: valOut = {{4{temp[27]}}, temp[27:0]};
                    29: valOut = {{3{temp[28]}}, temp[28:0]};
                    30: valOut = {{2{temp[29]}}, temp[29:0]};
                    31: valOut = {{1{temp[30]}}, temp[30:0]};
                    32: valOut = temp[31:0];
                    default: valOut = 32'b0; 
                endcase

            end else begin 

                valOut = temp;
            end
        end
    end

endmodule


//------------------------------------------------------------------------------------------------------------
// "depositUnit32" deposits a bit field "valArg" of length "len" into the input argument "valIn" at position
// "pos". The bit field is deposited left of the "pos" argument.
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
