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
include src/CMakeFiles/scope-static.dir/depend.make

# Include the progress variables for this target.
include src/CMakeFiles/scope-static.dir/progress.make

# Include the compile flags for this target's objects.
include src/CMakeFiles/scope-static.dir/flags.make

src/CMakeFiles/scope-static.dir/api/client.cpp.o: src/CMakeFiles/scope-static.dir/flags.make
src/CMakeFiles/scope-static.dir/api/client.cpp.o: src/api/client.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/liuxg/git/mailcheck/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/CMakeFiles/scope-static.dir/api/client.cpp.o"
	cd /home/liuxg/git/mailcheck/src && /usr/bin/arm-linux-gnueabihf-g++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/scope-static.dir/api/client.cpp.o -c /home/liuxg/git/mailcheck/src/api/client.cpp

src/CMakeFiles/scope-static.dir/api/client.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/scope-static.dir/api/client.cpp.i"
	cd /home/liuxg/git/mailcheck/src && /usr/bin/arm-linux-gnueabihf-g++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/liuxg/git/mailcheck/src/api/client.cpp > CMakeFiles/scope-static.dir/api/client.cpp.i

src/CMakeFiles/scope-static.dir/api/client.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/scope-static.dir/api/client.cpp.s"
	cd /home/liuxg/git/mailcheck/src && /usr/bin/arm-linux-gnueabihf-g++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/liuxg/git/mailcheck/src/api/client.cpp -o CMakeFiles/scope-static.dir/api/client.cpp.s

src/CMakeFiles/scope-static.dir/api/client.cpp.o.requires:
.PHONY : src/CMakeFiles/scope-static.dir/api/client.cpp.o.requires

src/CMakeFiles/scope-static.dir/api/client.cpp.o.provides: src/CMakeFiles/scope-static.dir/api/client.cpp.o.requires
	$(MAKE) -f src/CMakeFiles/scope-static.dir/build.make src/CMakeFiles/scope-static.dir/api/client.cpp.o.provides.build
.PHONY : src/CMakeFiles/scope-static.dir/api/client.cpp.o.provides

src/CMakeFiles/scope-static.dir/api/client.cpp.o.provides.build: src/CMakeFiles/scope-static.dir/api/client.cpp.o

src/CMakeFiles/scope-static.dir/scope/preview.cpp.o: src/CMakeFiles/scope-static.dir/flags.make
src/CMakeFiles/scope-static.dir/scope/preview.cpp.o: src/scope/preview.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/liuxg/git/mailcheck/CMakeFiles $(CMAKE_PROGRESS_2)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/CMakeFiles/scope-static.dir/scope/preview.cpp.o"
	cd /home/liuxg/git/mailcheck/src && /usr/bin/arm-linux-gnueabihf-g++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/scope-static.dir/scope/preview.cpp.o -c /home/liuxg/git/mailcheck/src/scope/preview.cpp

src/CMakeFiles/scope-static.dir/scope/preview.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/scope-static.dir/scope/preview.cpp.i"
	cd /home/liuxg/git/mailcheck/src && /usr/bin/arm-linux-gnueabihf-g++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/liuxg/git/mailcheck/src/scope/preview.cpp > CMakeFiles/scope-static.dir/scope/preview.cpp.i

src/CMakeFiles/scope-static.dir/scope/preview.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/scope-static.dir/scope/preview.cpp.s"
	cd /home/liuxg/git/mailcheck/src && /usr/bin/arm-linux-gnueabihf-g++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/liuxg/git/mailcheck/src/scope/preview.cpp -o CMakeFiles/scope-static.dir/scope/preview.cpp.s

src/CMakeFiles/scope-static.dir/scope/preview.cpp.o.requires:
.PHONY : src/CMakeFiles/scope-static.dir/scope/preview.cpp.o.requires

src/CMakeFiles/scope-static.dir/scope/preview.cpp.o.provides: src/CMakeFiles/scope-static.dir/scope/preview.cpp.o.requires
	$(MAKE) -f src/CMakeFiles/scope-static.dir/build.make src/CMakeFiles/scope-static.dir/scope/preview.cpp.o.provides.build
.PHONY : src/CMakeFiles/scope-static.dir/scope/preview.cpp.o.provides

src/CMakeFiles/scope-static.dir/scope/preview.cpp.o.provides.build: src/CMakeFiles/scope-static.dir/scope/preview.cpp.o

src/CMakeFiles/scope-static.dir/scope/query.cpp.o: src/CMakeFiles/scope-static.dir/flags.make
src/CMakeFiles/scope-static.dir/scope/query.cpp.o: src/scope/query.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/liuxg/git/mailcheck/CMakeFiles $(CMAKE_PROGRESS_3)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/CMakeFiles/scope-static.dir/scope/query.cpp.o"
	cd /home/liuxg/git/mailcheck/src && /usr/bin/arm-linux-gnueabihf-g++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/scope-static.dir/scope/query.cpp.o -c /home/liuxg/git/mailcheck/src/scope/query.cpp

src/CMakeFiles/scope-static.dir/scope/query.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/scope-static.dir/scope/query.cpp.i"
	cd /home/liuxg/git/mailcheck/src && /usr/bin/arm-linux-gnueabihf-g++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/liuxg/git/mailcheck/src/scope/query.cpp > CMakeFiles/scope-static.dir/scope/query.cpp.i

src/CMakeFiles/scope-static.dir/scope/query.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/scope-static.dir/scope/query.cpp.s"
	cd /home/liuxg/git/mailcheck/src && /usr/bin/arm-linux-gnueabihf-g++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/liuxg/git/mailcheck/src/scope/query.cpp -o CMakeFiles/scope-static.dir/scope/query.cpp.s

src/CMakeFiles/scope-static.dir/scope/query.cpp.o.requires:
.PHONY : src/CMakeFiles/scope-static.dir/scope/query.cpp.o.requires

src/CMakeFiles/scope-static.dir/scope/query.cpp.o.provides: src/CMakeFiles/scope-static.dir/scope/query.cpp.o.requires
	$(MAKE) -f src/CMakeFiles/scope-static.dir/build.make src/CMakeFiles/scope-static.dir/scope/query.cpp.o.provides.build
.PHONY : src/CMakeFiles/scope-static.dir/scope/query.cpp.o.provides

src/CMakeFiles/scope-static.dir/scope/query.cpp.o.provides.build: src/CMakeFiles/scope-static.dir/scope/query.cpp.o

src/CMakeFiles/scope-static.dir/scope/scope.cpp.o: src/CMakeFiles/scope-static.dir/flags.make
src/CMakeFiles/scope-static.dir/scope/scope.cpp.o: src/scope/scope.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/liuxg/git/mailcheck/CMakeFiles $(CMAKE_PROGRESS_4)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/CMakeFiles/scope-static.dir/scope/scope.cpp.o"
	cd /home/liuxg/git/mailcheck/src && /usr/bin/arm-linux-gnueabihf-g++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/scope-static.dir/scope/scope.cpp.o -c /home/liuxg/git/mailcheck/src/scope/scope.cpp

src/CMakeFiles/scope-static.dir/scope/scope.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/scope-static.dir/scope/scope.cpp.i"
	cd /home/liuxg/git/mailcheck/src && /usr/bin/arm-linux-gnueabihf-g++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/liuxg/git/mailcheck/src/scope/scope.cpp > CMakeFiles/scope-static.dir/scope/scope.cpp.i

src/CMakeFiles/scope-static.dir/scope/scope.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/scope-static.dir/scope/scope.cpp.s"
	cd /home/liuxg/git/mailcheck/src && /usr/bin/arm-linux-gnueabihf-g++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/liuxg/git/mailcheck/src/scope/scope.cpp -o CMakeFiles/scope-static.dir/scope/scope.cpp.s

src/CMakeFiles/scope-static.dir/scope/scope.cpp.o.requires:
.PHONY : src/CMakeFiles/scope-static.dir/scope/scope.cpp.o.requires

src/CMakeFiles/scope-static.dir/scope/scope.cpp.o.provides: src/CMakeFiles/scope-static.dir/scope/scope.cpp.o.requires
	$(MAKE) -f src/CMakeFiles/scope-static.dir/build.make src/CMakeFiles/scope-static.dir/scope/scope.cpp.o.provides.build
.PHONY : src/CMakeFiles/scope-static.dir/scope/scope.cpp.o.provides

src/CMakeFiles/scope-static.dir/scope/scope.cpp.o.provides.build: src/CMakeFiles/scope-static.dir/scope/scope.cpp.o

scope-static: src/CMakeFiles/scope-static.dir/api/client.cpp.o
scope-static: src/CMakeFiles/scope-static.dir/scope/preview.cpp.o
scope-static: src/CMakeFiles/scope-static.dir/scope/query.cpp.o
scope-static: src/CMakeFiles/scope-static.dir/scope/scope.cpp.o
scope-static: src/CMakeFiles/scope-static.dir/build.make
.PHONY : scope-static

# Rule to build all files generated by this target.
src/CMakeFiles/scope-static.dir/build: scope-static
.PHONY : src/CMakeFiles/scope-static.dir/build

src/CMakeFiles/scope-static.dir/requires: src/CMakeFiles/scope-static.dir/api/client.cpp.o.requires
src/CMakeFiles/scope-static.dir/requires: src/CMakeFiles/scope-static.dir/scope/preview.cpp.o.requires
src/CMakeFiles/scope-static.dir/requires: src/CMakeFiles/scope-static.dir/scope/query.cpp.o.requires
src/CMakeFiles/scope-static.dir/requires: src/CMakeFiles/scope-static.dir/scope/scope.cpp.o.requires
.PHONY : src/CMakeFiles/scope-static.dir/requires

src/CMakeFiles/scope-static.dir/clean:
	cd /home/liuxg/git/mailcheck/src && $(CMAKE_COMMAND) -P CMakeFiles/scope-static.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/scope-static.dir/clean

src/CMakeFiles/scope-static.dir/depend:
	cd /home/liuxg/git/mailcheck && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/liuxg/git/mailcheck /home/liuxg/git/mailcheck/src /home/liuxg/git/mailcheck /home/liuxg/git/mailcheck/src /home/liuxg/git/mailcheck/src/CMakeFiles/scope-static.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/CMakeFiles/scope-static.dir/depend

