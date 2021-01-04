CURRENT_MK              += $(lastword $(MAKEFILE_LIST))

include $(BUILD_SYSTEM_DIR)/build_binary_common.mk

LOCAL_EXPORTS           := $(foreach EXPORTED_DIR, $(LOCAL_EXPORTED_DIRS), $(shell find $(EXPORTED_DIR) -name "*.h"))
LOCAL_TARGET_EXPORT_DIR := $(LOCAL_OUT_DIR)/exports
LOCAL_TARGET_EXPORTS    := $(addprefix $(LOCAL_TARGET_EXPORT_DIR)/, $(LOCAL_EXPORTS))

$(LOCAL_TARGET_EXPORT_DIR)/%.h: INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_TARGET_EXPORT_DIR)/%.h: INTERNAL_EXPORTED_DIRS := $(LOCAL_EXPORTED_DIRS)
$(LOCAL_TARGET_EXPORT_DIR)/%.h: INTERNAL_TARGET_EXPORT_DIR := $(LOCAL_TARGET_EXPORT_DIR)
$(LOCAL_TARGET_EXPORT_DIR)/%.h: %.h $(CURRENT_MK) $(LOCAL_DIR)/build.mk
	$(call print-build-header, $(INTERNAL_TARGET_NAME), EXPORT $(patsubst $(INTERNAL_TARGET_EXPORT_DIR)/%h, %h, $@))
	$(MKDIR) $(dir $@)
	$(CP) $< $@
	$(SILENT) # Generate dependency file
	$(ECHO) "$@: $(INCFILE)" > $(patsubst %.h, %.d, $@)


# We define the exported include directories for other targets that may use them
TARGET_$(LOCAL_NAME)_EXPORT_DIRS := $(addprefix $(LOCAL_TARGET_EXPORT_DIR)/, $(LOCAL_EXPORTED_DIRS))

clean_$(LOCAL_NAME): INTERNAL_TARGET_EXPORT_DIR := $(LOCAL_TARGET_EXPORT_DIR)
clean_$(LOCAL_NAME)::
	rm -rf $(INTERNAL_TARGET_EXPORT_DIR)

# Include autogenerated dependencies
-include $(patsubst %.h, %.d, $(LOCAL_TARGET_EXPORTS))
