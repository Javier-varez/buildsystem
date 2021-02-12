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

gen_srcs_dir := $(local-generated-sources-dir)

GEN := $(gen_srcs_dir)/custom_source.h

$(GEN) : INTERNAL_NAME := $(LOCAL_NAME)
$(GEN) : INTERNAL_DIR := $(LOCAL_DIR)
$(GEN) : INTERNAL_FILE := $(LOCAL_DIR)/pre_processed.h
$(GEN) : INTERNAL_GEN  := $(GEN)
$(GEN) : INTERNAL_CUSTOM_TOOL := cp $(INTERNAL_FILE) $(INTERNAL_GEN)
$(GEN) : $(LOCAL_DIR)/pre_processed.h
	$(transform-generated-source)

LOCAL_GENERATED_SOURCES := $(GEN)
include $(BUILD_BINARY)

