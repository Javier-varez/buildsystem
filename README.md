# ATE Build System

ATE Build system is a non-recursive set of makefile definitions and templates that can be used to simplify the definition of targets. It is based on Make and allows to build the following types of targets:
  * Native binaries
  * Shared libraries
  * Static libraries

Its design was inspired by the AOSP build system, although it is much lighter and simple.

### Using the build system

A top level makefile system should include the `top.mk` file inside this repository. Targets can be defined in `build.mk` files. There are a few macros that can be used when writing target scripts. In particular, the following user-defined functions are very commonly used in custom build files:

  * `all-makefiles-under`: Takes a single directory input and finds all `build.mk` files inside it. Paired with an include directory is used to include subdirectories to the build system.
  * `current-dir`: Obtains the path of the current file. It needs to be called before including any other file, otherwise an erroneous result will be returned. 

#### Top-level makefile example

```Makefile
BUILD_SYSTEM_DIR := tools/build_system
include $(BUILD_SYSTEM_DIR)/top.mk

include $(call all-makefiles-under, .)
```

### Defining targets

In order to define targets local variables are used. To ensure that they are empty when defining a new target, we use the following include:

```Makefile
include $(CLEAR_VARS)
```

This will clear all local variables. Then we can define our local variables for the current target. Once we are done, we need to include one of the following three types of targets:

```Makefile
include $(BUILD_BINARY)
include $(BUILD_SHARED_LIBRARY)
include $(BUILD_STATIC_LIBRARY)
```

The following is an example of how to define a binary target and link it against a static library:

```Makefile
LOCAL_DIR := $(call current-dir)

include $(CLEAR_VARS)
LOCAL_NAME := test
LOCAL_CFLAGS := \
        -Os \
        -g3 \
        -I$(LOCAL_DIR)/Inc \
        -Wall \
        -Werror
LOCAL_LDFLAGS := -lc
LOCAL_SRC := \
        $(LOCAL_DIR)/Src/main.c
LOCAL_STATIC_LIBS := \
        libtest_static
include $(BUILD_BINARY)
```

By defining the `LOCAL_STATIC_LIBS`, all exported header paths are automatically included when building the binary. To define the static library we could use the following:

```Makefile
LOCAL_DIR := $(call current-dir)

include $(CLEAR_VARS)
LOCAL_NAME := test_static
LOCAL_CFLAGS := \
	-Os \
	-g3 \
	-I$(LOCAL_DIR)/Inc \
	-Wall \
	-Werror
LOCAL_ARFLAGS := -rcs
LOCAL_SRC := \
	$(LOCAL_DIR)/Src/testlib.c
LOCAL_EXPORTED_DIRS := \
	$(LOCAL_DIR)/Inc
include $(BUILD_STATIC_LIB)
```

`LOCAL_EXPORTED_DIRS` is used to define the exported headers for the library. These are the ones that will get included when building binaries that link against this library. More than one path can be specified. All exported directories are included in the targets that link against this library.

### Compiler profiles

ATE Build System supports custom compiler profiles. These are complex predefined compiler configurations that can be applied for each target. Currently it supports:

  * `arm_clang`: Uses `clang` with the `arm-none-eabi` triplet. In addition, it uses the sysroot from the `arm-none-eabi-gcc` toolchain, which is automatically detected from the `arm-none-eabi-gcc` binary present in your PATH environment variable. Links against `libc_nano` and `libstdc++_nano`. Uses the `-nostdlib` linker flag.

