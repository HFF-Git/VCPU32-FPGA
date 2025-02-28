//------------------------------------------------------------------------------------------------------------
//
// TestCondUnit - Testbench
//
//------------------------------------------------------------------------------------------------------------
// This module is the test bench for the conditional test unit.
//
//------------------------------------------------------------------------------------------------------------
//
// TestCondUnit - Testbench
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

module TestCondUnit_TB;

	reg[0:31] 	A_TB 	= 0;
	reg[0:2]	OP_TB 	= 0;

	wire		Y_TB;

	task setupTest;

		begin

		$dumpfile( "TestCondUnit_TB.vcd" );
   		$dumpvars( 0, TestCondUnit_TB );

		end

	endtask

	task applyTest ( 
		
		input [0:31] 	a, 
		input [0:2] 	op,

		input 			res 

		// ??? could also add the expected result as a paramater and get rid of the assertTest task.
		
		);

		begin

			A_TB 	= a;
			OP_TB 	= op;
			#10 $display( "A: 0x%h, OP: %d -> Y: 0x%h", a, op, res );

			if ( Y_TB != res ) 	begin $display( "FAIL in %m" ); $finish; end
			else             	begin $display( "PASS" ); end

		end
	
	endtask
	
	TestCondUnit DUT ( .a( A_TB ), .op( OP_TB ), .y( Y_TB ));

	initial begin

		setupTest( );

		applyTest( 32'h0, 0, 1 );

		applyTest( 32'h0, 1, 0 );
		applyTest( 32'h1, 1, 1 );

		applyTest( 32'hF010FF, 2, 1 );
		applyTest( 32'h7010FF, 2, 0 );

		applyTest( 32'hF010FF, 3, 0 );
		applyTest( 32'h7010FF, 3, 1 );

		applyTest( 32'h0, 4, 1 );
		applyTest( 32'h7010FF, 4, 0 );

		applyTest( 32'hF010FF, 5, 0 );
		applyTest( 32'h7010FF, 5, 1 );

		applyTest( 32'hF010FF, 6, 0 );
		applyTest( 32'hF010FE, 6, 1 );
		
		applyTest( 32'hF010FE, 7, 0 );
		applyTest( 32'hF010FF, 7, 1 );

   		#10 $finish;
		
	end

endmodule
