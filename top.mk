BUILD_SYSTEM_DIR        ?= .
BUILD_DIR               ?= build
SYMLINK_COMP_DB         ?= . # Clear this variable if you don't want to generate the symlink
CONFIG_DIR              := $(BUILD_SYSTEM_DIR)/config

BUILD_TARGET_DIR        := $(BUILD_DIR)/targets
BUILD_TEST_DIR          := $(BUILD_DIR)/tests
BUILD_INTERMEDIATES_DIR := $(BUILD_DIR)/intermediates
BUILD_GENERATED_SRC_DIR := $(BUILD_DIR)/gensrcs
BUILD_LIBS_DIR          := $(BUILD_DIR)/lib
BUILD_LINKER_SCRIPT_DIR := $(BUILD_DIR)/linker_script
BUILD_COMP_DB_FILE      := $(BUILD_DIR)/compile_commands.json

BUILD_BINARY            := $(BUILD_SYSTEM_DIR)/build_binary.mk
BUILD_SHARED_LIB        := $(BUILD_SYSTEM_DIR)/build_shared_lib.mk
BUILD_STATIC_LIB        := $(BUILD_SYSTEM_DIR)/build_static_lib.mk
BUILD_HOST_TEST         := $(BUILD_SYSTEM_DIR)/build_host_test.mk
CLEAR_VARS              := $(BUILD_SYSTEM_DIR)/clear_vars.mk

GREEN_BOLD_COLOR        := \e[32;1m
RESET_COLOR             := \e[39;0m

include $(BUILD_SYSTEM_DIR)/definitions.mk

SILENT                  ?= @
MKDIR                   := $(SILENT)mkdir -p
ECHO                    := $(SILENT)echo
RM                      := $(SILENT)rm
CP                      := $(SILENT)cp
BEAR                    := $(SILENT)bear
MERGE_COMPDB            := $(SILENT)$(BUILD_SYSTEM_DIR)/merge_compdb.py

ALL_DB_FILES            :=

#default rule, don't move
all: all_targets
.PHONY: all

# Builds all targets
all_targets:
.PHONY: all_targets

# Runs all tests
run_tests:
.PHONY: run_tests

tests:
.PHONY: tests

compdb: $(BUILD_COMP_DB_FILE)
.PHONY: compdb

# Merge partial compilation database files
$(BUILD_COMP_DB_FILE):
	$(call print-build-header, COMP_DB,)
	$(MERGE_COMPDB) --output $@ --files $^
	$(if $(SYMLINK_COMP_DB), $(shell ln -s -f $@ $(addsuffix /compile_commands.json, $(SYMLINK_COMP_DB))))

clean:
	$(ECHO) "Removing build directory"
	$(RM) -rf $(BUILD_DIR)

%.db: %.o ;

include $(BUILD_SYSTEM_DIR)/gtest/build.mk
