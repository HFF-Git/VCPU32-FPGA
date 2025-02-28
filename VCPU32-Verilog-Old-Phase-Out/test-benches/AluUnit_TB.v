
//------------------------------------------------------------------------------------------------------------
//
// Arithmetic and Logic Unit - Testbench
//
//------------------------------------------------------------------------------------------------------------
// This module is the test bench for the CPU24 ALU unit.
//
//------------------------------------------------------------------------------------------------------------
//
// Arithmetic and Logic Unit - Testbench
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

module AluUnit_TB;

	reg[0:`WORD_LENGTH-1] 	A_TB 		= 0;
	reg[0:`WORD_LENGTH-1] 	B_TB 		= 0;
	reg[0:7] 				AC_TB 		= 0;

   	wire[0:`WORD_LENGTH-1]  R_TB;
   	wire                    C_OUT_TB;
   	wire                    N_TB;
   	wire                    Z_TB;
	wire                    ERR_TB;

	task setupTest;

		begin
			
			$dumpfile( "AluUnit_TB.vcd" );
   			$dumpvars( 0, AluUnit_TB );
		
		end

	endtask

	task applyTest ( 
		
		input [0:`WORD_LENGTH-1] 	a, 
		input [0:`WORD_LENGTH-1] 	b,
		input [0:7]					ac 

		// ??? need to add the expected values for comparison....
		
		);

		begin

			A_TB 	= a;
			B_TB    = b;
			AC_TB 	= ac;

			#10 $display( "A: 0x%h, B: 0x%h, ac: 0x%h -> R: 0x%h, C: %d, N: %d, Z: %d, ERR: %d", 
							A_TB, B_TB, AC_TB, R_TB, C_OUT_TB, N_TB, Z_TB, ERR_TB );

			// ??? compare result and flags with what we got back from teh ALU...
			// if ( s != a + b )  begin $display( "FAIL in %m" ); $finish; end
			// else               begin $display( "PASS" ); end
		
		end

	endtask

	AluUnit DUT ( 	.a( A_TB ), 
					.b( B_TB ), 
					.ac( AC_TB ), 
					.r( R_TB ), 
					.c( C_OUT_TB ), 
					.n( N_TB ), 
					.z( Z_TB ),
					.err( ERR_TB ));

	initial begin

		setupTest( );

		# 10 applyTest( 24'h000FFF, 24'h000001, 8'h00 );
		# 10 applyTest( 24'h000FFF, 24'h000002, 8'h01 );
		# 10 applyTest( 24'h000FFF, 24'h000003, 8'h02 );
		# 10 applyTest( 24'h000FFF, 24'h000001, 8'h03 );
		# 10 applyTest( 24'h000FFF, 24'h000003, 8'h05 );
		# 10 applyTest( 24'h000FFF, 24'h000003, 8'h06 );
		# 10 applyTest( 24'h000FFF, 24'h000003, 8'h07 );

		# 10 applyTest( 24'hFFFFFF, 24'h000001, 8'h03 );
		# 10 applyTest( 24'h000FFF, 24'h000001, 8'h83 );
		# 10 applyTest( 24'hFFFFFF, 24'h000001, 8'h83 );

		# 10 applyTest( 24'h000FFF, 24'h000003, 8'h45 );

		# 10 applyTest( 24'h000FFF, 24'h000001, 8'b00011011 );

   		#10 $finish;
		
	end

endmodule
