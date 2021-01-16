## Builds a native binary
#   LOCAL_NAME          := Name of the target
#   LOCAL_SRC           := Source file paths relative to the top of the tree
#   LOCAL_CFLAGS        := Flags passed to the C compiler
#   LOCAL_CXXFLAGS      := Flags passed to the C++ compiler
#   LOCAL_LDFLAGS       := Flags passed to the linker
#   LOCAL_ASFLAGS       := Flags for the assembler
#   LOCAL_LINKER_FILE   := Path to the linker script
#   LOCAL_SHARED_LIBS   := Shared libraries to link
#   LOCAL_STATIC_LIBS   := Static libraries to link
#   LOCAL_COMPILER      := Compiler profile to apply for this build.
#                          Overrides the CC, CXX and AS variables.
#                          Profiles are available under config/
#   SKIP_MAP_GEN        := Skips map file generation if it is true
#   LOCAL_CROSS_COMPILE := Sets the cross compiler prefix for the current toolchain
#                          Example: arm-none-eabi-
#   CC                  := C Compiler
#   CXX                 := C++ Compiler. Used as linker too
#   AS                  := Assembler.

CURRENT_MK              := $(lastword $(MAKEFILE_LIST))
LOCAL_TARGET            := $(BUILD_TARGET_DIR)/$(LOCAL_NAME)
LOCAL_LDFLAGS           += $(addprefix -T, $(LOCAL_LINKER_FILE))
ifneq ($(SKIP_MAP_GEN),true)
LOCAL_LDFLAGS           += -Wl,-Map=$(LOCAL_TARGET).map
endif

include $(BUILD_SYSTEM_DIR)/build_binary_common.mk

$(LOCAL_TARGET): INTERNAL_CXX := $(LOCAL_CXX)
$(LOCAL_TARGET): INTERNAL_CXXFLAGS := $(LOCAL_CXXFLAGS)
$(LOCAL_TARGET): INTERNAL_LDFLAGS := $(LOCAL_LDFLAGS)
$(LOCAL_TARGET): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_TARGET): INTERNAL_OBJ := $(LOCAL_OBJ)
$(LOCAL_TARGET): $(LOCAL_OBJ) $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(CURRENT_MK) $(LOCAL_DIR)/build.mk $(LOCAL_LINKER_FILE)
	$(call print-build-header, $(INTERNAL_TARGET_NAME), LD)
	$(MKDIR) $(dir $@)
	$(INTERNAL_CXX) $(INTERNAL_CXXFLAGS) -o $@ $(INTERNAL_OBJ) $(INTERNAL_LDFLAGS)

run_$(LOCAL_NAME): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
run_$(LOCAL_NAME): $(LOCAL_TARGET)
	$(call print-build-header, $(INTERNAL_TARGET_NAME), RUN)
	$(SILENT)LD_LIBRARY_PATH=$(BUILD_LIBS_DIR) $<
.PHONY: run_$(LOCAL_NAME)
