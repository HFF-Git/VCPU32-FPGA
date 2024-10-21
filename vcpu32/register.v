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
// A general register. The register can be instantiated with different field widths. The read operation is 
// an asynchronous operation. The write operation is synchronous.
//
//------------------------------------------------------------------------------------------------------------
module Register #( 

    parameter WIDTH = `WORD_LENGTH

    ) (

    input   logic                       clk,
    input   logic                       rst,
    inout   logic                       wEnable,
    input   logic[`WORD_LENGTH-1:0]     d,

    output  logic[`WORD_LENGTH-1:0]     q

    );

    always @( posedge clk or negedge rst ) begin

        if ( ! rst ) begin
            
            q   <= 0;

        end else begin            
            
            if ( wEnable ) q   <= d;
        
        end 
    
    end

endmodule

//------------------------------------------------------------------------------------------------------------
// Register file unit for one read and one write port. The read operation is an asynchronous operation.
// The write operation is synchronous.
//
//------------------------------------------------------------------------------------------------------------
module RegisterFile_1R_1W #( 

    parameter SIZE  = 8,
    parameter WIDTH = `WORD_LENGTH

    ) (

    input  logic                    clk,                                   
    input  logic                    rst,                                    

    input  logic [$clog2(SIZE)-1:0] readAddr1,          
    output logic [WIDTH-1:0]        readData1,          

    input  logic                    writeEnable1,                        
    input  logic [$clog2(SIZE)-1:0] writeAddr1,        
    input  logic [WIDTH-1:0]        writeData1

    );

    reg [WIDTH-1:0]                 regFile [$clog2(SIZE)-1:0];
    reg [$clog2(SIZE)-1:0]          shiftAdr;
    reg [SIZE-1:0]                  shiftReg;
    reg [$clog2(WIDTH)-1:0]         shiftCnt;

    integer                         i;
   
    localparam                      ZERO = {WIDTH{1'b0}};

    always @(posedge clk or negedge rst) begin

        if ( ~ rst ) begin
            
            for ( i = 0; i < SIZE; i = i + 1 ) begin
                regFile[i] <= ZERO;
            end
        end else begin
            
            if ( writeEnable1 ) begin

                if ( writeAddr1 != 0 ) regFile[writeAddr1] <= writeData1;
            end
        end
    end

    always @(*) begin
        
        readData1 = ( readAddr1 == 0 ) ? regFile[ readAddr1 ] : ZERO;
    end

endmodule


//------------------------------------------------------------------------------------------------------------
// Register file unit for two read and one write port. The read operation is an asynchronous operation.
// The write operation is synchronous.
//
//------------------------------------------------------------------------------------------------------------
module RegisterFile_2R_1W #( 

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

    localparam                      ZERO = {WIDTH{1'b0}};
  
    always @( posedge clk or negedge rst ) begin

        if ( ~ rst ) begin

            for ( i = 0; i < SIZE; i = i + 1 ) begin
                regFile[i] <= ZERO;
            end
        
        end else begin
            
            if ( writeEnable1 ) begin
                if ( writeAddr1 != 0 ) regFile[ writeAddr1 ] <= writeData1;
            end
        end
    end

    always @(*) begin

        readData1 = ( readAddr1 != 0 ) ? regFile[ readAddr1 ] : ZERO;
        readData2 = ( readAddr2 != 0 ) ? regFile[ readAddr2 ] : ZERO;
    end

endmodule


//------------------------------------------------------------------------------------------------------------
// Register file unit for three read and two write ports. The read operation is an asynchronous operation.
// The write operation is synchronous. When the two write addresses are the same, write port 1 has priority.
//
//------------------------------------------------------------------------------------------------------------
module RegisterFile_3R_2W #( 

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
    input logic [WIDTH-1:0]         writeData2

    );
    
    reg [WIDTH-1:0]                 regFile [$clog2(SIZE)-1:0];
    reg [$clog2(SIZE)-1:0]          shiftAdr;
    reg [SIZE-1:0]                  shiftReg;
    reg [$clog2(WIDTH)-1:0]         shiftCnt;

    integer                         i;
    
    localparam                      ZERO = {WIDTH{1'b0}};

    always @( posedge clk or negedge rst ) begin

        if ( ~ rst ) begin

            for ( i = 0; i < SIZE; i = i + 1 ) begin
                regFile[i] <= ZERO;
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

        readData1 = ( readAddr1 != 0 ) ? regFile[ readAddr1 ] : ZERO;
        readData2 = ( readAddr2 != 0 ) ? regFile[ readAddr2 ] : ZERO;
        readData3 = ( readAddr2 != 0 ) ? regFile[ readAddr3 ] : ZERO;
    end

endmodule
