//------------------------------------------------------------------------------------------------------------
//
// Shift Merge Mask Unit - Testbench
//
//------------------------------------------------------------------------------------------------------------
// This module is the test bench for the shift merge mask unit. This unit is used for in the shift merge
// unit to build the mask for the masking operation.
//
//------------------------------------------------------------------------------------------------------------
//
// Shift Merge Mask Unit - Testbench
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

`timescale 10ns / 1ns

`define assert_TB ( isVal, beVal ) if ( isVal != beVal ) begin $display ( "FAIL in %m, is != to be" ); $finish; end else $display ( "PASS" );
	
module ShiftMergeMask_32bit_TB;

	reg[0:4] 	L_TB 	= 0;
	reg[0:4] 	R_TB 	= 0;
	
	wire[0:31]  Y_TB;

	task setupTest;

		begin

		$dumpfile( "ShiftMergeMask_32bit_TB.vcd" );
   		$dumpvars( 0, ShiftMergeMask_32bit_TB );

		end

	endtask

	task applyTest ( );

		begin
	
		end

	endtask
	
	ShiftMergeMask_32bit DUT ( .lft( L_TB ), .rht( R_TB ), .y( Y_TB ));

	initial begin

 		setupTest( );

   		// ??? need a lot of instruction examples ...

   		L_TB 	= 5'd0;
   		R_TB 	= 5'd10;
   		#10 $display( "L: %d, R: %d -> Y: 0x%h", L_TB, R_TB, Y_TB );

   		// `assert_TB( Y_TB,  24'hFFFFFF )
      		
   		#10 $finish;
		
	end

endmodule
