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
CMAKE_COMMAND = /opt/homebrew/Cellar/cmake/3.30.3/bin/cmake

# The command to remove a file.
RM = /opt/homebrew/Cellar/cmake/3.30.3/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/helmutfieres/GitHub/VCPU32-FPGA

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/helmutfieres/GitHub/VCPU32-FPGA/build

# Utility rule file for vcpu32_waveform.

# Include any custom commands dependencies for this target.
include vcpu32/CMakeFiles/vcpu32_waveform.dir/compiler_depend.make

# Include the progress variables for this target.
include vcpu32/CMakeFiles/vcpu32_waveform.dir/progress.make

vcpu32/CMakeFiles/vcpu32_waveform:
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/helmutfieres/GitHub/VCPU32-FPGA/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Opening GTKWave to view the waveform"
	gtkwave /Users/helmutfieres/GitHub/VCPU32-FPGA/build/vcpu32/vcpu32.vcd

vcpu32_waveform: vcpu32/CMakeFiles/vcpu32_waveform
vcpu32_waveform: vcpu32/CMakeFiles/vcpu32_waveform.dir/build.make
.PHONY : vcpu32_waveform

# Rule to build all files generated by this target.
vcpu32/CMakeFiles/vcpu32_waveform.dir/build: vcpu32_waveform
.PHONY : vcpu32/CMakeFiles/vcpu32_waveform.dir/build

vcpu32/CMakeFiles/vcpu32_waveform.dir/clean:
	cd /Users/helmutfieres/GitHub/VCPU32-FPGA/build/vcpu32 && $(CMAKE_COMMAND) -P CMakeFiles/vcpu32_waveform.dir/cmake_clean.cmake
.PHONY : vcpu32/CMakeFiles/vcpu32_waveform.dir/clean

vcpu32/CMakeFiles/vcpu32_waveform.dir/depend:
	cd /Users/helmutfieres/GitHub/VCPU32-FPGA/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/helmutfieres/GitHub/VCPU32-FPGA /Users/helmutfieres/GitHub/VCPU32-FPGA/vcpu32 /Users/helmutfieres/GitHub/VCPU32-FPGA/build /Users/helmutfieres/GitHub/VCPU32-FPGA/build/vcpu32 /Users/helmutfieres/GitHub/VCPU32-FPGA/build/vcpu32/CMakeFiles/vcpu32_waveform.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : vcpu32/CMakeFiles/vcpu32_waveform.dir/depend

