# Put your MCU Information Here #
# If you're getting a lot of compiler errors saying typedefs aren't defined etc it is probably because MCU_MODEL does not perfectly match what is defined in the toolchain
SET(MCU_FAMILY "STM32F4xx")
SET(MCU_MODEL "STM32F401xE") #This is added to the compiler define statements so the toolchain knows what target it's building
SET(MCU_PARTNO "stm32f401retx")
SET(MCU_CORTEX "m4")


#Provide the location of the linker script, This is the memory map of the microcrontroller#
SET(LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/STM32F401RETx_FLASH.ld")
MESSAGE(${LINKER_SCRIPT})
# Add MCU Specific Complier flags 
SET("MCU_FLAGS" "-mcpu=cortex-${MCU_CORTEX} -D${MCU_MODEL}")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${MCU_FLAGS}")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${MCU_FLAGS}")


# Add Include Directories for Micro #
SET(HAL_DRIVER_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver")	# Sets the appropriate include directory based on the MCU Family
SET(CORE_DRIVER_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}") # If a "Core" file does not exist in the project structure this shoudl be the same as the current source dir
SET(CMSIS_DRIVER_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/Drivers/CMSIS")	# Sets the appropriate include directory based on the MCU Family

MESSAGE("Setting HAL Directory to: ${HAL_DRIVER_DIRECTORY}")
MESSAGE("Setting CMSIS Directory to: ${CMSIS_DRIVER_DIRECTORY}")

INCLUDE_DIRECTORIES(
	${HAL_DRIVER_DIRECTORY}/Inc
	${HAL_DRIVER_DIRECTORY}/Inc/Legacy
	${CMSIS_DRIVER_DIRECTORY}/Include
	${CMSIS_DRIVER_DIRECTORY}/Device/ST/${MCU_FAMILY}/Include
	${CORE_DRIVER_DIRECTORY}/Inc
)

# Build HAL Libraries #
# Must include all HAL Libraries in the Src Directory here or they will not be compiled into the static library

SET(LIBS 
	cortex 
	dma 
	dma_ex 
	exti 
	flash 
	flash_ex 
	gpio 
	i2c 
	i2c_ex 
	pwr 
	pwr_ex 
	rcc 
	rcc_ex
	spi
	tim 
	tim_ex
	uart
	)


SET(LIBNAME ${MCU_PARTNO}lib)
ADD_LIBRARY(${LIBNAME} STATIC)

#TARGET_SOURCES(${LIBNAME} PRIVATE "${HAL_DRIVER_DIRECTORY}/Src/${MCU_FAMILY}_ll_rcc.c")
TARGET_SOURCES(${LIBNAME} PRIVATE "${HAL_DRIVER_DIRECTORY}/Src/${MCU_FAMILY}_hal.c")


FOREACH(HAL_LIB  IN LISTS LIBS)
	#MESSAGE("Adding Library ${MCU_FAMILY}_hal_${HAL_LIB}")
	TARGET_SOURCES(${LIBNAME} PRIVATE "${HAL_DRIVER_DIRECTORY}/Src/${MCU_FAMILY}_hal_${HAL_LIB}.c")
endforeach()

# Build Startup Assembly File
TARGET_SOURCES(${LIBNAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/startup/startup_${MCU_MODEL}.s")

# Make Static Library from Object Files





