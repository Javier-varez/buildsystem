
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
