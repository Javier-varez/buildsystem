LOCAL_DIR := $(call current-dir)

include $(CLEAR_VARS)
LOCAL_NAME := gmock
LOCAL_CFLAGS := \
    -Os \
    -g3 \
    -I$(LOCAL_DIR)/googletest/googletest/include \
    -I$(LOCAL_DIR)/googletest/googletest/ \
    -I$(LOCAL_DIR)/googletest/googlemock/include \
    -I$(LOCAL_DIR)/googletest/googlemock/ \
    -Wall \
    -Werror \
    -Wextra
LOCAL_CXXFLAGS := \
    $(LOCAL_CFLAGS)
LOCAL_SRC := \
    $(LOCAL_DIR)/googletest/googletest/src/gtest-all.cc \
    $(LOCAL_DIR)/googletest/googlemock/src/gmock-all.cc
LOCAL_EXPORTED_DIRS := \
    $(LOCAL_DIR)/googletest/googletest/include \
    $(LOCAL_DIR)/googletest/googlemock/include
LOCAL_ARFLAGS := \
	-rcs
include $(BUILD_STATIC_LIB)

# Let's define also a 32-bit version target
LOCAL_NAME := gmock32
LOCAL_CFLAGS += -m32
LOCAL_CXXFLAGS += -m32

include $(BUILD_STATIC_LIB)

include $(CLEAR_VARS)
LOCAL_NAME := gmock_main
LOCAL_CFLAGS := \
    -Os \
    -g3 \
    -I$(LOCAL_DIR)/googletest/googletest/include \
    -I$(LOCAL_DIR)/googletest/googletest/ \
    -I$(LOCAL_DIR)/googletest/googlemock/include \
    -I$(LOCAL_DIR)/googletest/googlemock/ \
    -Wall \
    -Werror \
    -Wextra
LOCAL_CXXFLAGS := \
    $(LOCAL_CFLAGS)
LOCAL_SRC := \
    $(LOCAL_DIR)/googletest/googlemock/src/gmock_main.cc
LOCAL_ARFLAGS := \
	-rcs
include $(BUILD_STATIC_LIB)

# Let's define also a 32-bit version target
LOCAL_NAME := gmock_main32
LOCAL_CFLAGS += -m32
LOCAL_CXXFLAGS += -m32

include $(BUILD_STATIC_LIB)

