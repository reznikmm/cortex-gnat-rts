idf_component_register(
  SRCS
    "common/adaint.c"
    "common/freertos_bindings.c"
    "common/last_chance_handler.c"
    "common/vApplicationStackOverflowHook.c"
  REQUIRES freertos)

idf_component_get_property(FREERTOS_ORIG_INCLUDE_PATH freertos
                           ORIG_INCLUDE_PATH)

target_include_directories (${COMPONENT_LIB} PRIVATE
  ${FREERTOS_ORIG_INCLUDE_PATH})

# Build GNAT RTS in ${BUILD_DIR}/rts
add_custom_command(OUTPUT ${BUILD_DIR}/rts/adalib/libgnat.a
     COMMAND gprbuild -p -P ${COMPONENT_DIR}/esp32/build_runtime.gpr
               --db ${COMPONENT_DIR}/gprconfig
               --autoconf=${BUILD_DIR}/config.cgpr
          && gprinstall -p -P ${COMPONENT_DIR}/esp32/build_runtime.gpr
               --prefix=${BUILD_DIR}/rts
               --autoconf=${BUILD_DIR}/config.cgpr
     DEPENDS ${COMPONENT_DIR}/common/ ${COMPONENT_DIR}/esp32/adainclude/
     VERBATIM)

add_custom_target(gnat DEPENDS ${BUILD_DIR}/rts/adalib/libgnat.a)
add_dependencies(${COMPONENT_LIB} gnat)
target_link_libraries(${COMPONENT_LIB} ${BUILD_DIR}/rts/adalib/libgnat.a)
