//------------------------------------------------------------------------------------------------------------
//
// Logical AND - Testbench
//
//------------------------------------------------------------------------------------------------------------
// This module is the test the logical AND operation.
//
//------------------------------------------------------------------------------------------------------------
//
// Logical AND - Testbench
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

module AndOp_TB;

	reg[0:31] 	A_TB 	= 0;
	reg[0:31] 	B_TB 	= 0;
	
	wire[0:31]  Y_TB;

	task setupTest;

		begin

		$dumpfile( "AndOp_TB.vcd" );
   		$dumpvars( 0, AndOp_TB );

		end

	endtask

	task applyTest ( );

		begin
	
		end

	endtask
	
	AndOp DUT ( .a( A_TB ), .b( B_TB ), .y( Y_TB ));

	initial begin

 		setupTest( );

   		A_TB 	= 32'h00F010FF;
   		B_TB 	= 32'h0;
   		#10 $display( "A: %h, and B: %h -> Y: %h", A_TB, B_TB, Y_TB );

   		A_TB 	= 32'h00F010FF;
   		B_TB 	= 32'hF0FFFFFF;
   		#10 $display( "A: %h, and B: %h -> Y: %h", A_TB, B_TB, Y_TB );

   		A_TB 	= 32'h07F010FF;
   		B_TB 	= 32'h70FFF000;
   		#10 $display( "A: %h, and B: %h -> Y: %h", A_TB, B_TB, Y_TB );

   		#50
   		
   		$finish;
		
	end

endmodule
