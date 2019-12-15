BUILD_SYSTEM_DIR        ?= .
BUILD_DIR               ?= build
BUILD_TARGET_DIR        := $(BUILD_DIR)/targets
BUILD_INTERMEDIATES_DIR := $(BUILD_DIR)/intermediates
BUILD_LIBS_DIR          := $(BUILD_DIR)/lib

BUILD_BINARY            := $(BUILD_SYSTEM_DIR)/build_binary.mk
BUILD_SHARED_LIB        := $(BUILD_SYSTEM_DIR)/build_shared_lib.mk
BUILD_STATIC_LIB        := $(BUILD_SYSTEM_DIR)/build_static_lib.mk
CLEAR_VARS              := $(BUILD_SYSTEM_DIR)/clear_vars.mk

include $(BUILD_SYSTEM_DIR)/definitions.mk

SILENT                  := @
MKDIR                   := $(SILENT)mkdir -p
ECHO                    := $(SILENT)echo
RM                      := $(SILENT)rm
CP                      := $(SILENT)cp

#default rule
all:

clean:
	$(ECHO) "Removing build directory"
	$(RM) -rf $(BUILD_DIR)
