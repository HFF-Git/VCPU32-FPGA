//------------------------------------------------------------------------------------------------------------
//
// Shift/Merge Decode Unit -- Testbench
//
//------------------------------------------------------------------------------------------------------------
// The shift merge decode unit takes an EXTRA, DEP or DSR instruction and produces teh control signals for 
// the shift/merge unit.
//
//------------------------------------------------------------------------------------------------------------
//
// Shift/Merge Decode Unit -- Testbench
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

`timescale 1ns/1ns

module ShiftMergeDecode_TB;

	reg			clock_TB;
	reg[0:31]	instr_TB;
	reg[0:4]	shamtIn_TB;
	
	wire[0:4]   shamtOut_TB;
	wire[0:4]   posLeft_TB;
	wire[0:4]   posRight_TB;
	

	task setupTest;

		begin

		$dumpfile( "ShiftMergeDecode_TB.vcd" );
   		$dumpvars( 0, ShiftMergeDecode_TB );

		end

	endtask

	task applyTest ( );

		begin
	
		end

	endtask

	ShiftMergeDecode DUT ( 

		.instr( instr_TB ), 
		.saReg( shamtIn_TB ), 
		.sa( shamtOut_TB ), 
		.pl( posLeft_TB ), 
		.pr( posRight_TB )
	);
	
	initial begin

 		setupTest( );
   		
   		instr_TB 	= { 6'o12, 3'o3, 5'd10, 5'd19, 1'b0, 1'b0, 3'o4 };
 		shamtIn_TB  = 5'd10;
 		#10 $display( "Instr: 0%h, SAREG: 0x%h -> SA: %d, PR: %d, PL: %d", instr_TB, shamtIn_TB, shamtOut_TB, posRight_TB, posLeft_TB );	

 		instr_TB 	= { 6'o12, 3'o3, 5'd10, 5'd31, 1'b0, 1'b0, 3'o4 };
		shamtIn_TB  = 5'd12;
 		#10 $display( "Instr: 0%h, SAREG: 0x%h -> SA: %d, PR: %d, PL: %d", instr_TB, shamtIn_TB, shamtOut_TB, posRight_TB, posLeft_TB );	

   		#50 $finish;
		
	end

endmodule
