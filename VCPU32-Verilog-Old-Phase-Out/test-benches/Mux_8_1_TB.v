//------------------------------------------------------------------------------------------------------------
//
// Multiplexer 8 to 1 Testbench
//
//------------------------------------------------------------------------------------------------------------
// This module is the test for the 8 input multiplexer.
//
//------------------------------------------------------------------------------------------------------------
//
// Multiplexer 8 to 1 Testbench
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

module Mux_8_1_TB;

	reg[0:31] 	A0_TB 	= 32'h010101;
	reg[0:31] 	A1_TB 	= 32'h020202;
	reg[0:31] 	A2_TB 	= 32'h030303;
	reg[0:31] 	A3_TB 	= 32'h040404;
	reg[0:31] 	A4_TB 	= 32'h050505;
	reg[0:31] 	A5_TB 	= 32'h060606;
	reg[0:31] 	A6_TB 	= 32'h070707;
	reg[0:31] 	A7_TB 	= 32'h080808;
	reg[0:2]	SEL_TB 	= 0;
	reg			ENB_TB	= 1;
	wire[0:31]  Y_TB;

	task setupTest;

		begin

		$dumpfile( "Mux_8_1_TB.vcd" );
   		$dumpvars( 0, Mux_8_1_TB );

		end

	endtask

	task applyTest ( );

		begin
	
		end

	endtask

	Mux_8_1 DUT ( 

		.a0( A0_TB ), 
		.a1( A1_TB ), 
		.a2( A2_TB ), 
		.a3( A3_TB ), 
		.a4( A4_TB ), 
		.a5( A5_TB ), 
		.a6( A6_TB ), 
		.a7( A7_TB ), 
		.sel( SEL_TB ), 
		.enb( ENB_TB ),
		.y( Y_TB ));

	initial begin

 		setupTest( );

   		SEL_TB = 0;
   		#10 $display( "SEL: %h, A0: %h -> Y: %h", SEL_TB, A0_TB, Y_TB );

   		SEL_TB = 1;
   		#10 $display( "SEL: %h, A1: %h -> Y: %h", SEL_TB, A1_TB, Y_TB );

   		SEL_TB = 2;
   		#10 $display( "SEL: %h, A2: %h -> Y: %h", SEL_TB, A2_TB, Y_TB );

   		SEL_TB = 3;
   		#10 $display( "SEL: %h, A3: %h -> Y: %h", SEL_TB, A3_TB, Y_TB );

   		SEL_TB = 4;
   		#10 $display( "SEL: %h, A4: %h -> Y: %h", SEL_TB, A4_TB, Y_TB );

   		SEL_TB = 5;
   		#10 $display( "SEL: %h, A5: %h -> Y: %h", SEL_TB, A5_TB, Y_TB );

   		SEL_TB = 6;
   		#10 $display( "SEL: %h, A6: %h -> Y: %h", SEL_TB, A6_TB, Y_TB );

   		SEL_TB = 7;
   		#10 $display( "SEL: %h, A7: %h -> Y: %h", SEL_TB, A7_TB, Y_TB );

   		#100
   		
   		$finish;
		
	end

endmodule
