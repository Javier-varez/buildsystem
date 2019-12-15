LOCAL_NAME              := $(addprefix lib, $(LOCAL_NAME))
LOCAL_OUT_DIR           := $(BUILD_LIBS_DIR)/$(LOCAL_NAME)
LOCAL_TARGET            := $(LOCAL_OUT_DIR)/$(LOCAL_NAME).a
LOCAL_INTERMEDIATES     := $(BUILD_INTERMEDIATES_DIR)/$(LOCAL_NAME)
LOCAL_LDFLAGS           += $(addprefix -T, $(LOCAL_LINKER_FILE))
LOCAL_C_SRC             := $(filter %.c, $(LOCAL_SRC))
LOCAL_CXX_SRC           := $(filter %.cpp, $(LOCAL_SRC))
LOCAL_S_SRC             := $(filter %.s, $(LOCAL_SRC))
LOCAL_C_OBJ             := $(addprefix $(LOCAL_INTERMEDIATES)/, $(patsubst %.c, %.o, $(LOCAL_C_SRC)))
LOCAL_CXX_OBJ           := $(addprefix $(LOCAL_INTERMEDIATES)/, $(patsubst %.cpp, %.o, $(LOCAL_CXX_SRC)))
LOCAL_S_OBJ             := $(addprefix $(LOCAL_INTERMEDIATES)/, $(patsubst %.s, %.o, $(LOCAL_S_SRC)))
LOCAL_OBJ               := $(LOCAL_C_OBJ) \
                           $(LOCAL_CXX_OBJ) \
                           $(LOCAL_S_OBJ)
LOCAL_CC                := $(SILENT)$(LOCAL_CROSS_COMPILE)$(CC)
LOCAL_CXX               := $(SILENT)$(LOCAL_CROSS_COMPILE)$(CXX)
LOCAL_LD                := $(SILENT)$(LOCAL_CROSS_COMPILE)$(LD)
LOCAL_AS                := $(SILENT)$(LOCAL_CROSS_COMPILE)$(AS)
LOCAL_AR                := $(SILENT)$(LOCAL_CROSS_COMPILE)$(AR)
LOCAL_TARGET_EXPORT_DIR := $(LOCAL_OUT_DIR)/exports
LOCAL_TARGET_EXPORTS    := $(addprefix $(LOCAL_TARGET_EXPORT_DIR)/, $(notdir $(wildcard $(addsuffix /*.h, $(LOCAL_EXPORTED_DIRS)))))

$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CC := $(LOCAL_CC)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CFLAGS := $(LOCAL_CFLAGS)
$(LOCAL_INTERMEDIATES)/%.o: %.c
	$(call print-build-header, $(INTERNAL_TARGET_NAME), CC $(notdir $<))
	$(MKDIR) $(dir $@)
	$(INTERNAL_CC) -c $(INTERNAL_CFLAGS) -o $@ $< -MMD

$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CXX := $(LOCAL_CXX)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CXXFLAGS := $(LOCAL_CXXFLAGS)
$(LOCAL_INTERMEDIATES)/%.o: %.cpp
	$(call print-build-header, $(INTERNAL_TARGET_NAME), CXX $(notdir $<))
	$(MKDIR) $(dir $@)
	$(INTERNAL_CXX) -c $(INTERNAL_CXXFLAGS) -o $@ $< -MMD

$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_AS := $(LOCAL_AS)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_ASFLAGS := $(LOCAL_ASFLAGS)
$(LOCAL_INTERMEDIATES)/%.o: %.s
	$(call print-build-header, $(INTERNAL_TARGET_NAME), AS $(notdir $<))
	$(MKDIR) $(dir $@)
	$(INTERNAL_AS) -c $(INTERNAL_ASFLAGS) -o $@ $< -MMD

$(LOCAL_TARGET): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_TARGET): INTERNAL_AR := $(LOCAL_AR)
$(LOCAL_TARGET): INTERNAL_ARFLAGS := $(LOCAL_ARFLAGS)
$(LOCAL_TARGET): INTERNAL_OBJ := $(LOCAL_OBJ)
$(LOCAL_TARGET): $(LOCAL_OBJ) $(LOCAL_TARGET_EXPORTS)
	$(call print-build-header, $(INTERNAL_TARGET_NAME), AR)
	$(MKDIR) $(dir $@)
	$(INTERNAL_AR) $(INTERNAL_ARFLAGS) $@ $(INTERNAL_OBJ)

$(LOCAL_TARGET_EXPORT_DIR)/%.h: INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_TARGET_EXPORT_DIR)/%.h: INTERNAL_EXPORTED_DIRS := $(LOCAL_EXPORTED_DIRS)
$(LOCAL_TARGET_EXPORT_DIR)/%.h:
	$(call print-build-header, $(INTERNAL_TARGET_NAME), EXPORT $(notdir $@))
	$(MKDIR) $(dir $@)
	$(SILENT) # Find origin file from $(INTERNAL_EXPORTED_DIRS) and make sure that only 1 matches
	$(eval INCFILE := $(wildcard $(addsuffix /$(notdir $@), $(INTERNAL_EXPORTED_DIRS))))
	$(if $(filter-out 1, $(words $(INCFILE))), $(error more than one origin file found: $(INCFILE)))
	$(CP) $(INCFILE) $@
	$(SILENT) # Generate dependency file
	$(ECHO) "$@: $(INCFILE)" > $(patsubst %.h, %.d, $@)

$(LOCAL_NAME): $(LOCAL_TARGET)
.PHONY: $(LOCAL_NAME)

all: $(LOCAL_NAME)

# Include autogenerated dependencies
-include $(patsubst %.o, %.d, $(LOCAL_OBJ))
-include $(patsubst %.h, %.d, $(LOCAL_TARGET_EXPORTS))
