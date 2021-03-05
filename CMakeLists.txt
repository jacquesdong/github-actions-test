cmake_minimum_required(VERSION 3.16)

project(hello LANGUAGES C CXX VERSION 1.0)

# fib
add_library(fib SHARED fib.c fib.h)
set_target_properties(fib
  PROPERTIES
    PUBLIC_HEADER               fib.h
    DEFINE_SYMBOL               _BUILD
    CXX_VISIBILITY_PRESET       hidden
    VISIBILITY_INLINES_HIDDEN   YES
    )
target_include_directories(fib INTERFACE ${CMAKE_CURRENT_LIST_DIR})

add_executable(hello hello.c)
target_link_libraries(hello PRIVATE fib)

# test
include(CTest)
if(BUILD_TESTING)
  set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/extern/catch2)
  include(Catch)

  add_library(Catch INTERFACE)
  target_include_directories(Catch INTERFACE ${CMAKE_SOURCE_DIR}/extern/catch2)

  add_executable(Test tests/Test.cpp)
  target_link_libraries(Test
    PRIVATE
      fib
      Catch
      )
  catch_discover_tests(Test)
endif()

# install
include(GNUInstallDirs)
install(TARGETS
    hello
    fib
    RUNTIME       DESTINATION   ${CMAKE_INSTALL_BINDIR}
    LIBRARY       DESTINATION   ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE       DESTINATION   ${CMAKE_INSTALL_LIBDIR}
    PUBLIC_HEADER DESTINATION   ${CMAKE_INSTALL_INCLUDEDIR}
    )
set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set(CPACK_PACKAGE_FILE_NAME     "${PROJECT_NAME}-${PROJECT_VERSION}")
set(CPACK_GENERATOR TGZ)
include(CPack)
