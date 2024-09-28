//------------------------------------------------------------------------------------------------------------
//
//  VCPU-32
//
//  Copyright (C) 2022 - 2024 Helmut Fieres, see License file.
//------------------------------------------------------------------------------------------------------------
// 
// - contains a lot of modules in one file...
// - test benches are however separate...
//
//
//------------------------------------------------------------------------------------------------------------
`ifndef DEFINES_VH
`define DEFINES_VH

//------------------------------------------------------------------------------------------------------------
// Global definitions.
//
//
//------------------------------------------------------------------------------------------------------------
`define BYTE_LENGTH           8
`define HALF_WORD_LENGTH      16
`define WORD_LENGTH           32
`define DBL_WORD_LENGTH       64
`define SEG_ID_WORD_LENGTH    16


//------------------------------------------------------------------------------------------------------------
// The reset vector. Upon reset, execution starts at this address in real mode.
//
//------------------------------------------------------------------------------------------------------------
`define RESET_IA_SEG          32'h0
`define RESET_IA_OFS          32'hF0000000


//------------------------------------------------------------------------------------------------------------
// ALU operation codes.
//
//
//------------------------------------------------------------------------------------------------------------
`define LOP_AND   3'b000
`define LOP_CAND  3'b001
`define LOP_XOR   3'b010
`define LOP_OR    3'b011
`define LOP_NAND  3'b100
`define LOP_COR   3'b101
`define LOP_XNOR  3'b110
`define LOP_NOR   3'b111

//------------------------------------------------------------------------------------------------------------
// Instruction Set OpCodes.
//
// ??? cross check ...
//------------------------------------------------------------------------------------------------------------
`define OP_BRK          6'h00       // break for debug
`define OP_LDIL         6'h01       // load immediate left
`define OP_ADDIL        6'h02       // add immediate left
`define OP_LDO          6'h03       // load offset
`define OP_LSID         6'h04       // load segment ID register
`define OP_EXTR         6'h05       // extract bit field of operand
`define OP_DEP          6'h06       // extract bit field into operand
`define OP_DSR          6'h07       // double register shift right
`define OP_SHLA         6'h08       // shift left and add
`define OP_CMR          6'h09       // conditional move register or value
`define OP_MR           6'h0a        // move to or from a segment or control register
`define OP_MST          6'h0b       // set or clear status bits
`define OP_DS           6'h0c       // divide step

`define OP_ADD          6'h10       // target = target + operand ; options ovl trap, etc.
`define OP_ADC          6'h11       // target = target + operand + carry; options for ovl trap, etc.
`define OP_SUB          6'h12       // target = target - operand ;options for ovl trap, etc.
`define OP_SBC          6'h13       // target = target - operand - carry ;options for ovl trap, etc.
`define OP_AND          6'h14       // target = target & operand ; option to negate the result
`define OP_OR           6'h15       // target = target | operand ; option to negate the result
`define OP_XOR          6'h16       // target = target ^ operand ; option to negate the result
`define OP_CMP          6'h17       // subtract reg2 from reg1 and set condition codes
`define OP_CMPU         6'h18       // subtract reg2 from reg1 and set condition codes - unsigned

`define OP_B            6'h20       // branch
`define OP_GATE         6'h21       // gateway instruction
`define OP_BR           6'h22       // branch register
`define OP_BV           6'h23       // branch vectored
`define OP_BE           6'h24       // branch external
`define OP_BVE          6'h25       // branch vectored external
`define OP_CBR          6'h26       // compare and branch
`define OP_CBRU         6'h27       // compare and branch - unsigned

`define OP_LD           6'h30       // target = [ operand ]
`define OP_ST           6'h31       // [ operand ] = target
`define OP_LDA          6'h32       // load from absolute address
`define OP_STA          6'h33       // store to absolute adress
`define OP_LDR          6'h34       // load referenced
`define OP_STC          6'h35       // store conditional
    
`define OP_LDPA         6'h39       // load physical address
`define OP_PRB          6'h3a       // probe access
`define OP_ITLB         6'h3b       // insert into TLB
`define OP_PTLB         6'h3c       // remove from TLB
`define OP_PCA          6'h3d       // purge and flush cache
`define OP_DIAG         6'h3e       // diagnostics instruction, tbd.
`define OP_RFI          6'h3f       // return from interrupt




`endif // DEFINES_VH