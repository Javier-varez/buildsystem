LOCAL_DIR := $(call current-dir)

CC := gcc
CXX := g++

include $(CLEAR_VARS)
LOCAL_NAME := test_nested_static
LOCAL_CFLAGS := \
	-I$(LOCAL_DIR)/inc \
	-I$(LOCAL_DIR)/exported
LOCAL_CXXFLAGS := \
	$(LOCAL_CFLAGS)
LOCAL_ARFLAGS := -rcs
LOCAL_SRC := \
	$(wildcard $(LOCAL_DIR)/src/*.cpp)
LOCAL_EXPORTED_DIRS := \
	$(LOCAL_DIR)/exported
include $(BUILD_STATIC_LIB)

