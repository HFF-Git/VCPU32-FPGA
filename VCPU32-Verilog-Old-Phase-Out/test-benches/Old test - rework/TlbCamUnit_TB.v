//------------------------------------------------------------------------------------------------------------
//
// Fully associate memory - dual ported, experimental version ( 8 entries, 36it key  ) -- Testbench
//
//------------------------------------------------------------------------------------------------------------
// 
// ....
//
//------------------------------------------------------------------------------------------------------------
//
// CPU24 - A 24bit CPU - Fully associate memory in Verilog - test bench
// Copyright (C) 2022 - 2023 Helmut Fieres
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
`include "../hdl/CPU24.v"

`timescale 1ns/1ns

module TlbCamUnit_TB;

	reg[0:35] 	patternA_TB;
	reg[0:35] 	patternB_TB;

	wire[0:2] 	matchAdrA_TB;
	wire[0:2] 	matchAdrB_TB;

	wire 		mFoundA_TB;
	wire 		mFoundB_TB;

	reg[0:2] 	writeAdr_TB;
	reg 		wEnable_TB;

	reg			clock_TB;	

	TlbCamUnit CAM ( 

		.clk( clock_TB ),
		.patternA( patternA_TB ),
		.patternB( patternB_TB ),
		.writeAdr( writeAdr_TB ), 
		.wEnable( wEnable_TB ),
		.matchAdrA( matchAdrA_TB ),
		.matchAdrB( matchAdrB_TB ),
		.mFoundA( mFoundA_TB ), 
		.mFoundB( mFoundB_TB )

	);
	
	initial begin

 		$dumpfile( "TlbCamUnit_TB.vcd" );
   		$dumpvars( 0, TlbCamUnit_TB );
   		
   		$monitor( 

   			$time, 
   			"-> clk=%d, patternA=%h, patternB=%h, writeAdr=%d, wEnable=%h, matchAdrA=%d, matchAdrB=%d, mFoundA=%h, mFoundB=%h", 
			clock_TB, patternA_TB, patternB_TB, writeAdr_TB, wEnable_TB, matchAdrA_TB, matchAdrB_TB, mFoundA_TB, mFoundB_TB 
		);

 		clock_TB 	    = 1;
 		writeAdr_TB 	= 0;
 		wEnable_TB 		= 0;
 		patternA_TB		= 0;
 		patternB_TB		= 0;

   		#20 writeAdr_TB = 0;
 			wEnable_TB 	= 1;
 			patternA_TB	= 36'h001200120;
 			patternB_TB	= 0;
 		#20	wEnable_TB 	= 0;

 		#20 writeAdr_TB = 1;
 			wEnable_TB 	= 1;
 			patternA_TB	= 36'h003400340;
 			patternB_TB	= 0;
 		#20	wEnable_TB 	= 0;

 		#20 writeAdr_TB = 2;
 			wEnable_TB 	= 1;
 			patternA_TB	= 36'h005600560;
 			patternB_TB	= 0;
 		#20	wEnable_TB 	= 0;

 		#20 writeAdr_TB = 3;
 			wEnable_TB 	= 1;
 			patternA_TB	= 36'h007800780;
 			patternB_TB	= 0;
 		#20	wEnable_TB 	= 0;

 		#20 writeAdr_TB = 4;
 			wEnable_TB 	= 1;
 			patternA_TB	= 36'h009A009A0;
 			patternB_TB	= 0;
 		#20	wEnable_TB 	= 0;

 		#20 writeAdr_TB = 5;
 			wEnable_TB 	= 1;
 			patternA_TB	= 36'h00BC00BC0;
 			patternB_TB	= 0;
 		#20	wEnable_TB 	= 0;

 		#20 writeAdr_TB = 6;
 			wEnable_TB 	= 1;
 			patternA_TB	= 36'h00DE00DE0;
 			patternB_TB	= 0;
 		#20	wEnable_TB 	= 0;

 		#20 writeAdr_TB = 7;
 			wEnable_TB 	= 1;
 			patternA_TB	= 36'h00FF00FF0;
 			patternB_TB	= 0;
 		#20	wEnable_TB 	= 0;

 		#20 writeAdr_TB = 0;
 			patternA_TB	= 36'h005600560;
 			patternB_TB	= 36'h003400340;

 		#20 patternA_TB	= 36'h007800780;
 			patternB_TB	= 36'h001200120;

 		#20 patternA_TB	= 36'h000000780;
 			patternB_TB	= 36'h001200000;

  	
   		#50 $finish;
		
	end

	always begin
		
		#10 clock_TB = !clock_TB;
	end

endmodule
