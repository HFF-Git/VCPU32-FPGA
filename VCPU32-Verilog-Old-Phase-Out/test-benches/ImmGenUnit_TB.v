//------------------------------------------------------------------------------------------------------------
//
// CPU24 Instrcution Immediate Gen Unit - Testbench
//
//------------------------------------------------------------------------------------------------------------
// This module is the test bench for the imkediate value generation unit.
//
//------------------------------------------------------------------------------------------------------------
//
// CPU24 Instrcution Immediate Gen Unit - Testbench
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
	
module ImmGenUnit_TB;

	reg[0:31] 	I_TB 	= 0;
	
	wire[0:31]  Y_TB;

	task setupTest;

		begin

		$dumpfile( "ImmGenUnit_TB.vcd" );
   		$dumpvars( 0, ImmGenUnit_TB );

		end

	endtask

	task applyTest ( );

		begin
	
		end

	endtask
	
	ImmGenUnit DUT ( .instr( I_TB ), .y( Y_TB ));

	initial begin

 		setupTest( );

   		// ??? need a lot of instruction examples ...

   		I_TB 	= 32'h0;
   		#10 $display( "I: 0x%h -> Y: 0x%h", I_TB, Y_TB );

   		// `assert_TB( Y_TB,  24'hFFFFFF )
      		
   		#10 $finish;
		
	end

endmodule
