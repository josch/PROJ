set(PROJ_SRC
  apps/proj.cpp
  apps/emess.cpp
  apps/utils.cpp
)

source_group("Source Files\\Bin" FILES ${PROJ_SRC})

add_executable(binproj ${PROJ_SRC})
set_target_properties(binproj
  PROPERTIES
  RUNTIME_OUTPUT_NAME proj)
target_link_libraries(binproj PRIVATE ${PROJ_LIBRARIES})
target_compile_options(binproj PRIVATE ${PROJ_CXX_WARN_FLAGS})

install(TARGETS binproj
  DESTINATION ${BINDIR})

if(MSVC AND BUILD_SHARED_LIBS)
  target_compile_definitions(binproj PRIVATE PROJ_MSVC_DLL_IMPORT=1)
endif()

# invproj target: symlink or copy of proj executable

if(UNIX)

    set(link_target "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/invproj${CMAKE_EXECUTABLE_SUFFIX}")
    set(link_source "proj${CMAKE_EXECUTABLE_SUFFIX}")

    add_custom_command(
      OUTPUT ${link_target}
      COMMAND ${CMAKE_COMMAND} -E create_symlink ${link_source} ${link_target}
      WORKING_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
      DEPENDS binproj
      COMMENT "Generating invproj"
      VERBATIM
    )

    add_custom_target(invproj ALL DEPENDS ${link_target})

    install(FILES ${link_target} DESTINATION ${BINDIR})

else()

    add_executable(invproj ${PROJ_SRC})
    set_target_properties(invproj
      PROPERTIES
      RUNTIME_OUTPUT_NAME proj)
    target_link_libraries(invproj PRIVATE ${PROJ_LIBRARIES})
    target_compile_options(invproj PRIVATE ${PROJ_CXX_WARN_FLAGS})

    install(TARGETS invproj
      DESTINATION ${BINDIR})

    if(MSVC AND BUILD_SHARED_LIBS)
      target_compile_definitions(invproj PRIVATE PROJ_MSVC_DLL_IMPORT=1)
    endif()

endif()
