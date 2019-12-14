BUILD_DIR               ?= build
BUILD_TARGET_DIR        := $(BUILD_DIR)/targets
BUILD_INTERMEDIATES_DIR := $(BUILD_DIR)/intermediates

BUILD_BINARY            := $(BUILD_SYSTEM_DIR)/build_binary.mk
CLEAR_VARS              := $(BUILD_SYSTEM_DIR)/clear_vars.mk

include $(BUILD_SYSTEM_DIR)/definitions.mk

SILENT                  := @
MKDIR                   := $(SILENT)mkdir -p
ECHO                    := $(SILENT)echo
RM                      := $(SILENT)rm

all:

clean:
	$(ECHO) "Removing build directory"
	$(RM) -rf $(BUILD_DIR)
