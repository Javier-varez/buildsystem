## Builds a native test
#   LOCAL_NAME          := Name of the target
#   LOCAL_SRC           := Source file paths relative to the top of the tree
#   LOCAL_CFLAGS        := Flags passed to the C compiler
#   LOCAL_CXXFLAGS      := Flags passed to the C++ compiler
#   LOCAL_LDFLAGS       := Flags passed to the linker
#   LOCAL_ASFLAGS       := Flags for the assembler
#   LOCAL_SHARED_LIBS   := Shared libraries to link
#   LOCAL_STATIC_LIBS   := Static libraries to link
#   LOCAL_MULTILIB      := Set it to 32 to build a 32 bit test. 
#                          By default it will use 64 bit.
#   CC                  := C Compiler
#   CXX                 := C++ Compiler. Used as linker too
#   AS                  := Assembler.
#   LOCAL_PREREQUISITES := Additional dependencies

CURRENT_MK              := $(lastword $(MAKEFILE_LIST))
PARENT_MK               := $(LOCAL_DIR)/build.mk
MK_DEPS                 := $(CURRENT_MK) $(PARENT_MK)
LOCAL_TARGET            := $(BUILD_TEST_DIR)/$(LOCAL_NAME)
LOCAL_LDFLAGS           += $(addprefix -T, $(LOCAL_LINKER_FILE))

ifeq ($(LOCAL_MULTILIB),32)
LOCAL_CFLAGS += -m32
LOCAL_CXXFLAGS += -m32
LOCAL_STATIC_LIBS       += libgmock_main32 libgmock32
else
LOCAL_STATIC_LIBS       += libgmock_main libgmock
endif
LOCAL_LDFLAGS           += -pthread

include $(BUILD_SYSTEM_DIR)/build_binary_common.mk

$(LOCAL_TARGET): INTERNAL_CXX := $(LOCAL_CXX)
$(LOCAL_TARGET): INTERNAL_CXXFLAGS := $(LOCAL_CXXFLAGS)
$(LOCAL_TARGET): INTERNAL_LDFLAGS := $(LOCAL_LDFLAGS)
$(LOCAL_TARGET): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_TARGET): INTERNAL_OBJ := $(LOCAL_OBJ)
$(LOCAL_TARGET): $(LOCAL_OBJ) $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(MK_DEPS) $(LOCAL_LINKER_FILE) $(LOCAL_PREREQUISITES)
	$(call print-build-header, $(INTERNAL_TARGET_NAME), LD)
	$(MKDIR) $(dir $@)
	$(SILENT)$(INTERNAL_CXX) $(INTERNAL_CXXFLAGS) -o $@ $(INTERNAL_OBJ) $(INTERNAL_LDFLAGS)

run_$(LOCAL_NAME): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
run_$(LOCAL_NAME): $(LOCAL_TARGET)
	$(call print-build-header, $(INTERNAL_TARGET_NAME), RUN)
	$(SILENT)LD_LIBRARY_PATH=$(BUILD_LIBS_DIR) $<
.PHONY: run_$(LOCAL_NAME)

tests: $(LOCAL_NAME)

run_tests: run_$(LOCAL_NAME)
