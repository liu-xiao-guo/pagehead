
# Google Mock unfortunately has to be compiled from source
include(FindGMock)


# Include our test library headers
include_directories(
  ${GTEST_INCLUDE_DIRS}
  ${GMOCK_INCLUDE_DIRS}
  ${TEST_INCLUDE_DIRS}
)


# Add the unit tests
add_subdirectory(unit)

