define current-dir
$(dir $(lastword $(MAKEFILE_LIST)))
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