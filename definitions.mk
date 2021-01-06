
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

# Generates the target partial compilation database (-MJ option) when using clang.
# Updates the COMP_DB variable.
# $(1): selected compiler
# $(2): current target
define generate-target-db
$(eval COMP_DB := $(if $(findstring clang, $(1)), -MJ $(patsubst %.o, %.db, $(2)), ))
endef
