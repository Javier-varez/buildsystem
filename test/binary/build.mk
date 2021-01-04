LOCAL_DIR := $(call current-dir)


include $(CLEAR_VARS)
LOCAL_NAME := test_binary
LOCAL_CFLAGS := \
	-I$(LOCAL_DIR)/inc

LOCAL_CXXFLAGS := \
	$(LOCAL_CFLAGS)

LOCAL_SRC := \
	$(wildcard $(LOCAL_DIR)/src/*.c) \
	$(wildcard $(LOCAL_DIR)/src/*.cpp)

LOCAL_SHARED_LIBS := libtest_nested_shared libtest_shared
LOCAL_STATIC_LIBS := libtest_static
include $(BUILD_BINARY)

