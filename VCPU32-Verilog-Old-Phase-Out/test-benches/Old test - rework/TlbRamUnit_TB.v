//------------------------------------------------------------------------------------------------------------
//
// FRAM memory - dual ported, experimental version ( 8 entries, xx  ) -- Testbench
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

module TlbRamUnit_TB;

	reg 		wEnable_TB;
	reg[0:2] 	writeAdr_TB;
	reg[0:47] 	dataIn_TB;

    reg[0:2] 	readAdrA_TB;
	wire[0:47] 	dataOutA_TB;

	reg[0:2] 	readAdrB_TB;
	wire[0:47] 	dataOutB_TB;

	reg			clock_TB;	

	TlbRamUnit RAM ( 

		.clk( clock_TB ),
		.readAdrA( readAdrA_TB ),
		.readAdrB( readAdrB_TB ),
		.wEnable( wEnable_TB ),
		.writeAdr( writeAdr_TB ),
		.dataIn( dataIn_TB ),
		.dataOutA( dataOutA_TB ),
		.dataOutB( dataOutB_TB )
	);
	
	initial begin

 		$dumpfile( "TlbRamUnit_TB.vcd" );
   		$dumpvars( 0, TlbRamUnit_TB );
   		
   		$monitor( 

   			$time, 
   			"-> clk=%d, readAdrA=%h, readAdrB=%h, wEnable=%h, writeAdr=%d, dataIn=%h, dataOutA=%h, dataOutB=%h", 
			clock_TB, readAdrA_TB, readAdrB_TB, wEnable_TB, writeAdr_TB, dataIn_TB, dataOutA_TB, dataOutB_TB
		);

 		clock_TB 	    = 1;
 		writeAdr_TB 	= 0;
 		wEnable_TB 		= 0;
 		dataIn_TB		= 0;
 		
   		#20 writeAdr_TB 	= 0;
 			wEnable_TB 		= 1;
 			dataIn_TB		= 48'h001200120034;
 		#20	wEnable_TB 		= 0;

 		#20 writeAdr_TB 	= 2;
 			wEnable_TB 		= 1;
 			dataIn_TB		= 48'h120012003400;
 		#20	wEnable_TB 		= 0;


 		#20 readAdrA_TB	= 0;
 			readAdrB_TB	= 1;

 		#20 readAdrA_TB	= 2;
 			readAdrB_TB	= 2;	

  	
   		#50 $finish;
		
	end

	always begin
		
		#10 clock_TB = !clock_TB;
	end

endmodule
