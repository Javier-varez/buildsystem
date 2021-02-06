#
# Input:
#   * LOCAL_RISCV_ARCH
#   * LOCAL_RISCV_ABI
#

RISCV_GCC_SYSROOT ?= $(shell riscv64-unknown-elf-gcc -print-sysroot)
RISCV_GCC_VERSION ?= $(shell riscv64-unknown-elf-gcc --version | head -n1 | cut -d ' ' -f 3)

LOCAL_CC := clang
LOCAL_CXX := clang++

LOCAL_COMPILER_CFLAGS := \
    --target=riscv32 \
    --sysroot=$(RISCV_GCC_SYSROOT) \
    -I$(RISCV_GCC_SYSROOT)/include/c++/$(RISCV_GCC_VERSION) \
    -I$(RISCV_GCC_SYSROOT)/include/c++/$(RISCV_GCC_VERSION)/riscv64-unknown-elf/$(LOCAL_RISCV_ARCH)/$(LOCAL_RISCV_ABI) \
    -march=$(LOCAL_RISCV_ARCH) \
    -mabi=$(LOCAL_RISCV_ABI)

LOCAL_COMPILER_CXXFLAGS := $(LOCAL_COMPILER_CFLAGS)

LOCAL_COMPILER_LDFLAGS := \
    -nostdlib \
    -L $(RISCV_GCC_SYSROOT)/lib/$(LOCAL_RISCV_ARCH)/$(LOCAL_RISCV_ABI) \
    -lc_nano \
    -lstdc++_nano

