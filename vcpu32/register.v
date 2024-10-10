//------------------------------------------------------------------------------------------------------------
//
//  VCPU-32
//
//  Copyright (C) 2022 - 2024 Helmut Fieres, see License file.
//------------------------------------------------------------------------------------------------------------
// This file contains the general register and a family of register files. They feature one or more read 
// ports and one or two write ports. The read operation is an asynchronous operation, the write operation 
// takes place synchronous to the clock signal. In addtion. the registers feature  a serial shift capability,
// to implement a read/write JTAG interface.
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

    input   logic                       clk,
    input   logic                       rst,
    inout   logic                       wEnable,
    input   logic[`WORD_LENGTH-1:0]     d,

    output   logic[`WORD_LENGTH-1:0]    q,
    
    input    logic                      sClock,
    input    logic                      sEnable,
    input    logic                      sIn,
    output   logic                      sOut

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

         q     <= { q[`WORD_LENGTH-2:0], sIn };
         sOut  <= q[`WORD_LENGTH-1];
      end 

   end

endmodule


//------------------------------------------------------------------------------------------------------------
// Register file unit for one read and one write port. It is the building block for the general register set
// and segment register set. The register file unit supports two modes. The normal mode is a register with a
// parallel input and output, set at the positive edge of the clock. In addition, there is a serial interface
// for reading the registers as a serial bit stream for analysis and diagnostics. As the bit vector could be
// quite large, a simple state machine will shift the data on a word by basis.
//
// ??? carefully check the JTAG logic..
//------------------------------------------------------------------------------------------------------------
module register_file_1R_1W #( 

    parameter SIZE  = 8,
    parameter WIDTH = `WORD_LENGTH

    ) (

    input  logic                    clk,                                   
    input  logic                    rst,                                    

    input  logic [$clog2(SIZE)-1:0] readAddr1,          
    output logic [WIDTH-1:0]        readData1,          

    input  logic                    writeEnable1,                        
    input  logic [$clog2(SIZE)-1:0] writeAddr1,        
    input  logic [WIDTH-1:0]        writeData1,

    input  logic                    sClock,
    input  logic                    sEnable,
    input  logic                    sIn,
    output logic                    sOut            
    
    );

    reg [WIDTH-1:0]                 regFile [$clog2(SIZE)-1:0];
    reg [$clog2(SIZE)-1:0]          shiftAdr;
    reg [SIZE-1:0]                  shiftReg;
    reg [$clog2(WIDTH)-1:0]         shiftCnt;

    integer                         i;

    assign zeroValue = {WIDTH{1'b0}};

    always @(posedge clk or negedge rst) begin

        if ( ~ rst ) begin
            
            for ( i = 0; i < SIZE; i = i + 1 ) begin
                regFile[i] <= zeroValue;
            end
        end else begin
            
            if ( writeEnable1 ) begin

                if ( writeAddr1 != 0 ) regFile[writeAddr1] <= writeData1;
            end
        end
    end

    always @(*) begin
        
        readData1 = ( readAddr1 == 0 ) ? regFile[ readAddr1 ] : zeroValue;
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
                shiftReg <= { shiftReg[30:0], sIn };
                shiftCnt <= shiftCnt + 1; 

            end else begin

                regFile[ shiftAdr ]  <= { shiftReg[30:0], sIn };
                shiftCnt             <= 0;

                if ( shiftAdr < SIZE - 1 )  shiftAdr <= shiftAdr + 1;
                else                        shiftAdr <= 0;
         
            end

        end
   
    end

endmodule


//------------------------------------------------------------------------------------------------------------
// Register file unit for two read and one write port. It is the building block for the general register set
// and segment register set. The register file unit supports two modes. The normal mode is a register with a
// parallel input and output, set at the positive edge of the clock. In addition, there is a serial interface
// for reading the registers as a serial bit stream for analysis and diagnostics. As the bit vector could be
// quite large, a simple state machine will shift the data on a word by basis.
//
//------------------------------------------------------------------------------------------------------------
module register_file_2R_1W #( 

    parameter SIZE  = 16,
    parameter WIDTH = `WORD_LENGTH

    ) (

    input  logic                    clk,                   
    input  logic                    rst,                 

    input  logic [$clog2(SIZE)-1:0] readAddr1,       
    output logic [WIDTH-1:0]        readData1,      

    input logic [$clog2(SIZE)-1:0]  readAddr2,       
    output reg [WIDTH-1:0]          readData2,      

    input logic                     writeEnable1,          
    input logic [$clog2(SIZE)-1:0]  writeAddr1,      
    input logic [WIDTH-1:0]         writeData1,

    input    wire                   sClock,
    input    wire                   sEnable,
    input    wire                   sIn,
    output   reg                    sOut   
  
    );

    reg [WIDTH-1:0]                 regFile [$clog2(SIZE)-1:0];
    reg [$clog2(SIZE)-1:0]          shiftAdr;
    reg [SIZE-1:0]                  shiftReg;
    reg [$clog2(WIDTH)-1:0]         shiftCnt;

    integer                         i;

    assign zeroValue = {WIDTH{1'b0}};

    always @( posedge clk or negedge rst ) begin

        if ( ~ rst ) begin

            for ( i = 0; i < SIZE; i = i + 1 ) begin
                regFile[i] <= zeroValue;
            end
        
        end else begin
            
            if ( writeEnable1 ) begin
                if ( writeAddr1 != 0 ) regFile[ writeAddr1 ] <= writeData1;
            end
        end
    end

    always @(*) begin

        readData1 = ( readAddr1 != 0 ) ? regFile[ readAddr1 ] : zeroValue;
        readData2 = ( readAddr2 != 0 ) ? regFile[ readAddr2 ] : zeroValue;
    end

endmodule


//------------------------------------------------------------------------------------------------------------
// Register file unit for three read and two write ports. The read operation is an asynchronous operation.
// The write operation is synchronous. When the two wrote addresses are the same, write port 1 has priority.
// The register file unit supports two modes. The normal mode is a register  with a parallel input and output,
// set at the positive edge of the clock. In addition, there is a serial interface for reading the registers 
// as a serial bit stream for analysis and diagnostics. As the bit vector could be quite large, a simple state
// machine will shift the data on a word by word basis. 
//
//------------------------------------------------------------------------------------------------------------
module register_file_3R_2W #( 

    parameter SIZE  = 16,
    parameter WIDTH = `WORD_LENGTH

    ) (

    input  logic                    clk,                   
    input  logic                    rst,                 

    input  logic [$clog2(SIZE)-1:0] readAddr1,       
    output logic [WIDTH-1:0]        readData1,      

    input logic [$clog2(SIZE)-1:0]  readAddr2,       
    output reg [WIDTH-1:0]          readData2,      

    input logic [$clog2(SIZE)-1:0]  readAddr3,       
    output logic [WIDTH-1:0]        readData3,      
     
    input logic                     writeEnable1,          
    input logic [$clog2(SIZE)-1:0]  writeAddr1,      
    input logic [WIDTH-1:0]         writeData1,     

    input logic                     writeEnable2,          
    input logic [$clog2(SIZE)-1:0]  writeAddr2,      
    input logic [WIDTH-1:0]         writeData2,

    input    wire                   sClock,
    input    wire                   sEnable,
    input    wire                   sIn,
    output   reg                    sOut      
    
    );
    
    reg [WIDTH-1:0]                 regFile [$clog2(SIZE)-1:0];
    reg [$clog2(SIZE)-1:0]          shiftAdr;
    reg [SIZE-1:0]                  shiftReg;
    reg [$clog2(WIDTH)-1:0]         shiftCnt;

    integer                         i;

    assign zeroValue = {WIDTH{1'b0}};

    always @( posedge clk or negedge rst ) begin

        if ( ~ rst ) begin

            for ( i = 0; i < SIZE; i = i + 1 ) begin
                regFile[i] <= zeroValue;
            end
        
        end else begin
            
            if ( writeEnable1 ) begin
                if ( writeAddr1 != 0 ) regFile[ writeAddr1 ] <= writeData1;
            end

            if ( writeEnable2 && ( ! ( writeEnable1 && ( writeAddr1 == writeAddr2 )))) begin
                if ( writeAddr1 != 0 ) regFile[ writeAddr2 ] <= writeData2;
            end
        end
    end

    always @(*) begin

        readData1 = ( readAddr1 != 0 ) ? regFile[ readAddr1 ] : zeroValue;
        readData2 = ( readAddr2 != 0 ) ? regFile[ readAddr2 ] : zeroValue;
        readData3 = ( readAddr2 != 0 ) ? regFile[ readAddr3 ] : zeroValue;
    end

endmodule
