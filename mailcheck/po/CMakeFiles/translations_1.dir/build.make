# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/liuxg/git/mailcheck

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/liuxg/git/mailcheck

# Utility rule file for translations_1.

# Include the progress variables for this target.
include po/CMakeFiles/translations_1.dir/progress.make

po/CMakeFiles/translations_1:

translations_1: po/CMakeFiles/translations_1
translations_1: po/CMakeFiles/translations_1.dir/build.make
.PHONY : translations_1

# Rule to build all files generated by this target.
po/CMakeFiles/translations_1.dir/build: translations_1
.PHONY : po/CMakeFiles/translations_1.dir/build

po/CMakeFiles/translations_1.dir/clean:
	cd /home/liuxg/git/mailcheck/po && $(CMAKE_COMMAND) -P CMakeFiles/translations_1.dir/cmake_clean.cmake
.PHONY : po/CMakeFiles/translations_1.dir/clean

po/CMakeFiles/translations_1.dir/depend:
	cd /home/liuxg/git/mailcheck && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/liuxg/git/mailcheck /home/liuxg/git/mailcheck/po /home/liuxg/git/mailcheck /home/liuxg/git/mailcheck/po /home/liuxg/git/mailcheck/po/CMakeFiles/translations_1.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : po/CMakeFiles/translations_1.dir/depend

