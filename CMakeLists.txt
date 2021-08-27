# Read GNAT RTL object files list
file(READ ${COMPONENT_DIR}/esp32/obj_list.txt OBJ)
list(TRANSFORM OBJ STRIP)

if(NOT CMAKE_BUILD_EARLY_EXPANSION)
  # Build GNAT RTS in ${BUILD_DIR}/rts without *.c

  # Make full name object files list
  list(TRANSFORM OBJ PREPEND ${COMPONENT_DIR}/ REGEX "." OUTPUT_VARIABLE FULL)

  # run gprbuild and gprinstall
  add_custom_command(OUTPUT ${FULL}
     COMMAND gprbuild -p -P ${COMPONENT_DIR}/esp32/build_runtime.gpr
               --db ${COMPONENT_DIR}/gprconfig
               --autoconf=${BUILD_DIR}/config.cgpr
          && gprinstall -f -p -P ${COMPONENT_DIR}/esp32/build_runtime.gpr
               --prefix=${BUILD_DIR}/rts
               --autoconf=${BUILD_DIR}/config.cgpr
     VERBATIM)
endif()

idf_component_register(
  SRCS
    "common/adaint.c"
    "common/freertos_bindings.c"
    "common/last_chance_handler.c"
    "common/vApplicationStackOverflowHook.c"
    ${OBJ}
  REQUIRES freertos)

idf_component_get_property(FREERTOS_ORIG_INCLUDE_PATH freertos
                           ORIG_INCLUDE_PATH)

target_include_directories (${COMPONENT_LIB} PRIVATE
  ${FREERTOS_ORIG_INCLUDE_PATH})
