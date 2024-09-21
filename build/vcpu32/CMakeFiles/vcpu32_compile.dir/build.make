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

# Utility rule file for vcpu32_compile.

# Include any custom commands dependencies for this target.
include vcpu32/CMakeFiles/vcpu32_compile.dir/compiler_depend.make

# Include the progress variables for this target.
include vcpu32/CMakeFiles/vcpu32_compile.dir/progress.make

vcpu32/CMakeFiles/vcpu32_compile: /Users/helmutfieres/GitHub/VCPU32-FPGA/vcpu32/defines.vh
vcpu32/CMakeFiles/vcpu32_compile: /Users/helmutfieres/GitHub/VCPU32-FPGA/vcpu32/util.v
vcpu32/CMakeFiles/vcpu32_compile: /Users/helmutfieres/GitHub/VCPU32-FPGA/vcpu32/aluUnit.v
vcpu32/CMakeFiles/vcpu32_compile: /Users/helmutfieres/GitHub/VCPU32-FPGA/vcpu32/shiftMergeUnit.v
vcpu32/CMakeFiles/vcpu32_compile: /Users/helmutfieres/GitHub/VCPU32-FPGA/vcpu32/registerFile.v
vcpu32/CMakeFiles/vcpu32_compile: /Users/helmutfieres/GitHub/VCPU32-FPGA/vcpu32/vcpu32.v
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/helmutfieres/GitHub/VCPU32-FPGA/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Compiling Verilog code with Icarus Verilog"
	cd /Users/helmutfieres/GitHub/VCPU32-FPGA && iverilog -g2012 -I/Users/helmutfieres/GitHub/VCPU32-FPGA/vcpu32 -o /Users/helmutfieres/GitHub/VCPU32-FPGA/build/vcpu32/vcpu32.out /Users/helmutfieres/GitHub/VCPU32-FPGA/vcpu32/defines.vh /Users/helmutfieres/GitHub/VCPU32-FPGA/vcpu32/util.v /Users/helmutfieres/GitHub/VCPU32-FPGA/vcpu32/aluUnit.v /Users/helmutfieres/GitHub/VCPU32-FPGA/vcpu32/shiftMergeUnit.v /Users/helmutfieres/GitHub/VCPU32-FPGA/vcpu32/registerFile.v /Users/helmutfieres/GitHub/VCPU32-FPGA/vcpu32/vcpu32.v

vcpu32_compile: vcpu32/CMakeFiles/vcpu32_compile
vcpu32_compile: vcpu32/CMakeFiles/vcpu32_compile.dir/build.make
.PHONY : vcpu32_compile

# Rule to build all files generated by this target.
vcpu32/CMakeFiles/vcpu32_compile.dir/build: vcpu32_compile
.PHONY : vcpu32/CMakeFiles/vcpu32_compile.dir/build

vcpu32/CMakeFiles/vcpu32_compile.dir/clean:
	cd /Users/helmutfieres/GitHub/VCPU32-FPGA/build/vcpu32 && $(CMAKE_COMMAND) -P CMakeFiles/vcpu32_compile.dir/cmake_clean.cmake
.PHONY : vcpu32/CMakeFiles/vcpu32_compile.dir/clean

vcpu32/CMakeFiles/vcpu32_compile.dir/depend:
	cd /Users/helmutfieres/GitHub/VCPU32-FPGA/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/helmutfieres/GitHub/VCPU32-FPGA /Users/helmutfieres/GitHub/VCPU32-FPGA/vcpu32 /Users/helmutfieres/GitHub/VCPU32-FPGA/build /Users/helmutfieres/GitHub/VCPU32-FPGA/build/vcpu32 /Users/helmutfieres/GitHub/VCPU32-FPGA/build/vcpu32/CMakeFiles/vcpu32_compile.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : vcpu32/CMakeFiles/vcpu32_compile.dir/depend

