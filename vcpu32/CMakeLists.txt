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