# ------------------------------------------------------------------------------------------------------------
#  CMAKE file for the VCPU32 processor.
#
#  Copyright (C) 2022 - 2024 Helmut Fieres, see License file.
# ------------------------------------------------------------------------------------------------------------
#
# This is the CMAKE file at the vpcu32 provessor core level. 
#
# ------------------------------------------------------------------------------------------------------------
cmake_minimum_required( VERSION 3.29 )

project( vcpu32 )

set(INCLUDE_DIR ${CMAKE_SOURCE_DIR}/vcpu32)

set(VERILOG_SOURCES

    ${CMAKE_SOURCE_DIR}/vcpu32/defines.vh
    ${CMAKE_SOURCE_DIR}/vcpu32/util.v
    ${CMAKE_SOURCE_DIR}/vcpu32/FetchDecodeStage.v
    ${CMAKE_SOURCE_DIR}/vcpu32/MemoryAccessStage.v
    ${CMAKE_SOURCE_DIR}/vcpu32/ExecuteStage.v
    ${CMAKE_SOURCE_DIR}/vcpu32/cache.v
    ${CMAKE_SOURCE_DIR}/vcpu32/tlb.v
    ${CMAKE_SOURCE_DIR}/vcpu32/shiftMergeUnit.v
    ${CMAKE_SOURCE_DIR}/vcpu32/registerFile.v
    ${CMAKE_SOURCE_DIR}/vcpu32/vcpu32.v
)

set( COMPILED_VERILOG ${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}.out )
set( VCD_OUTPUT ${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}.vcd )

add_custom_target(
    ${PROJECT_NAME}_compile
    COMMAND iverilog -g2012 -I${INCLUDE_DIR} -o ${COMPILED_VERILOG} ${VERILOG_SOURCES}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS ${VERILOG_SOURCES}
    COMMENT "Compiling Verilog code with Icarus Verilog"
)

add_custom_target(
    ${PROJECT_NAME}_simulate
    COMMAND vvp ${COMPILED_VERILOG}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    DEPENDS ${PROJECT_NAME}_compile
    COMMENT "Running the Verilog simulation to generate VCD file"
)

add_custom_target(
    ${PROJECT_NAME}_waveform
    # COMMAND vvp ${COMPILED_VERILOG}
    COMMAND gtkwave ${VCD_OUTPUT}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    DEPENDS ${PROJECT_NAME}_simulate
    COMMENT "Opening GTKWave to view the waveform"
)

