# ------------------------------------------------------------------------------------------------------------
#  ...
#
#  Copyright (C) 2024 - 2024 Helmut Fieres
# ------------------------------------------------------------------------------------------------------------
#
# This is the CMAKE file at the test bench directory level. It sets up the cmake version, the languages used,
# defines the project and finally initializes the Raspberry Pi Pico SDK. The actual cmake work is done in 
# the local cmake files of programs and libraries. This file will just define the subdirectories.
#
# ------------------------------------------------------------------------------------------------------------
cmake_minimum_required( VERSION 3.29 )

project( Vcpu32_TB )   

set( VERILOG_SOURCES
    ${CMAKE_SOURCE_DIR}/test-benches/Vcpu32_TB/Vcpu32_TB.v
    ${CMAKE_SOURCE_DIR}/vcpu32/vcpu32.v  # Reference the module under test
)

set( COMPILED_VERILOG ${CMAKE_BINARY_DIR}/test-benches/${PROJECT_NAME}/${PROJECT_NAME}.out )
set( VCD_OUTPUT ${CMAKE_BINARY_DIR}/test-benches/${PROJECT_NAME}/${PROJECT_NAME}.vcd )

include_directories( ${CMAKE_SOURCE_DIR}/vcpu32 )

add_custom_target(
    ${PROJECT_NAME}_compile
    COMMAND iverilog -g2012 -o ${COMPILED_VERILOG} ${VERILOG_SOURCES}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS ${VERILOG_SOURCES}
    COMMENT "Compiling Verilog code with Icarus Verilog"
)

add_custom_target(
    ${PROJECT_NAME}_simulate
    COMMAND vvp ${COMPILED_VERILOG}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    DEPENDS  ${PROJECT_NAME}_compile
    COMMENT "Running the Verilog simulation to generate VCD file"
)

add_custom_target(
    ${PROJECT_NAME}_waveform
    COMMAND vvp ${COMPILED_VERILOG}
    COMMAND gtkwave ${VCD_OUTPUT}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    DEPENDS ${PROJECT_NAME}_simulate
    COMMENT "Opening GTKWave to view the waveform"
)


