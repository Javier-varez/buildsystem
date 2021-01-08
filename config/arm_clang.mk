#
# Inputs:
#   * LOCAL_ARM_ARCHITECTURE: Architecture of the MCU
#       Possible values: v6-m, v7-m, v7e-m, v7e-m+fp, v7e-m+dp
#       default: v6-m (for widest compatibility)
#   * LOCAL_ARM_FPU: FPU selected
#       Possible values: nofp, hard, softfp
#       default: nofp (for widest compatibility)
#
# Only supports thumb targets
#

ARM_GCC_SYSROOT ?= $(shell arm-none-eabi-gcc -print-sysroot)
ARM_GCC_VERSION ?= $(shell arm-none-eabi-gcc --version | head -n1 | cut -d ' ' -f 7)

LOCAL_CC := $(SILENT)clang
LOCAL_CXX := $(SILENT)clang++

ifeq ($(LOCAL_ARM_ARCHITECTURE),)
	LOCAL_ARM_ARCHITECTURE := v6-m
endif

ifeq ($(LOCAL_ARM_FPU),)
	LOCAL_ARM_FPU := nofp
endif

LOCAL_COMPILER_CFLAGS := \
    --target=arm-none-eabi \
	--sysroot=$(ARM_GCC_SYSROOT) \
    -I$(ARM_GCC_SYSROOT)/include/c++/$(ARM_GCC_VERSION) \
    -I$(ARM_GCC_SYSROOT)/include/c++/$(ARM_GCC_VERSION)/arm-none-eabi/thumb/$(LOCAL_ARM_ARCHITECTURE)/$(LOCAL_ARM_FPU)/

LOCAL_COMPILER_CXXFLAGS := $(LOCAL_COMPILER_CFLAGS)

LOCAL_COMPILER_LDFLAGS := \
    -nostdlib \
    -L $(ARM_GCC_SYSROOT)/lib/thumb/$(LOCAL_ARM_ARCHITECTURE)/$(LOCAL_ARM_FPU) \
    -lc_nano \
    -lstdc++_nano
