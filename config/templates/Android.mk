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
LOCAL_PATH := $(call my-dir)

# -----------------------------------------------------------------------------
#  LXC config dependencies

include $(CLEAR_VARS)
LOCAL_MODULE := debian.common.conf
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT)/maru/lxc/share/lxc/config
LOCAL_SRC_FILES := debian.common.conf.in
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := debian.userns.conf
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT)/maru/lxc/share/lxc/config
LOCAL_SRC_FILES := debian.userns.conf.in
include $(BUILD_PREBUILT)
