set(OBJ
               ${COMPONENT_DIR}/.objs/b__hello_world.o
               ${COMPONENT_DIR}/.objs/hello_world.o)

if(NOT CMAKE_BUILD_EARLY_EXPANSION)
  # Compile Ada file and run binder
  add_custom_command(OUTPUT ${OBJ}
     COMMAND gprbuild -b -c -p -P ${COMPONENT_DIR}/hello_world.gpr
               --db ${COMPONENT_DIR}/gprconfig
               --autoconf=${BUILD_DIR}/config.cgpr
               --RTS=${BUILD_DIR}/rts
     DEPENDS hello_world.gpr hello_world.adb
     VERBATIM)
endif()

idf_component_register(SRCS "hello_world.c"
                            ".objs/b__hello_world.o"
                            ".objs/hello_world.o"
                    INCLUDE_DIRS "."
                    REQUIRES esp32-gnat-rts)

# Required for s-fretcb.ads
idf_build_set_property(COMPILE_DEFINITIONS -DconfigUSE_APPLICATION_TASK_TAG=1 APPEND)
# Required for xTaskCreate in s-fretas.adb
idf_build_set_property(COMPILE_DEFINITIONS -DconfigSUPPORT_DYNAMIC_ALLOCATION=1 APPEND)

