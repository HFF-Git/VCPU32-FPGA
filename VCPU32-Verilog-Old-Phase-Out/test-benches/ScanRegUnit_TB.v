//------------------------------------------------------------------------------------------------------------
//
// Register Unit - Testbench
//
//------------------------------------------------------------------------------------------------------------
// This module is the test bench for the register unit.
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

module ScanRegUnit_TB;

	reg     				clk_TB 	= 0;
   	reg						rst_TB  = 0;
   	reg[0:`WORD_LENGTH-1]  	d_TB	= 0;

   	wire[0:`WORD_LENGTH-1]	q_TB;

	task setupTest;

		begin

		$dumpfile( "ScanRegUnit_TB.vcd" );
   		$dumpvars( 0, ScanRegUnit_TB );

		end

	endtask

	task applyTest ( );

		begin
	
		end

	endtask

	ScanRegUnit DUT ( .clk( clk_TB ), .rst( rst_TB ), .d( d_TB ), .q( q_TB ));

	initial begin

 		setupTest( );

		#10		rst_TB = 0;
		#10     rst_TB = 1;
   		
		#10 d_TB = 1;

		#10 d_TB = 0;


   		#50
   		
   		$finish;
		
	end

	always begin
		
		#10 clk_TB = ~ clk_TB;
	end

endmodule
