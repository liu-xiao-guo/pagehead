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

# Include any dependencies generated for this target.
include tests/unit/CMakeFiles/scope-unit-tests.dir/depend.make

# Include the progress variables for this target.
include tests/unit/CMakeFiles/scope-unit-tests.dir/progress.make

# Include the compile flags for this target's objects.
include tests/unit/CMakeFiles/scope-unit-tests.dir/flags.make

tests/unit/CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.o: tests/unit/CMakeFiles/scope-unit-tests.dir/flags.make
tests/unit/CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.o: tests/unit/scope/test-scope.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/liuxg/git/mailcheck/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object tests/unit/CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.o"
	cd /home/liuxg/git/mailcheck/tests/unit && /usr/bin/arm-linux-gnueabihf-g++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.o -c /home/liuxg/git/mailcheck/tests/unit/scope/test-scope.cpp

tests/unit/CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.i"
	cd /home/liuxg/git/mailcheck/tests/unit && /usr/bin/arm-linux-gnueabihf-g++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/liuxg/git/mailcheck/tests/unit/scope/test-scope.cpp > CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.i

tests/unit/CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.s"
	cd /home/liuxg/git/mailcheck/tests/unit && /usr/bin/arm-linux-gnueabihf-g++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/liuxg/git/mailcheck/tests/unit/scope/test-scope.cpp -o CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.s

tests/unit/CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.o.requires:
.PHONY : tests/unit/CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.o.requires

tests/unit/CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.o.provides: tests/unit/CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.o.requires
	$(MAKE) -f tests/unit/CMakeFiles/scope-unit-tests.dir/build.make tests/unit/CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.o.provides.build
.PHONY : tests/unit/CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.o.provides

tests/unit/CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.o.provides.build: tests/unit/CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.o

# Object files for target scope-unit-tests
scope__unit__tests_OBJECTS = \
"CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.o"

# External object files for target scope-unit-tests
scope__unit__tests_EXTERNAL_OBJECTS = \
"/home/liuxg/git/mailcheck/src/CMakeFiles/scope-static.dir/api/client.cpp.o" \
"/home/liuxg/git/mailcheck/src/CMakeFiles/scope-static.dir/scope/preview.cpp.o" \
"/home/liuxg/git/mailcheck/src/CMakeFiles/scope-static.dir/scope/query.cpp.o" \
"/home/liuxg/git/mailcheck/src/CMakeFiles/scope-static.dir/scope/scope.cpp.o"

tests/unit/scope-unit-tests: tests/unit/CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.o
tests/unit/scope-unit-tests: src/CMakeFiles/scope-static.dir/api/client.cpp.o
tests/unit/scope-unit-tests: src/CMakeFiles/scope-static.dir/scope/preview.cpp.o
tests/unit/scope-unit-tests: src/CMakeFiles/scope-static.dir/scope/query.cpp.o
tests/unit/scope-unit-tests: src/CMakeFiles/scope-static.dir/scope/scope.cpp.o
tests/unit/scope-unit-tests: tests/unit/CMakeFiles/scope-unit-tests.dir/build.make
tests/unit/scope-unit-tests: /usr/lib/arm-linux-gnueabihf/libQt5Core.so.5.3.0
tests/unit/scope-unit-tests: /usr/lib/arm-linux-gnueabihf/libQt5Network.so.5.3.0
tests/unit/scope-unit-tests: tests/gmock/gtest/libgtest.a
tests/unit/scope-unit-tests: tests/gmock/gtest/libgtest_main.a
tests/unit/scope-unit-tests: tests/gmock/libgmock.a
tests/unit/scope-unit-tests: tests/gmock/libgmock_main.a
tests/unit/scope-unit-tests: /usr/lib/arm-linux-gnueabihf/libQt5Core.so.5.3.0
tests/unit/scope-unit-tests: tests/gmock/gtest/libgtest.a
tests/unit/scope-unit-tests: tests/unit/CMakeFiles/scope-unit-tests.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable scope-unit-tests"
	cd /home/liuxg/git/mailcheck/tests/unit && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/scope-unit-tests.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tests/unit/CMakeFiles/scope-unit-tests.dir/build: tests/unit/scope-unit-tests
.PHONY : tests/unit/CMakeFiles/scope-unit-tests.dir/build

tests/unit/CMakeFiles/scope-unit-tests.dir/requires: tests/unit/CMakeFiles/scope-unit-tests.dir/scope/test-scope.cpp.o.requires
.PHONY : tests/unit/CMakeFiles/scope-unit-tests.dir/requires

tests/unit/CMakeFiles/scope-unit-tests.dir/clean:
	cd /home/liuxg/git/mailcheck/tests/unit && $(CMAKE_COMMAND) -P CMakeFiles/scope-unit-tests.dir/cmake_clean.cmake
.PHONY : tests/unit/CMakeFiles/scope-unit-tests.dir/clean

tests/unit/CMakeFiles/scope-unit-tests.dir/depend:
	cd /home/liuxg/git/mailcheck && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/liuxg/git/mailcheck /home/liuxg/git/mailcheck/tests/unit /home/liuxg/git/mailcheck /home/liuxg/git/mailcheck/tests/unit /home/liuxg/git/mailcheck/tests/unit/CMakeFiles/scope-unit-tests.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tests/unit/CMakeFiles/scope-unit-tests.dir/depend
