#
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

# converted to Android.mk from external/lxc/src/lxc/Makefile.am

# -----------------------------------------------------------------------------
#  liblxc

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := liblxc

LOCAL_SRC_FILES := \
	arguments.c \
	bdev.c \
	commands.c \
	start.c \
	execute.c \
	monitor.c \
	console.c \
	freezer.c \
	error.c \
	parse.c \
	cgfs.c \
	cgroup.c \
	initutils.c \
	utils.c \
	sync.c \
	namespace.c \
	conf.c \
	confile.c \
	state.c \
	log.c \
	attach.c \
	network.c \
	nl.c \
	rtnl.c \
	genl.c \
	caps.c \
	mainloop.c \
	af_unix.c \
	lxcutmp.c \
	lxclock.c \
	lxccontainer.c

# only on bionic
LOCAL_SRC_FILES += \
	../include/ifaddrs.c \
	../include/openpty.c \
	../include/lxcmntent.c

# for static config.h
LOCAL_C_INCLUDES += $(LOCAL_PATH)/..

LOCAL_CFLAGS += \
	-DLXCROOTFSMOUNT=\"/system/lib/lxc/rootfs\" \
	-DLXCPATH=\"/data/maru/containers\" \
	-DLXC_GLOBAL_CONF=\"/system/maru/lxc/etc/lxc/lxc.conf\" \
	-DLXCINITDIR=\"/system/maru/lxc/libexec\" \
	-DLIBEXECDIR=\"/system/maru/lxc/libexec\" \
	-DLXCTEMPLATEDIR=\"/system/maru/lxc/share/lxc/templates\" \
	-DLOGPATH=\"/data/maru/containers\" \
	-DLXC_DEFAULT_CONFIG=\"/system/maru/lxc/etc/lxc/default.conf\" \
	-DLXC_USERNIC_DB=\"/cache/lxc/nics\" \
	-DLXC_USERNIC_CONF=\"/system/maru/lxc/etc/lxc/lxc-usernet\" \
	-DDEFAULT_CGROUP_PATTERN=\"/lxc/%n\" \
	-DRUNTIME_PATH=\"/cache\" \
	-DSBINDIR=\"/system/maru/lxc/sbin\"

include $(BUILD_SHARED_LIBRARY)

# -----------------------------------------------------------------------------
#  LXC binaries

include $(CLEAR_VARS)
LOCAL_MODULE := lxc-start
LOCAL_SRC_FILES := lxc_start.c
LOCAL_C_INCLUDES += $(LOCAL_PATH)/..
LOCAL_SHARED_LIBRARIES := liblxc
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := lxc-stop
LOCAL_SRC_FILES := lxc_stop.c
LOCAL_C_INCLUDES += $(LOCAL_PATH)/..
LOCAL_SHARED_LIBRARIES := liblxc
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := lxc-console
LOCAL_SRC_FILES := lxc_console.c
LOCAL_C_INCLUDES += $(LOCAL_PATH)/..
LOCAL_SHARED_LIBRARIES := liblxc
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := lxc-attach
LOCAL_SRC_FILES := lxc_attach.c
LOCAL_C_INCLUDES += $(LOCAL_PATH)/..
LOCAL_SHARED_LIBRARIES := liblxc
include $(BUILD_EXECUTABLE)

# -----------------------------------------------------------------------------
#  LXC rootfs mount (required!)

include $(CLEAR_VARS)
LOCAL_MODULE := lxc-rootfs-mnt-README
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/lxc/rootfs
LOCAL_SRC_FILES := ../../doc/rootfs/README
include $(BUILD_PREBUILT)
