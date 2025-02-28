//------------------------------------------------------------------------------------------------------------
//
// Register File Unit - Testbench
//
//------------------------------------------------------------------------------------------------------------
// This module is the test bench for the register file unit.
//
//------------------------------------------------------------------------------------------------------------
//
// Register Unit - Testbench
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
`include "../hdl/VCPU32.v"

`timescale 1ns / 1ns

module ScanRegFileUnit_TB;

	parameter WIDTH = 32;
	parameter SIZE  = 8;

	reg                       	clk_TB 		= 0;
   	reg                   		rst_TB 		= 0;
	reg                       	write_TB 	= 0;
	reg[0:$clog2( SIZE ) - 1]	wrAddr_TB  	= 0;
   	reg[0:WIDTH-1]    			wrData_TB 	= 0;
   	reg[0:$clog2( SIZE ) - 1]  	rdAddrA_TB 	= 0;
   	reg[0:$clog2( SIZE ) - 1]  	rdAddrB_TB 	= 0;
   	wire[0:WIDTH-1]    			rdDataA_TB 	= 0;
   	wire[0:WIDTH-1]    			rdDataB_TB 	= 0;

	task setupTest;

		begin

		$dumpfile( "ScanRegFileUnit_TB.vcd" );
   		$dumpvars( 0, ScanRegFileUnit_TB );

		end

	endtask

	task applyTest ( );

		begin
	
		end

	endtask

	ScanRegFileUnit DUT ( 	.clk( clk_TB ), 
							.rst( rst_TB ), 
							.write( write_TB ),
							.wrAddr( wrAddr_TB ),
							.wrData( wrData_TB ),
							.rdAddrA( rdAddrA_TB ),
							.rdAddrB( rdAddrB_TB ),
							.rdDataA( rdDataA_TB ),
							.rdDataB( rdDataB_TB ));

	initial begin

 		setupTest( );

		#10		rst_TB = 0;
		#10     rst_TB = 1;
   		
   		#50 $finish;
		
	end

	always begin
		
		#10 clk_TB = ~ clk_TB;
	end

endmodule
