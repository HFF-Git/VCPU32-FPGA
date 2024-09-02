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

project( vcpu32 )

# Set the source and library directory
set(SRC_DIR ${CMAKE_SOURCE_DIR})
set(INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)

# Specify the Verilog source files
set(VERILOG_SOURCES
    ${SRC_DIR}/vcpu32.v
)

# Specify the output files
set(COMPILED_VERILOG ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.out)
set(VCD_OUTPUT ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.vcd)

# Target 1: Compile Verilog only
add_custom_target(
    compile_verilog
    COMMAND iverilog -g2012 -I${INCLUDE_DIR} -o ${COMPILED_VERILOG} ${VERILOG_SOURCES}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS ${VERILOG_SOURCES}
    COMMENT "Compiling Verilog code with Icarus Verilog"
)

# Target 2: Compile and run Verilog simulation (vvp)
add_custom_target(
    run_simulation
    COMMAND vvp ${COMPILED_VERILOG}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    DEPENDS compile_verilog
    COMMENT "Running the Verilog simulation to generate VCD file"
)

# Target 3: Compile, run simulation, and open GTKWave
add_custom_target(
    view_waveform
    COMMAND vvp ${COMPILED_VERILOG}
    COMMAND gtkwave ${VCD_OUTPUT}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    DEPENDS run_simulation
    COMMENT "Opening GTKWave to view the waveform"
)

