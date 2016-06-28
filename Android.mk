#
# Copyright 2015-2016 Preetam J. D'Souza
# Copyright 2016 The Maru OS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LXC_TOP := $(ANDROID_BUILD_TOP)/$(LOCAL_PATH)

# Android's toolchain lacks sane defaults, so we must ensure that we pass all
# the necessary flags to the native build process.
android_config_h := $(call select-android-config-h,linux-arm)
LXC_CFLAGS := $(subst -include $(android_config_h),,$(TARGET_GLOBAL_CFLAGS))
LXC_CFLAGS := $(subst -I $(dir $(android_config_h)),,$(LXC_CFLAGS))
LXC_C_INCLUDES := $(addprefix -I$(ANDROID_BUILD_TOP)/,$(TARGET_C_INCLUDES))
LXC_CRTBEGIN_DYNAMIC_O := $(addprefix $(ANDROID_BUILD_TOP)/,$(TARGET_CRTBEGIN_DYNAMIC_O))
LXC_CRTEND_O := $(addprefix $(ANDROID_BUILD_TOP)/,$(TARGET_CRTEND_O))

LXC_BUILD_DIR := $(ANDROID_PRODUCT_OUT)/obj/lxc
LXC_INSTALL_DIR := $(ANDROID_PRODUCT_OUT)

# only include lxc-* binaries in userdebug builds
ifeq ($(TARGET_BUILD_VARIANT),userdebug)
LXC_CONF_BINDIR := /system/bin
else
LXC_CONF_BINDIR := /obj/lxc/out/bin
endif

ifeq ($(TARGET_IS_64_BIT),true)
LXC_CONF_LIBDIR := /system/lib64
else
LXC_CONF_LIBDIR := /system/lib
endif

# Android's build system looks for this exact target, so we use it like a hook
# to trigger the native build process.
# All paths here will be evaluated relative to $(LXC_BUILD_DIR) so use full paths.
# Note: this must match the exact src file name in the associated prebuilt
# module.
$(LOCAL_PATH)/../../$(TARGET_OUT_SHARED_LIBRARIES)/liblxc.so: $(TARGET_OUT_INTERMEDIATE_LIBRARIES)/libc.so $(TARGET_OUT_INTERMEDIATE_LIBRARIES)/libdl.so $(TARGET_CRTBEGIN_DYNAMIC_O) $(TARGET_CRTEND_O) 
	cd $(LXC_TOP) && ./autogen.sh 
	mkdir -p $(LXC_BUILD_DIR) && cd $(LXC_BUILD_DIR) && \
	cp -r $(LXC_TOP)/config $(LXC_BUILD_DIR) && \
	$(LXC_TOP)/configure \
		--host=arm-linux-androideabi \
		--bindir="$(LXC_CONF_BINDIR)" \
		--libdir="$(LXC_CONF_LIBDIR)" \
		--disable-api-docs \
		--disable-capabilities \
		--disable-examples \
		--disable-lua \
		--disable-python \
		--disable-bash \
		--prefix=/system/maru/lxc \
		--with-runtime-path=/cache/ \
		--with-config-path=/data/maru/containers/ \
		CFLAGS="-nostdlib -Bdynamic -pie \
			$(LXC_CFLAGS) $(LXC_C_INCLUDES)" \
		LDFLAGS="$(TARGET_GLOBAL_LDFLAGS) \
			-Wl,-dynamic-linker,/system/bin/linker \
			$(LXC_CRTBEGIN_DYNAMIC_O) \
			-lc -ldl \
			-L${ANDROID_BUILD_TOP}/${TARGET_OUT_INTERMEDIATE_LIBRARIES} \
			$(LXC_CRTEND_O)" && \
		$(MAKE) && \
		$(MAKE) DESTDIR=$(LXC_INSTALL_DIR) install

# This prebuilt module is necessary for integrating the natively built library
# with the reset of the Android build system.
include $(CLEAR_VARS)
LOCAL_MODULE := liblxc
LOCAL_SRC_FILES := ../../$(TARGET_OUT_SHARED_LIBRARIES)/liblxc.so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .so
include $(BUILD_PREBUILT)
