set(OBJ
               ${COMPONENT_DIR}/.objs/b__main.o
               ${COMPONENT_DIR}/.objs/esp32-gpio.o
               ${COMPONENT_DIR}/.objs/esp32-dport.o
               ${COMPONENT_DIR}/.objs/esp32-spi.o
               ${COMPONENT_DIR}/.objs/esp32.o
               ${COMPONENT_DIR}/.objs/main.o
               ${COMPONENT_DIR}/.objs/lora.o)

if(NOT CMAKE_BUILD_EARLY_EXPANSION)
  # Compile Ada file and run binder
  add_custom_command(OUTPUT ${OBJ}
     COMMAND gprbuild -b -c -p -P ${COMPONENT_DIR}/lora.gpr
               --db ${COMPONENT_DIR}/gprconfig
               --autoconf=${BUILD_DIR}/config.cgpr
               --RTS=${BUILD_DIR}/rts
     DEPENDS lora.gpr lora.adb
     VERBATIM)
endif()

idf_component_register(SRCS "lora.c"
                            ".objs/b__main.o"
                            ".objs/lora.o"
                            ".objs/main.o"
                            ".objs/esp32-gpio.o"
                            ".objs/esp32-dport.o"
                            ".objs/esp32-spi.o"
                            ".objs/esp32.o"
                    INCLUDE_DIRS "."
                    REQUIRES esp32-gnat-rts)

# Required for s-fretcb.ads
idf_build_set_property(COMPILE_DEFINITIONS -DconfigUSE_APPLICATION_TASK_TAG=1 APPEND)
# Required for xTaskCreate in s-fretas.adb
idf_build_set_property(COMPILE_DEFINITIONS -DconfigSUPPORT_DYNAMIC_ALLOCATION=1 APPEND)

