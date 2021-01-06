BUILD_SYSTEM_DIR        ?= .
BUILD_DIR               ?= build
SYMLINK_COMP_DB         ?= . # Clear this variable if you don't want to generate the symlink
BUILD_TARGET_DIR        := $(BUILD_DIR)/targets
BUILD_INTERMEDIATES_DIR := $(BUILD_DIR)/intermediates
BUILD_LIBS_DIR          := $(BUILD_DIR)/lib
BUILD_COMP_DB_FILE      := $(BUILD_DIR)/compile_commands.json

BUILD_BINARY            := $(BUILD_SYSTEM_DIR)/build_binary.mk
BUILD_SHARED_LIB        := $(BUILD_SYSTEM_DIR)/build_shared_lib.mk
BUILD_STATIC_LIB        := $(BUILD_SYSTEM_DIR)/build_static_lib.mk
CLEAR_VARS              := $(BUILD_SYSTEM_DIR)/clear_vars.mk

GREEN_BOLD_COLOR        := \e[32;1m
RESET_COLOR             := \e[39;0m

include $(BUILD_SYSTEM_DIR)/definitions.mk

SILENT                  ?= @
MKDIR                   := $(SILENT)mkdir -p
ECHO                    := $(SILENT)echo
RM                      := $(SILENT)rm
CP                      := $(SILENT)cp

ALL_DB_FILES            :=

#default rule, don't move
all: compdb all_targets
.PHONY: all

all_targets:
.PHONY: all_targets

compdb: $(BUILD_COMP_DB_FILE)
.PHONY: compdb

# Merge partial compilation database files
$(BUILD_COMP_DB_FILE):
	$(call print-build-header, COMP_DB,)
	$(if $(ALL_DB_FILES), $(shell sed -e '1s/^/[\n/' -e '$$s/,$$/\n]/' $(ALL_DB_FILES) > $@))
	$(if $(SYMLINK_COMP_DB), $(shell ln -s -f $@ $(addsuffix /compile_commands.json, $(SYMLINK_COMP_DB))))

clean:
	$(ECHO) "Removing build directory"
	$(RM) -rf $(BUILD_DIR)
