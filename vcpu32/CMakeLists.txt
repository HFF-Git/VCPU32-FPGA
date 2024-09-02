# ------------------------------------------------------------------------------------------------------------
#  CMAKE file for the VCPU32 processor.
#
#  Copyright (C) 2024 - 2024 Helmut Fieres
# ------------------------------------------------------------------------------------------------------------
#
# This is the CMAKE file at the vpcu32 provessor core level. 
#
# ------------------------------------------------------------------------------------------------------------
cmake_minimum_required( VERSION 3.29 )

project( vcpu32 )

set(SRC_DIR ${CMAKE_SOURCE_DIR})
set(INCLUDE_DIR ${CMAKE_SOURCE_DIR})

set(VERILOG_SOURCES

    ${SRC_DIR}/vcpu32.v
)

set(COMPILED_VERILOG ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.out)
set(VCD_OUTPUT ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.vcd)

add_custom_target(
    vcpu32_compile
    COMMAND iverilog -g2012 -I${INCLUDE_DIR} -o ${COMPILED_VERILOG} ${VERILOG_SOURCES}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS ${VERILOG_SOURCES}
    COMMENT "Compiling Verilog code with Icarus Verilog"
)

add_custom_target(
    vcpu32_run
    COMMAND vvp ${COMPILED_VERILOG}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    DEPENDS compile_verilog
    COMMENT "Running the Verilog simulation to generate VCD file"
)

add_custom_target(
    vcpu32_waveform
    COMMAND vvp ${COMPILED_VERILOG}
    COMMAND gtkwave ${VCD_OUTPUT}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    DEPENDS run_simulation
    COMMENT "Opening GTKWave to view the waveform"
)

