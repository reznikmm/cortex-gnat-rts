idf_component_register(SRCS "hello_world.c"
                    INCLUDE_DIRS "."
                    REQUIRES esp32-gnat-rts)

# Build *.gpr into a static library
add_custom_command(OUTPUT ${BUILD_DIR}/libadamain.a
     COMMAND gprbuild -b -c -p -P ${COMPONENT_DIR}/hello_world.gpr
               --db ${COMPONENT_DIR}/gprconfig
               --autoconf=${BUILD_DIR}/config.cgpr
               --RTS=${BUILD_DIR}/rts
          && xtensa-esp32-elf-ar rcs ${BUILD_DIR}/libadamain.a
               ${COMPONENT_DIR}/.objs/b__hello_world.o
               ${COMPONENT_DIR}/.objs/hello_world.o
     DEPENDS hello_world.gpr hello_world.adb
     VERBATIM)

add_custom_target(adamain DEPENDS ${BUILD_DIR}/libadamain.a)
add_dependencies(${COMPONENT_LIB} adamain)
target_link_libraries(${COMPONENT_LIB} ${BUILD_DIR}/libadamain.a)

