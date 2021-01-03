CURRENT_MK              := $(lastword $(MAKEFILE_LIST))
LOCAL_NAME              := $(addprefix lib, $(LOCAL_NAME))
LOCAL_OUT_DIR           := $(BUILD_LIBS_DIR)/$(LOCAL_NAME)
LOCAL_TARGET            := $(LOCAL_OUT_DIR)/$(LOCAL_NAME).so
LOCAL_INTERMEDIATES     := $(BUILD_INTERMEDIATES_DIR)/$(LOCAL_NAME)
LOCAL_LDFLAGS           += $(addprefix -T, $(LOCAL_LINKER_FILE))
LOCAL_C_SRC             := $(filter %.c, $(LOCAL_SRC))
LOCAL_CXX_SRC           := $(filter %.cpp %.cc, $(LOCAL_SRC))
LOCAL_S_SRC             := $(filter %.s, $(LOCAL_SRC))
LOCAL_C_OBJ             := $(addprefix $(LOCAL_INTERMEDIATES)/, $(patsubst %.c, %.o, $(LOCAL_C_SRC)))
LOCAL_CXX_OBJ           := $(addprefix $(LOCAL_INTERMEDIATES)/, $(patsubst %.cpp, %.o, $(filter %.cpp, $(LOCAL_CXX_SRC))))
LOCAL_CXX_OBJ           += $(addprefix $(LOCAL_INTERMEDIATES)/, $(patsubst %.cc, %.o, $(filter %.cc, $(LOCAL_CXX_SRC))))
LOCAL_S_OBJ             := $(addprefix $(LOCAL_INTERMEDIATES)/, $(patsubst %.s, %.o, $(LOCAL_S_SRC)))
LOCAL_OBJ               := $(LOCAL_C_OBJ) \
                           $(LOCAL_CXX_OBJ) \
		           $(LOCAL_S_OBJ)
LOCAL_CC                := $(SILENT)$(LOCAL_CROSS_COMPILE)$(CC)
LOCAL_CXX               := $(SILENT)$(LOCAL_CROSS_COMPILE)$(CXX)
LOCAL_LD                := $(SILENT)$(LOCAL_CROSS_COMPILE)$(LD)
LOCAL_AS                := $(SILENT)$(LOCAL_CROSS_COMPILE)$(AS)
LOCAL_SHARED_LIB_PATHS  := $(foreach lib, $(LOCAL_SHARED_LIBS), $(BUILD_LIBS_DIR)/$(lib)/$(lib).so)
LOCAL_STATIC_LIB_PATHS  := $(foreach lib, $(LOCAL_STATIC_LIBS), $(BUILD_LIBS_DIR)/$(lib)/$(lib).a)
LOCAL_LIBS              := $(LOCAL_SHARED_LIBS) $(LOCAL_STATIC_LIBS)
LOCAL_EXPORTS           := $(foreach EXPORTED_DIR, $(LOCAL_EXPORTED_DIRS), $(shell find $(EXPORTED_DIR) -name "*.h"))
LOCAL_TARGET_EXPORT_DIR := $(LOCAL_OUT_DIR)/exports
LOCAL_TARGET_EXPORTS    := $(addprefix $(LOCAL_TARGET_EXPORT_DIR)/, $(LOCAL_EXPORTS))
LOCAL_LDFLAGS           := $(addprefix -L, $(patsubst %/, %, $(dir $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS)))) \
			   $(addprefix -l, $(patsubst lib%.a, %, $(notdir $(LOCAL_STATIC_LIB_PATHS)))) \
			   $(addprefix -l, $(patsubst lib%.so, %, $(notdir $(LOCAL_SHARED_LIB_PATHS)))) \
			   $(LOCAL_LDFLAGS)

# We define the exported include directories for other targets that may use them
TARGET_$(LOCAL_NAME)_EXPORT_DIRS := $(addprefix $(LOCAL_TARGET_EXPORT_DIR)/, $(LOCAL_EXPORTED_DIRS))

$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CC := $(LOCAL_CC)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CFLAGS := $(LOCAL_CFLAGS)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_LIBS := $(LOCAL_LIBS)
$(LOCAL_INTERMEDIATES)/%.o: %.c $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(CURRENT_MK) $(LOCAL_DIR)/build.mk
	$(call print-build-header, $(INTERNAL_TARGET_NAME), CC $(notdir $<))
	$(MKDIR) $(dir $@)
	$(eval LIB_INCLUDE_DIRS := $(call get-include-exports-for-libs, $(INTERNAL_LIBS)))
	$(INTERNAL_CC) -c -fPIC $(INTERNAL_CFLAGS) $(LIB_INCLUDE_DIRS) -o $@ $< -MMD

$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CXX := $(LOCAL_CXX)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CXXFLAGS := $(LOCAL_CXXFLAGS)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_LIBS := $(LOCAL_LIBS)
$(LOCAL_INTERMEDIATES)/%.o: %.cpp $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(CURRENT_MK) $(LOCAL_DIR)/build.mk
	$(call print-build-header, $(INTERNAL_TARGET_NAME), CXX $(notdir $<))
	$(MKDIR) $(dir $@)
	$(eval LIB_INCLUDE_DIRS := $(call get-include-exports-for-libs, $(INTERNAL_LIBS)))
	$(INTERNAL_CXX) -c -fPIC $(INTERNAL_CXXFLAGS) $(LIB_INCLUDE_DIRS) -o $@ $< -MMD

$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CXX := $(LOCAL_CXX)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CXXFLAGS := $(LOCAL_CXXFLAGS)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_LIBS := $(LOCAL_LIBS)
$(LOCAL_INTERMEDIATES)/%.o: %.cc $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(CURRENT_MK) $(LOCAL_DIR)/build.mk
	$(call print-build-header, $(INTERNAL_TARGET_NAME), CXX $(notdir $<))
	$(MKDIR) $(dir $@)
	$(eval LIB_INCLUDE_DIRS := $(call get-include-exports-for-libs, $(INTERNAL_LIBS)))
	$(INTERNAL_CXX) -c -fPIC $(INTERNAL_CXXFLAGS) $(LIB_INCLUDE_DIRS) -o $@ $< -MMD

$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_AS := $(LOCAL_AS)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_ASFLAGS := $(LOCAL_ASFLAGS)
$(LOCAL_INTERMEDIATES)/%.o: %.s $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(CURRENT_MK) $(LOCAL_DIR)/build.mk
	$(call print-build-header, $(INTERNAL_TARGET_NAME), AS $(notdir $<))
	$(MKDIR) $(dir $@)
	$(INTERNAL_AS) -c $(INTERNAL_ASFLAGS) -o $@ $< -MMD

$(LOCAL_TARGET): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_TARGET): INTERNAL_CXX := $(LOCAL_CXX)
$(LOCAL_TARGET): INTERNAL_CXXFLAGS := $(LOCAL_CXXFLAGS)
$(LOCAL_TARGET): INTERNAL_LDFLAGS := $(LOCAL_LDFLAGS)
$(LOCAL_TARGET): INTERNAL_OBJ := $(LOCAL_OBJ)
$(LOCAL_TARGET): $(LOCAL_OBJ) $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(LOCAL_TARGET_EXPORTS) $(CURRENT_MK) $(LOCAL_DIR)/build.mk
	$(call print-build-header, $(INTERNAL_TARGET_NAME), LD)
	$(MKDIR) $(dir $@)
	$(INTERNAL_CXX) -shared $(INTERNAL_CXXFLAGS) -o $@ $(INTERNAL_OBJ) $(INTERNAL_LDFLAGS)

$(LOCAL_TARGET_EXPORT_DIR)/%.h: INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_TARGET_EXPORT_DIR)/%.h: INTERNAL_EXPORTED_DIRS := $(LOCAL_EXPORTED_DIRS)
$(LOCAL_TARGET_EXPORT_DIR)/%.h: INTERNAL_TARGET_EXPORT_DIR := $(LOCAL_TARGET_EXPORT_DIR)
$(LOCAL_TARGET_EXPORT_DIR)/%.h: %.h $(CURRENT_MK) $(LOCAL_DIR)/build.mk
	$(call print-build-header, $(INTERNAL_TARGET_NAME), EXPORT $(patsubst $(LOCAL_TARGET_EXPORT_DIR)/%h, %h, $@))
	$(MKDIR) $(dir $@)
	$(CP) $< $@
	$(SILENT) # Generate dependency file
	$(ECHO) "$@: $(INCFILE)" > $(patsubst %.h, %.d, $@)

$(LOCAL_NAME): $(LOCAL_TARGET)
.PHONY: $(LOCAL_NAME)

all: $(LOCAL_NAME)

# Include autogenerated dependencies
-include $(patsubst %.o, %.d, $(LOCAL_OBJ))
-include $(patsubst %.h, %.d, $(LOCAL_TARGET_EXPORTS))
