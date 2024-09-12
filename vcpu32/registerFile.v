//------------------------------------------------------------------------------------------------------------
//
//  VCPU-32
//
//  Copyright (C) 2022 - 2024 Helmut Fieres, see License file.
//------------------------------------------------------------------------------------------------------------
// 
// - contains a lot of modules in one file...
// - test benches are however separate...
//
//
//------------------------------------------------------------------------------------------------------------


//
// General register file .....
//
// Asynchronous read
// write with priority selection
//


//------------------------------------------------------------------------------------------------------------
//
//
//------------------------------------------------------------------------------------------------------------
module register_file_16_32_3_2 (

    input logic clk,                   // Clock signal
    input logic rst_n,                 // Active low reset

    // Read port 1
    input logic [3:0] read_addr_1,      // Read address for port 1
    output logic [31:0] read_data_1,     // Read data for port 1

    // Read port 2
    input logic [3:0] read_addr_2,      // Read address for port 2
    output reg [31:0] read_data_2,     // Read data for port 2

    // Read port 3
    input logic [3:0] read_addr_3,      // Read address for port 3
    output logic [31:0] read_data_3,     // Read data for port 3

    // Write port 1
    input logic write_enable_1,         // Write enable for port 1
    input logic [3:0] write_addr_1,     // Write address for port 1
    input logic [31:0] write_data_1,    // Write data for port 1

    // Write port 2
    input logic write_enable_2,         // Write enable for port 2
    input logic [3:0] write_addr_2,     // Write address for port 2
    input logic [31:0] write_data_2     // Write data for port 2
);

    // 16 registers, each 32 bits wide
    reg [31:0] reg_file [15:0];

    integer i;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            for (i = 0; i < 16; i = i + 1) begin
                reg_file[i] <= 32'b0;
            end
        
        end else begin
            
            // Write port 1 has higher priority
            if (write_enable_1) begin
                reg_file[write_addr_1] <= write_data_1;
            end

            // Write port 2 writes if write_enable_1 did not write to the same register
            if (write_enable_2 && !(write_enable_1 && (write_addr_1 == write_addr_2))) begin
                reg_file[write_addr_2] <= write_data_2;
            end

        end
    end

    always @(*) begin
        read_data_1 = reg_file[read_addr_1];
    end

    always @(*) begin
        read_data_2 = reg_file[read_addr_2];
    end

    always @(*) begin
        read_data_3 = reg_file[read_addr_3];
    end

endmodule

//------------------------------------------------------------------------------------------------------------
//
//
//------------------------------------------------------------------------------------------------------------
module register_file_8_16_1_1 (

    input logic clk,                   // Clock signal
    input logic rst_n,                 // Active low reset

    input logic [2:0] read_addr_1,      // Read address for port 1
    output logic [31:0] read_data_1,     // Read data for port 1

    input logic write_enable_1,         // Write enable for port 1
    input logic [2:0] write_addr_1,     // Write address for port 1
    input logic [31:0] write_data_1    // Write data for port 1
);

    // 8 registers, each 16 bits wide
    reg [31:0] reg_file [7:0];

    integer i;

    // Reset logic (reset all registers to 0)
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            
            for (i = 0; i < 8; i = i + 1) begin
                reg_file[i] <= 32'b0;
            end

        end else begin
            
            if (write_enable_1) begin
                reg_file[write_addr_1] <= write_data_1;
            end

        end
    end

    always @(*) begin
        read_data_1 = reg_file[read_addr_1];
    end

endmodule

