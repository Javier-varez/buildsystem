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

define get-include-exports-for-libs
$(foreach LIB_TARGET_NAME, $(1), $(addprefix -I, $(TARGET_$(LIB_TARGET_NAME)_EXPORT_DIRS)))
endef
