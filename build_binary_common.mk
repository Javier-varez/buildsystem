CURRENT_MK              += $(lastword $(MAKEFILE_LIST))

LOCAL_INTERMEDIATES     := $(BUILD_INTERMEDIATES_DIR)/$(LOCAL_NAME)

# Sources
LOCAL_C_SRC             := $(filter %.c, $(LOCAL_SRC))
LOCAL_CXX_SRC           := $(filter %.cpp %.cc, $(LOCAL_SRC))
LOCAL_S_SRC             := $(filter %.s, $(LOCAL_SRC))

# Objects
LOCAL_C_OBJ             := $(addprefix $(LOCAL_INTERMEDIATES)/, $(patsubst %.c, %.o, $(LOCAL_C_SRC)))
LOCAL_CXX_OBJ           := $(addprefix $(LOCAL_INTERMEDIATES)/, $(patsubst %.cpp, %.o, $(filter %.cpp, $(LOCAL_CXX_SRC))))
LOCAL_CXX_OBJ           += $(addprefix $(LOCAL_INTERMEDIATES)/, $(patsubst %.cc, %.o, $(filter %.cc, $(LOCAL_CXX_SRC))))
LOCAL_S_OBJ             := $(addprefix $(LOCAL_INTERMEDIATES)/, $(patsubst %.s, %.o, $(LOCAL_S_SRC)))
LOCAL_OBJ               := $(LOCAL_C_OBJ) \
                           $(LOCAL_CXX_OBJ) \
                           $(LOCAL_S_OBJ)

# Toolchain binaries
LOCAL_CC                := $(LOCAL_CROSS_COMPILE)$(CC)
LOCAL_CXX               := $(LOCAL_CROSS_COMPILE)$(CXX)
LOCAL_AS                := $(LOCAL_CROSS_COMPILE)$(AS)
LOCAL_AR                := $(LOCAL_CROSS_COMPILE)$(AR)

# Apply compiler profile
-include $(CONFIG_DIR)/$(LOCAL_COMPILER).mk

ALL_DB_FILES += $(patsubst %.o, %.db, $(LOCAL_C_OBJ))
ALL_DB_FILES += $(patsubst %.o, %.db, $(LOCAL_CXX_OBJ))
$(BUILD_COMP_DB_FILE): $(LOCAL_TARGET)

LOCAL_CFLAGS += $(LOCAL_COMPILER_CFLAGS)
LOCAL_CXXFLAGS += $(LOCAL_COMPILER_CXXFLAGS)
LOCAL_LDFLAGS += $(LOCAL_COMPILER_LDFLAGS)

# Library sources
LOCAL_SHARED_LIB_PATHS  := $(foreach lib, $(LOCAL_SHARED_LIBS), $(BUILD_LIBS_DIR)/$(lib).so)
LOCAL_STATIC_LIB_PATHS  := $(foreach lib, $(LOCAL_STATIC_LIBS), $(BUILD_LIBS_DIR)/$(lib).a)
LOCAL_LIBS              := $(LOCAL_SHARED_LIBS) $(LOCAL_STATIC_LIBS)
LOCAL_LDFLAGS           := $(addprefix -L, $(patsubst %/, %, $(dir $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS)))) \
			   $(addprefix -l, $(patsubst lib%.a, %, $(notdir $(LOCAL_STATIC_LIB_PATHS)))) \
			   $(addprefix -l, $(patsubst lib%.so, %, $(notdir $(LOCAL_SHARED_LIB_PATHS)))) \
			   $(LOCAL_LDFLAGS)

# Rules
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CC := $(LOCAL_CC)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CFLAGS := $(LOCAL_CFLAGS)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_LIBS := $(LOCAL_LIBS)
$(LOCAL_INTERMEDIATES)/%.o: %.c $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(CURRENT_MK) $(LOCAL_DIR)/build.mk
	$(call print-build-header, $(INTERNAL_TARGET_NAME), CC $(notdir $<))
	$(MKDIR) $(dir $@)
	$(call generate-include-exports-for-target, $(INTERNAL_LIBS))
	$(call trace-c-build, $@, $(INTERNAL_CC) -c $(INTERNAL_CFLAGS) $(LIB_INCLUDE_DIRS) -o $@ $< -MMD)

$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CXX := $(LOCAL_CXX)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CXXFLAGS := $(LOCAL_CXXFLAGS)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_LIBS := $(LOCAL_LIBS)
$(LOCAL_INTERMEDIATES)/%.o: %.cpp $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(CURRENT_MK) $(LOCAL_DIR)/build.mk
	$(call print-build-header, $(INTERNAL_TARGET_NAME), CXX $(notdir $<))
	$(MKDIR) $(dir $@)
	$(call generate-include-exports-for-target, $(INTERNAL_LIBS))
	$(call trace-c++-build, $@, $(INTERNAL_CXX) -c $(INTERNAL_CXXFLAGS) $(LIB_INCLUDE_DIRS) -o $@ $< -MMD)

$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CXX := $(LOCAL_CXX)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_CXXFLAGS := $(LOCAL_CXXFLAGS)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_LIBS := $(LOCAL_LIBS)
$(LOCAL_INTERMEDIATES)/%.o: %.cc $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(CURRENT_MK) $(LOCAL_DIR)/build.mk
	$(call print-build-header, $(INTERNAL_TARGET_NAME), CXX $(notdir $<))
	$(MKDIR) $(dir $@)
	$(call generate-include-exports-for-target, $(INTERNAL_LIBS))
	$(call trace-c++-build, $@, $(INTERNAL_CXX) -c $(INTERNAL_CXXFLAGS) $(LIB_INCLUDE_DIRS) -o $@ $< -MMD)

$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_AS := $(LOCAL_AS)
$(LOCAL_INTERMEDIATES)/%.o: INTERNAL_ASFLAGS := $(LOCAL_ASFLAGS)
$(LOCAL_INTERMEDIATES)/%.o: %.s $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(CURRENT_MK) $(LOCAL_DIR)/build.mk
	$(call print-build-header, $(INTERNAL_TARGET_NAME), AS $(notdir $<))
	$(MKDIR) $(dir $@)
	$(INTERNAL_AS) -c $(INTERNAL_ASFLAGS) -o $@ $< -MMD

# Link target to all and create phony target for the LOCAL_NAME
$(LOCAL_NAME): $(LOCAL_TARGET)
.PHONY: $(LOCAL_NAME)

clean_$(LOCAL_NAME): INTERNAL_INTERMEDIATES := $(LOCAL_INTERMEDIATES)
clean_$(LOCAL_NAME): INTERNAL_TARGET := $(LOCAL_TARGET)
clean_$(LOCAL_NAME)::
	rm -rf $(INTERNAL_INTERMEDIATES)
	rm -f $(INTERNAL_TARGET)
.PHONY: clean_$(LOCAL_NAME)

all_targets: $(LOCAL_TARGET)

# Include generated dependencies
-include $(patsubst %.o, %.d, $(LOCAL_OBJ))
