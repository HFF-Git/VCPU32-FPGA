//------------------------------------------------------------------------------------------------------------
//
//  VCPU-32
//
//  Copyright (C) 2022 - 2024 Helmut Fieres, see License file.
//------------------------------------------------------------------------------------------------------------
// This file contains a family of register files. They feature one or more read ports and one or two write
// ports. The read operation is an asynchronous operation, the write operation takles place synchronous to
// the clock signal.
//
//------------------------------------------------------------------------------------------------------------
`include "defines.vh"


//------------------------------------------------------------------------------------------------------------
//
//
//------------------------------------------------------------------------------------------------------------
module register_file_1R_1W #( 

    parameter SIZE  = 8,
    parameter WIDTH = `WORD_LENGTH

    ) (

    input  logic clk,                                   
    input  logic rst,                                    

    input  logic [$clog2(SIZE)-1:0] readAddr1,          
    output logic [WIDTH-1:0]        readData1,          

    input  logic                    writeEnable1,                        
    input  logic [$clog2(SIZE)-1:0] writeAddr1,        
    input  logic [WIDTH-1:0]        writeData1            
    
    );

    reg     [WIDTH-1:0] regFile [$clog2(SIZE)-1:0];
    integer             i;

    assign zeroValue = {WIDTH{1'b0}};

    always @(posedge clk or negedge rst) begin

        if (!rst) begin
            
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

endmodule

//------------------------------------------------------------------------------------------------------------
//
//
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
    input logic [WIDTH-1:0]         writeData1   
  
    );

    reg [WIDTH-1:0] regFile [$clog2(SIZE)-1:0];
    integer         i;

    assign zeroValue = {WIDTH{1'b0}};

    always @( posedge clk or negedge rst ) begin

        if ( !rst ) begin

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
//
//
// write port one has higher pri
// Write port 2 writes if write_enable_1 did not write to the same register
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
    input logic [WIDTH-1:0]         writeData2      
    
    );

    reg [WIDTH-1:0] regFile [$clog2(SIZE)-1:0];
    integer         i;

    assign zeroValue = {WIDTH{1'b0}};

    always @( posedge clk or negedge rst ) begin

        if ( !rst ) begin

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

