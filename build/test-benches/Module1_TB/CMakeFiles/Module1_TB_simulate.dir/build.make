# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.30

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /opt/homebrew/Cellar/cmake/3.30.2/bin/cmake

# The command to remove a file.
RM = /opt/homebrew/Cellar/cmake/3.30.2/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/helmutfieres/GitHub/VCPU32-FPGA

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/helmutfieres/GitHub/VCPU32-FPGA/build

# Utility rule file for Module1_TB_simulate.

# Include any custom commands dependencies for this target.
include test-benches/Module1_TB/CMakeFiles/Module1_TB_simulate.dir/compiler_depend.make

# Include the progress variables for this target.
include test-benches/Module1_TB/CMakeFiles/Module1_TB_simulate.dir/progress.make

test-benches/Module1_TB/CMakeFiles/Module1_TB_simulate:
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/helmutfieres/GitHub/VCPU32-FPGA/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Running the Verilog simulation to generate VCD file"
	vvp /Users/helmutfieres/GitHub/VCPU32-FPGA/build/test-benches/Module1_TB/Module1_TB.out

Module1_TB_simulate: test-benches/Module1_TB/CMakeFiles/Module1_TB_simulate
Module1_TB_simulate: test-benches/Module1_TB/CMakeFiles/Module1_TB_simulate.dir/build.make
.PHONY : Module1_TB_simulate

# Rule to build all files generated by this target.
test-benches/Module1_TB/CMakeFiles/Module1_TB_simulate.dir/build: Module1_TB_simulate
.PHONY : test-benches/Module1_TB/CMakeFiles/Module1_TB_simulate.dir/build

test-benches/Module1_TB/CMakeFiles/Module1_TB_simulate.dir/clean:
	cd /Users/helmutfieres/GitHub/VCPU32-FPGA/build/test-benches/Module1_TB && $(CMAKE_COMMAND) -P CMakeFiles/Module1_TB_simulate.dir/cmake_clean.cmake
.PHONY : test-benches/Module1_TB/CMakeFiles/Module1_TB_simulate.dir/clean

test-benches/Module1_TB/CMakeFiles/Module1_TB_simulate.dir/depend:
	cd /Users/helmutfieres/GitHub/VCPU32-FPGA/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/helmutfieres/GitHub/VCPU32-FPGA /Users/helmutfieres/GitHub/VCPU32-FPGA/test-benches/Module1_TB /Users/helmutfieres/GitHub/VCPU32-FPGA/build /Users/helmutfieres/GitHub/VCPU32-FPGA/build/test-benches/Module1_TB /Users/helmutfieres/GitHub/VCPU32-FPGA/build/test-benches/Module1_TB/CMakeFiles/Module1_TB_simulate.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : test-benches/Module1_TB/CMakeFiles/Module1_TB_simulate.dir/depend

