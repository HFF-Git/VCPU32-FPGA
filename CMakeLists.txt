# ------------------------------------------------------------------------------------------------------------
#  VCPU32-FPGA
#
#  Copyright (C) 2024 - 2024  Helmut Fieres
# ------------------------------------------------------------------------------------------------------------
#
# This is the CMAKE file at the VCPU32-FPGA directory level. It sets up the cmake version, the languages used,
# defines the project. The actual cmake work is done in the local cmake files of the cpu and the test benches.
# This file will just define the subdirectories.
#
# ------------------------------------------------------------------------------------------------------------
cmake_minimum_required( VERSION 3.29 )

project( VCPU32-FPGA )

add_subdirectory( vcpu32 )
add_subdirectory( test-benches/Module1_TB )
add_subdirectory( test-benches/Module2_TB )