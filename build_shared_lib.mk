CURRENT_MK              := $(lastword $(MAKEFILE_LIST))
LOCAL_NAME              := $(addprefix lib, $(LOCAL_NAME))
LOCAL_OUT_DIR           := $(BUILD_LIBS_DIR)/$(LOCAL_NAME)
LOCAL_TARGET            := $(BUILD_LIBS_DIR)/$(LOCAL_NAME).so

include $(BUILD_SYSTEM_DIR)/build_library_common.mk

$(LOCAL_TARGET): INTERNAL_TARGET_NAME := $(LOCAL_NAME)
$(LOCAL_TARGET): INTERNAL_CXX := $(LOCAL_CXX)
$(LOCAL_TARGET): INTERNAL_CXXFLAGS := $(LOCAL_CXXFLAGS)
$(LOCAL_TARGET): INTERNAL_LDFLAGS := $(LOCAL_LDFLAGS)
$(LOCAL_TARGET): INTERNAL_OBJ := $(LOCAL_OBJ)
$(LOCAL_TARGET): $(LOCAL_OBJ) $(LOCAL_SHARED_LIB_PATHS) $(LOCAL_STATIC_LIB_PATHS) $(LOCAL_TARGET_EXPORTS) $(CURRENT_MK) $(LOCAL_DIR)/build.mk
	$(call print-build-header, $(INTERNAL_TARGET_NAME), LD)
	$(MKDIR) $(dir $@)
	$(INTERNAL_CXX) -shared $(INTERNAL_CXXFLAGS) -o $@ $(INTERNAL_OBJ) $(INTERNAL_LDFLAGS)
