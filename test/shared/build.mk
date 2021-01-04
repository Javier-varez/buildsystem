LOCAL_DIR := $(call current-dir)

CC := gcc
CXX := g++

include $(CLEAR_VARS)
LOCAL_NAME := test_shared
LOCAL_CFLAGS := \
	-I$(LOCAL_DIR)/inc \
	-I$(LOCAL_DIR)/exported
LOCAL_CXXFLAGS := \
	$(LOCAL_CFLAGS)
LOCAL_SRC := \
	$(wildcard $(LOCAL_DIR)/src/*.cpp)
LOCAL_EXPORTED_DIRS := \
	$(LOCAL_DIR)/exported

LOCAL_STATIC_LIBS := libtest_nested_static
include $(BUILD_SHARED_LIB)


