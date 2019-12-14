define current-dir
$(dir $(lastword $(MAKEFILE_LIST)))
endef

define all-makefiles-under
$(wildcard $(1)/*/build.mk)
endef
