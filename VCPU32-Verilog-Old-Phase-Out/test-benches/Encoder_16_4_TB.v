//------------------------------------------------------------------------------------------------------------
//
// Encoder_16_4 - Testbench
//
//------------------------------------------------------------------------------------------------------------
// This module is the test bench for the 16 to 4 encoder.
//
//------------------------------------------------------------------------------------------------------------
//
// Encoder_16_4 - Testbench
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

module Encoder_16_4_TB;

	reg[0:15] 	A_TB = 0;

	wire[0:3]  	Y_TB;

	task setupTest;

		begin

		$dumpfile( "Encoder_16_4_TB.vcd" );
   		$dumpvars( 0, Encoder_16_4_TB );

		end

	endtask

	task applyTest( 

		input [0:15] a

		);

		begin

			A_TB = a;
			#10 $display( "A: 0x%h -> Y: %d", A_TB, Y_TB );
	
		end

	endtask
	
	Encoder_16_4 DUT ( .a( A_TB ), .y( Y_TB ));

	initial begin

		setupTest( );

 		applyTest( 16'h8000 );
		applyTest( 16'h4000 );
		applyTest( 16'h2000 );
		applyTest( 16'h1000 );
		applyTest( 16'h0800 );
		applyTest( 16'h0400 );
		applyTest( 16'h0200 );
		applyTest( 16'h0100 );
		applyTest( 16'h0080 );
		applyTest( 16'h0040 );
		applyTest( 16'h0020 );
		applyTest( 16'h0010 );
		applyTest( 16'h0008 );
		applyTest( 16'h0004 );
		applyTest( 16'h0002 );
		applyTest( 16'h0001 );

   		#10 $finish;
		
	end

endmodule
