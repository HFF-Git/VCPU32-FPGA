
//------------------------------------------------------------------------------------------------------------
//
// Incrementer - Testbench
//
//------------------------------------------------------------------------------------------------------------
// This module is the test bench for an incremneter.
//
//------------------------------------------------------------------------------------------------------------
//
// Incrementer - Testbench
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

module IncrementerUnit_TB;

	reg[0:31] 	A_TB;

	wire[0:31]	S_TB;
	wire 					C_TB;


	task setupTest;

		begin

			$dumpfile( "IncrementerUnit_TB.vcd" );
   			$dumpvars( 0, IncrementerUnit_TB );

		end

	endtask

	task applyTest ( 
		
		input [0:31]	a
		
	);

		begin

			A_TB 	= a;
			#10 $display( "A: 0x%h -> S: 0x%h, C: %d", a, S_TB, C_TB );

			if ( C_TB ) begin

				if ( S_TB != 0 ) 	begin $display( "FAIL in %m" ); $finish; end
				else              	begin $display( "PASS" ); end

			end else begin
			
				if ( S_TB != a + 1 ) 	begin $display( "FAIL in %m" ); $finish; end
				else              		begin $display( "PASS" ); end

			end

		end

	endtask

	IncrementerUnit DUT ( .a( A_TB ), .s( S_TB ), .outC( C_TB ));

	initial begin

		setupTest( );

		applyTest( 32'd0 ); 
		applyTest( 32'd10 );
		applyTest( 32'hFFFFFFFF );
   	
   		#50 $finish;
		
	end

endmodule
