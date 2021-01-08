LOCAL_DIR := $(call current-dir)

include $(CLEAR_VARS)
LOCAL_NAME := test_arm_clang

LOCAL_CFLAGS := \
	-I$(LOCAL_DIR)/inc \
	-mcpu=cortex-m0plus \
    -mfloat-abi=soft \
    -mthumb
LOCAL_CXXFLAGS := \
	$(LOCAL_CFLAGS)
LOCAL_SRC := \
	$(wildcard $(LOCAL_DIR)/src/*.c) \
	$(wildcard $(LOCAL_DIR)/src/*.cpp)
LOCAL_COMPILER := arm_clang

include $(BUILD_BINARY)

