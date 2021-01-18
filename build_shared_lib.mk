## Builds a shared library
#   LOCAL_NAME          := Name of the target
#   LOCAL_SRC           := Source file paths relative to the top of the tree
#   LOCAL_CFLAGS        := Flags passed to the C compiler
#   LOCAL_CXXFLAGS      := Flags passed to the C++ compiler
#   LOCAL_LDFLAGS       := Flags passed to the linker
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


CURRENT_MK              := $(lastword $(MAKEFILE_LIST))
PARENT_MK               := $(lastword $(filter-out $(CURRENT_MK), $(MAKEFILE_LIST)))
LOCAL_NAME              := $(addprefix lib, $(LOCAL_NAME))
LOCAL_OUT_DIR           := $(BUILD_LIBS_DIR)/$(LOCAL_NAME)
LOCAL_TARGET            := $(BUILD_LIBS_DIR)/$(LOCAL_NAME).so

include $(BUILD_SYSTEM_DIR)/build_library_common.mk

$(LOCAL_TARGET): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_TARGET): INTERNAL_CXX := $(LOCAL_CXX)
$(LOCAL_TARGET): INTERNAL_CXXFLAGS := $(LOCAL_CXXFLAGS)
$(LOCAL_TARGET): INTERNAL_LDFLAGS := $(LOCAL_LDFLAGS)
$(LOCAL_TARGET): INTERNAL_OBJ := $(LOCAL_OBJ)
$(LOCAL_TARGET): $(LOCAL_OBJ) $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(LOCAL_TARGET_EXPORTS) $(CURRENT_MK) $(PARENT_MK)
	$(call print-build-header, $(INTERNAL_TARGET_NAME), LD)
	$(MKDIR) $(dir $@)
	$(SILENT)$(INTERNAL_CXX) -shared $(INTERNAL_CXXFLAGS) -o $@ $(INTERNAL_OBJ) $(INTERNAL_LDFLAGS)
