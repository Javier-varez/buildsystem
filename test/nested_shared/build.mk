LOCAL_DIR := $(call current-dir)

CC := clang
CXX := clang++

include $(CLEAR_VARS)
LOCAL_NAME := test_nested_shared
LOCAL_CFLAGS := \
	-I$(LOCAL_DIR)/inc \
	-I$(LOCAL_DIR)/exported
LOCAL_CXXFLAGS := \
	$(LOCAL_CFLAGS)
LOCAL_SRC := \
	$(wildcard $(LOCAL_DIR)/src/*.cpp)
LOCAL_EXPORTED_DIRS := \
	$(LOCAL_DIR)/exported
include $(BUILD_SHARED_LIB)


