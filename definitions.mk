
define current-dir
$(strip $(patsubst %/, %, $(dir $(lastword $(MAKEFILE_LIST)))))
endef

define all-makefiles-under
$(wildcard $(1)/*/build.mk)
endef

define get-build-header
"[$(GREEN_BOLD_COLOR)$(strip $(1))$(RESET_COLOR)] $(strip $(2))"
endef

define print-build-header
$(ECHO) $(call get-build-header, $(1), $(2))
endef

# Updates the LIB_INCLUDE_DIRS variable with the exported directories of linked libraries
# $(1): List of linked libraries for current target
define generate-include-exports-for-target
$(eval LIB_INCLUDE_DIRS := $(foreach LIB_TARGET_NAME, $(1), $(addprefix -I, $(TARGET_$(LIB_TARGET_NAME)_EXPORT_DIRS))))
endef

define trace-c-build
$(BEAR) --use-cc $(INTERNAL_CC) --cdb $(patsubst %.o, %.db, $(1)) bash -c "$(2)"
endef

define trace-c++-build
$(BEAR) --use-c++ $(INTERNAL_CXX) --cdb $(patsubst %.o, %.db, $(1)) bash -c "$(2)"
endef

# Gets the extra linker flags from the internally linked libraries
# $(1): Libraries to link agains (name)
define get-extra-ldflags
$(eval EXTRA_LDFLAGS := $(addprefix $(LD_LINKER_SCRIPT_OPT), $(foreach LIB, $(1), $(TARGET_$(LIB)_LINKER_SCRIPT))))
endef

###########################################################
## Stuff source generated from one-off tools
###########################################################
define transform-generated-source
$(call print-build-header, $(INTERNAL_NAME), GEN_SRC $@)
$(MKDIR) $(dir $@)
$(SILENT) $(INTERNAL_CUSTOM_TOOL)
endef

define local-generated-sources-dir
$(BUILD_GENERATED_SRC_DIR)/$(LOCAL_NAME)
endef
