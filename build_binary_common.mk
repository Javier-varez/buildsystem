MK_DEPS                 += $(lastword $(MAKEFILE_LIST))

LOCAL_INTERMEDIATES     := $(BUILD_INTERMEDIATES_DIR)/$(LOCAL_NAME)

LOCAL_SRC               += $(LOCAL_GENERATED_SOURCES)
LOCAL_PREREQUISITES     += $(LOCAL_GENERATED_SOURCES)

# Sources
LOCAL_C_SRC             := $(filter %.c, $(LOCAL_SRC))
LOCAL_CXX_SRC           := $(filter %.cpp, $(LOCAL_SRC))
LOCAL_CC_SRC            := $(filter %.cc, $(LOCAL_SRC))
LOCAL_S_SRC             := $(filter %.s, $(LOCAL_SRC))

# Objects
LOCAL_C_OBJ             := $(addprefix $(LOCAL_INTERMEDIATES)/, $(patsubst %.c, %.o, $(LOCAL_C_SRC)))
LOCAL_CXX_OBJ           := $(addprefix $(LOCAL_INTERMEDIATES)/, $(patsubst %.cpp, %.o, $(LOCAL_CXX_SRC)))
LOCAL_CC_OBJ            := $(addprefix $(LOCAL_INTERMEDIATES)/, $(patsubst %.cc, %.o, $(LOCAL_CC_SRC)))
LOCAL_S_OBJ             := $(addprefix $(LOCAL_INTERMEDIATES)/, $(patsubst %.s, %.o, $(LOCAL_S_SRC)))
LOCAL_OBJ               := $(LOCAL_C_OBJ) \
                           $(LOCAL_CXX_OBJ) \
                           $(LOCAL_CC_OBJ) \
                           $(LOCAL_S_OBJ)

# Toolchain binaries
LOCAL_CC                := $(LOCAL_CROSS_COMPILE)$(CC)
LOCAL_CXX               := $(LOCAL_CROSS_COMPILE)$(CXX)
LOCAL_AS                := $(LOCAL_CROSS_COMPILE)$(AS)
LOCAL_AR                := $(LOCAL_CROSS_COMPILE)$(AR)

# Apply compiler profile
-include $(CONFIG_DIR)/$(LOCAL_COMPILER).mk

LOCAL_C_DB_FILES := $(patsubst %.o, %.db, $(LOCAL_C_OBJ))
LOCAL_CXX_DB_FILES := $(patsubst %.o, %.db, $(LOCAL_CXX_OBJ))
LOCAL_CC_DB_FILES := $(patsubst %.o, %.db, $(LOCAL_CC_OBJ))
LOCAL_DB_FILES := \
    $(LOCAL_C_DB_FILES) \
    $(LOCAL_CXX_DB_FILES) \
    $(LOCAL_CC_DB_FILES)
ALL_DB_FILES += $(LOCAL_DB_FILES)
$(BUILD_COMP_DB_FILE): $(LOCAL_DB_FILES)

LOCAL_CFLAGS += $(LOCAL_COMPILER_CFLAGS)
LOCAL_CXXFLAGS += $(LOCAL_COMPILER_CXXFLAGS)
LOCAL_LDFLAGS += $(LOCAL_COMPILER_LDFLAGS)

# Add generated sources dir to includes
LOCAL_CFLAGS += -I$(local-generated-sources-dir)
LOCAL_CXXFLAGS += -I$(local-generated-sources-dir)

# Library sources
LOCAL_SHARED_LIB_PATHS  := $(foreach lib, $(LOCAL_SHARED_LIBS), $(BUILD_LIBS_DIR)/$(lib).so)
LOCAL_STATIC_LIB_PATHS  := $(foreach lib, $(LOCAL_STATIC_LIBS), $(BUILD_LIBS_DIR)/$(lib).a)
LOCAL_LIBS              := $(LOCAL_SHARED_LIBS) $(LOCAL_STATIC_LIBS)
LOCAL_LDFLAGS           := $(addprefix -L, $(patsubst %/, %, $(dir $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS)))) \
			   $(addprefix -l, $(patsubst lib%.a, %, $(notdir $(LOCAL_STATIC_LIB_PATHS)))) \
			   $(addprefix -l, $(patsubst lib%.so, %, $(notdir $(LOCAL_SHARED_LIB_PATHS)))) \
			   $(LOCAL_LDFLAGS)

# Rules
$(LOCAL_C_OBJ): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_C_OBJ): INTERNAL_CC := $(LOCAL_CC)
$(LOCAL_C_OBJ): INTERNAL_CFLAGS := $(LOCAL_CFLAGS)
$(LOCAL_C_OBJ): INTERNAL_LIBS := $(LOCAL_LIBS)
$(LOCAL_C_OBJ): $(LOCAL_INTERMEDIATES)/%.o: %.c $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(MK_DEPS) $(LOCAL_PREREQUISITES)
	$(call print-build-header, $(INTERNAL_TARGET_NAME), CC $(notdir $<))
	$(MKDIR) $(dir $@)
	$(call generate-include-exports-for-target, $(INTERNAL_LIBS))
	$(SILENT)$(INTERNAL_CC) -c $(INTERNAL_CFLAGS) $(LIB_INCLUDE_DIRS) -o $@ $< -MMD

$(LOCAL_C_DB_FILES): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_C_DB_FILES): INTERNAL_CC := $(LOCAL_CC)
$(LOCAL_C_DB_FILES): INTERNAL_CFLAGS := $(LOCAL_CFLAGS)
$(LOCAL_C_DB_FILES): INTERNAL_LIBS := $(LOCAL_LIBS)
$(LOCAL_C_DB_FILES): $(LOCAL_INTERMEDIATES)/%.db: %.c $(MK_DEPS)
	$(call print-build-header, $(INTERNAL_TARGET_NAME), DB $(notdir $<))
	$(MKDIR) $(dir $@)
	$(call generate-include-exports-for-target, $(INTERNAL_LIBS))
	$(GEN_COMPDB) --command "$(INTERNAL_CC) -c $(INTERNAL_CFLAGS) $(LIB_INCLUDE_DIRS) -o $(patsubst %.db, %.o, $@) $< -MMD" --file $< --output $@

$(LOCAL_CXX_OBJ): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_CXX_OBJ): INTERNAL_CXX := $(LOCAL_CXX)
$(LOCAL_CXX_OBJ): INTERNAL_CXXFLAGS := $(LOCAL_CXXFLAGS)
$(LOCAL_CXX_OBJ): INTERNAL_LIBS := $(LOCAL_LIBS)
$(LOCAL_CXX_OBJ): $(LOCAL_INTERMEDIATES)/%.o: %.cpp $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(MK_DEPS) $(LOCAL_PREREQUISITES)
	$(call print-build-header, $(INTERNAL_TARGET_NAME), CXX $(notdir $<))
	$(MKDIR) $(dir $@)
	$(call generate-include-exports-for-target, $(INTERNAL_LIBS))
	$(SILENT)$(INTERNAL_CXX) -c $(INTERNAL_CXXFLAGS) $(LIB_INCLUDE_DIRS) -o $@ $< -MMD

$(LOCAL_CXX_DB_FILES): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_CXX_DB_FILES): INTERNAL_CXX := $(LOCAL_CXX)
$(LOCAL_CXX_DB_FILES): INTERNAL_CXXFLAGS := $(LOCAL_CXXFLAGS)
$(LOCAL_CXX_DB_FILES): INTERNAL_LIBS := $(LOCAL_LIBS)
$(LOCAL_CXX_DB_FILES): $(LOCAL_INTERMEDIATES)/%.db: %.cpp $(MK_DEPS)
	$(call print-build-header, $(INTERNAL_TARGET_NAME), DB $(notdir $<))
	$(MKDIR) $(dir $@)
	$(call generate-include-exports-for-target, $(INTERNAL_LIBS))
	$(GEN_COMPDB) --command "$(INTERNAL_CXX) -c $(INTERNAL_CXXFLAGS) $(LIB_INCLUDE_DIRS) -o $(patsubst %.db, %.o, $@) $< -MMD" --file $< --output $@

$(LOCAL_CC_OBJ): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_CC_OBJ): INTERNAL_CXX := $(LOCAL_CXX)
$(LOCAL_CC_OBJ): INTERNAL_CXXFLAGS := $(LOCAL_CXXFLAGS)
$(LOCAL_CC_OBJ): INTERNAL_LIBS := $(LOCAL_LIBS)
$(LOCAL_CC_OBJ): $(LOCAL_INTERMEDIATES)/%.o: %.cc $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(MK_DEPS) $(LOCAL_PREREQUISITES)
	$(call print-build-header, $(INTERNAL_TARGET_NAME), CXX $(notdir $<))
	$(MKDIR) $(dir $@)
	$(call generate-include-exports-for-target, $(INTERNAL_LIBS))
	$(SILENT)$(INTERNAL_CXX) -c $(INTERNAL_CXXFLAGS) $(LIB_INCLUDE_DIRS) -o $@ $< -MMD

$(LOCAL_CC_DB_FILES): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_CC_DB_FILES): INTERNAL_CXX := $(LOCAL_CXX)
$(LOCAL_CC_DB_FILES): INTERNAL_CXXFLAGS := $(LOCAL_CXXFLAGS)
$(LOCAL_CC_DB_FILES): INTERNAL_LIBS := $(LOCAL_LIBS)
$(LOCAL_CC_DB_FILES): $(LOCAL_INTERMEDIATES)/%.db: %.cc $(MK_DEPS)
	$(call print-build-header, $(INTERNAL_TARGET_NAME), DB $(notdir $<))
	$(MKDIR) $(dir $@)
	$(call generate-include-exports-for-target, $(INTERNAL_LIBS))
	$(GEN_COMPDB) --command "$(INTERNAL_CXX) -c $(INTERNAL_CXXFLAGS) $(LIB_INCLUDE_DIRS) -o $(patsubst %.db, %.o, $@) $< -MMD" --file $< --output $@

$(LOCAL_S_OBJ): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_S_OBJ): INTERNAL_AS := $(LOCAL_AS)
$(LOCAL_S_OBJ): INTERNAL_ASFLAGS := $(LOCAL_ASFLAGS)
$(LOCAL_S_OBJ): $(LOCAL_INTERMEDIATES)/%.o: %.s $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(MK_DEPS) $(LOCAL_PREREQUISITES)
	$(call print-build-header, $(INTERNAL_TARGET_NAME), AS $(notdir $<))
	$(MKDIR) $(dir $@)
	$(SILENT)$(INTERNAL_AS) -c $(INTERNAL_ASFLAGS) -o $@ $<

# Create phony target for the LOCAL_NAME
$(LOCAL_NAME): $(LOCAL_TARGET)
.PHONY: $(LOCAL_NAME)

clean_$(LOCAL_NAME): INTERNAL_INTERMEDIATES := $(LOCAL_INTERMEDIATES)
clean_$(LOCAL_NAME): INTERNAL_TARGET := $(LOCAL_TARGET)
clean_$(LOCAL_NAME)::
	rm -rf $(INTERNAL_INTERMEDIATES)
	rm -f $(INTERNAL_TARGET)
.PHONY: clean_$(LOCAL_NAME)

# Include generated dependencies
-include $(patsubst %.o, %.d, $(LOCAL_OBJ))
