## Builds a shared library
#   LOCAL_NAME          := Name of the target
#   LOCAL_SRC           := Source file paths relative to the top of the tree
#   LOCAL_CFLAGS        := Flags passed to the C compiler
#   LOCAL_CXXFLAGS      := Flags passed to the C++ compiler
#   LOCAL_ARFLAGS       := Flags passed to the archiver
#   LOCAL_ASFLAGS       := Flags for the assembler
#   LOCAL_SHARED_LIBS   := Shared libraries to link
#   LOCAL_STATIC_LIBS   := Static libraries to link
#   LOCAL_COMPILER      := Compiler profile to apply for this build.
#                          Overrides the CC, CXX and AS variables.
#                          Profiles are available under config/
#   LOCAL_EXPORTED_DIRS := Directories with exported header files.
#                          The header files under these directories will
#                          be available for targets that links against the
#                          library.
#   LOCAL_CROSS_COMPILE := Sets the cross compiler prefix for the current toolchain
#                          Example: arm-none-eabi-
#   CC                  := C Compiler
#   CXX                 := C++ Compiler. Used as linker too
#   AS                  := Assembler.
#   AR                  := Archiver.

CURRENT_MK              := $(lastword $(MAKEFILE_LIST))
LOCAL_NAME              := $(addprefix lib, $(LOCAL_NAME))
LOCAL_OUT_DIR           := $(BUILD_LIBS_DIR)/$(LOCAL_NAME)
LOCAL_TARGET            := $(BUILD_LIBS_DIR)/$(LOCAL_NAME).a

include $(BUILD_SYSTEM_DIR)/build_binary_common.mk
include $(BUILD_SYSTEM_DIR)/build_library_common.mk

$(LOCAL_TARGET): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_TARGET): INTERNAL_AR := $(LOCAL_AR)
$(LOCAL_TARGET): INTERNAL_ARFLAGS := $(LOCAL_ARFLAGS)
$(LOCAL_TARGET): INTERNAL_OBJ := $(LOCAL_OBJ)
$(LOCAL_TARGET): $(LOCAL_OBJ) $(LOCAL_STATIC_LIB_PATHS) $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_TARGET_EXPORTS) $(CURRENT_MK) $(LOCAL_DIR)/build.mk
	$(call print-build-header, $(INTERNAL_TARGET_NAME), AR)
	$(MKDIR) $(dir $@)
	$(INTERNAL_AR) $(INTERNAL_ARFLAGS) $@ $(INTERNAL_OBJ) $(LOCAL_STATIC_LIB_PATHS)
