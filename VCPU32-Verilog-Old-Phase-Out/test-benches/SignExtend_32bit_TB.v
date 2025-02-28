//------------------------------------------------------------------------------------------------------------
//
// Sign Extension Unit - Testbench
//
//------------------------------------------------------------------------------------------------------------
// This module is the test bench for the sign extend unit.
//
//------------------------------------------------------------------------------------------------------------
//
// Sign Extension Unit - Testbench
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

`define assert_TB( isVal, toBeVal ) \
	if ( isVal != toBeVal ) begin $display( "FAIL in %m" ); $finish; end \
	else                    begin $display( "PASS" ); end

module SignExtend_32bit_TB;

	reg[0:31] 	A_TB 	= 0;
	reg[0:4]	POS_TB 	= 0;

	wire[0:31]  Y_TB;

	task setupTest;

		begin

		$dumpfile( "SignExtend_32bit_TB.vcd" );
   		$dumpvars( 0, SignExtend_32bit_TB );

		end

	endtask

	task applyTest ( );

		begin
	
		end

	endtask
	
	SignExtend_32bit DUT ( .a( A_TB ), .pos( POS_TB ), .y( Y_TB ));

	initial begin

		setupTest( );
 		
   		A_TB 	= 32'h0000FF;
   		POS_TB 	= 16;
   		#10 $display( "A: 0x%h, OP: %d -> Y: 0x%h", A_TB, POS_TB, Y_TB );
   		`assert_TB ( Y_TB,  32'hFFFFFF )

   		#50
   		
   		$finish;
		
	end

endmodule
