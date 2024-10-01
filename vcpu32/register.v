//------------------------------------------------------------------------------------------------------------
//
//  VCPU-32
//
//  Copyright (C) 2022 - 2024 Helmut Fieres, see License file.
//------------------------------------------------------------------------------------------------------------
// 
//
//------------------------------------------------------------------------------------------------------------
`include "defines.vh"

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

    input    wire                       inClk,
    input    wire                       inRst,
    input    wire[`WORD_LENGTH-1:0]     d,

    output   reg[`WORD_LENGTH-1:0]      q,
    
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

