UM_4_4_FAMILY := msm8998 sdm660
UM_4_9_FAMILY := msm8917 msm8937 msm8952 msm8953 msm8996 sdm845
UM_4_14_FAMILY := $(MSMNILE) $(MSMSTEPPE) $(TRINKET) $(ATOLL)
UM_4_19_FAMILY := $(KONA) $(LITO) $(BENGAL)
UM_5_4_FAMILY := $(LAHAINA) $(HOLI)
UM_5_10_FAMILY := $(TARO) $(PARROT)
UM_5_15_FAMILY := $(KALAMA)
UM_6_1_FAMILY := $(PINEAPPLE)

UM_PLATFORMS := $(UM_4_4_FAMILY) $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY) $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY)
QSSI_SUPPORTED_PLATFORMS := $(UM_4_4_FAMILY) $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY) $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY)
UM_NO_GKI_PLATFORMS := $(UM_4_4_FAMILY) $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY) $(UM_5_4_FAMILY)

BOARD_USES_ADRENO := true

# Vibrator HAL
$(call soong_config_set, vibrator, vibratortargets, vibratoraidlV2target)

# Add qtidisplay to soong config namespaces
SOONG_CONFIG_NAMESPACES += qtidisplay

# Add supported variables to qtidisplay config
SOONG_CONFIG_qtidisplay += \
    drmpp \
    headless \
    llvmsa \
    gralloc4 \
    displayconfig_enabled \
    default \
    gralloc_handle_has_reserved_size \
    gralloc_handle_has_custom_content_md_reserved_size \
    var1 \
    var2 \
    var3 \
    llvmcov \
    composer_version \
    smmu_proxy \
    ubwcp_headers

# Set default values for qtidisplay config
SOONG_CONFIG_qtidisplay_drmpp ?= false
SOONG_CONFIG_qtidisplay_headless ?= false
SOONG_CONFIG_qtidisplay_llvmsa ?= false
SOONG_CONFIG_qtidisplay_gralloc4 ?= false
SOONG_CONFIG_qtidisplay_displayconfig_enabled ?= false
SOONG_CONFIG_qtidisplay_default ?= true
SOONG_CONFIG_qtidisplay_gralloc_handle_has_reserved_size ?= false
SOONG_CONFIG_qtidisplay_gralloc_handle_has_custom_content_md_reserved_size ?= false
SOONG_CONFIG_qtidisplay_var1 ?= false
SOONG_CONFIG_qtidisplay_var2 ?= false
SOONG_CONFIG_qtidisplay_var3 ?= false
SOONG_CONFIG_qtidisplay_llvmcov ?= false
SOONG_CONFIG_qtidisplay_smmu_proxy ?= false
SOONG_CONFIG_qtidisplay_ubwcp_headers ?= false
SOONG_CONFIG_qtidisplay_composer_version ?= v2

# UM platforms no longer need this set on O+
ifneq ($(call is-board-platform-in-list, $(UM_PLATFORMS)),true)
    TARGET_USES_QCOM_BSP := true
endif

# Tell HALs that we're compiling an AOSP build with an in-line kernel
TARGET_COMPILE_WITH_MSM_KERNEL := true

# Allow building audio encoders
TARGET_USES_QCOM_MM_AUDIO := true

# Enable color metadata for all UM targets
ifeq ($(call is-board-platform-in-list, $(UM_PLATFORMS)),true)
    TARGET_USES_COLOR_METADATA := true
endif

# Enable DRM PP driver on UM platforms that support it
ifeq ($(call is-board-platform-in-list, $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY) $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY)),true)
    SOONG_CONFIG_qtidisplay_drmpp := true
    TARGET_USES_DRM_PP := true
endif

# Enable displayconfig
ifeq ($(call is-board-platform-in-list, $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY)),true)
    SOONG_CONFIG_qtidisplay_displayconfig_enabled := true
endif

# Enable gralloc handle support on 5.10
ifeq ($(call is-board-platform-in-list, $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY)),true)
    SOONG_CONFIG_qtidisplay_gralloc_handle_has_reserved_size := true
endif

# Enable Gralloc4 on UM platforms that support it
ifneq ($(filter $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY),$(PRODUCT_BOARD_PLATFORM)),)
    SOONG_CONFIG_qtidisplay_gralloc4 := true
endif

ifneq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY),$(PRODUCT_BOARD_PLATFORM)),)
    TARGET_USES_QCOM_AUDIO_AR ?= true
endif

# Enable smmu proxy on UM platforms that support it
ifneq ($(filter $(UM_6_1_FAMILY),$(PRODUCT_BOARD_PLATFORM)),)
    SOONG_CONFIG_qtidisplay_smmu_proxy := true
endif
# Enable ubwcp_headers on UM platforms that support it
#ifneq ($(filter $(UM_6_1_FAMILY),$(PRODUCT_BOARD_PLATFORM)),)
#    SOONG_CONFIG_qtidisplay_ubwcp_headers := true
#endif
# Check if the target uses composer version 3 and is part of composer version on every UM platforms that support it
ifeq ($(TARGET_USES_COMPOSER3)$(filter $(UM_PLATFORMS),$(PRODUCT_BOARD_PLATFORM)),true)
    SOONG_CONFIG_qtidisplay_composer_version ?= v3
endif

# List of targets that use master side content protection
MASTER_SIDE_CP_TARGET_LIST := msm8996 $(UM_4_4_FAMILY) $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY) $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY)

# Every qcom platform is considered a vidc target
MSM_VIDC_TARGET_LIST := $(PRODUCT_BOARD_PLATFORM)

ifeq ($(call is-board-platform-in-list, $(UM_4_4_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := msm8998
else ifeq ($(call is-board-platform-in-list, $(UM_4_9_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := sdm845
else ifeq ($(call is-board-platform-in-list, $(UM_4_14_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := sm8150
else ifeq ($(call is-board-platform-in-list, $(UM_4_19_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := sm8250
else ifeq ($(call is-board-platform-in-list, $(UM_5_4_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := sm8350
else ifeq ($(call is-board-platform-in-list, $(UM_5_10_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := sm8450
else ifeq ($(call is-board-platform-in-list, $(UM_5_15_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := sm8550
else ifeq ($(call is-board-platform-in-list, $(UM_6_1_FAMILY)),true)
    QCOM_HARDWARE_VARIANT := sm8650
else
    QCOM_HARDWARE_VARIANT := $(PRODUCT_BOARD_PLATFORM)
endif

# Allow a device to manually override which HALs it wants to use
ifneq ($(OVERRIDE_QCOM_HARDWARE_VARIANT),)
QCOM_HARDWARE_VARIANT := $(OVERRIDE_QCOM_HARDWARE_VARIANT)
endif

ifeq ($(call is-board-platform-in-list, $(UM_4_4_FAMILY)),true)
    TARGET_KERNEL_VERSION := 4.4
else ifeq ($(call is-board-platform-in-list, $(UM_4_9_FAMILY)),true)
    TARGET_KERNEL_VERSION := 4.9
else ifeq ($(call is-board-platform-in-list, $(UM_4_14_FAMILY)),true)
    TARGET_KERNEL_VERSION := 4.14
else ifeq ($(call is-board-platform-in-list, $(UM_4_19_FAMILY)),true)
    TARGET_KERNEL_VERSION := 4.19
else ifeq ($(call is-board-platform-in-list, $(UM_5_4_FAMILY)),true)
    TARGET_KERNEL_VERSION := 5.4
else ifeq ($(call is-board-platform-in-list, $(UM_5_10_FAMILY)),true)
    TARGET_KERNEL_VERSION := 5.10
else ifeq ($(call is-board-platform-in-list, $(UM_5_15_FAMILY)),true)
    TARGET_KERNEL_VERSION := 5.15
else ifeq ($(call is-board-platform-in-list, $(UM_6_1_FAMILY)),true)
    TARGET_KERNEL_VERSION := 6.1
endif

ifneq ($(filter $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY) $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY),$(PRODUCT_BOARD_PLATFORM)),)
    TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS += | (1 << 27)
endif

# Required for frameworks/native
ifeq ($(call is-board-platform-in-list, $(UM_PLATFORMS)),true)
    TARGET_USES_QCOM_UM_FAMILY := true
endif

ifneq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY),$(PRODUCT_BOARD_PLATFORM)),)
    TARGET_GRALLOC_HANDLE_HAS_CUSTOM_CONTENT_MD_RESERVED_SIZE ?= true
    TARGET_GRALLOC_HANDLE_HAS_RESERVED_SIZE ?= true
endif

# Allow a device to opt-out hardset of PRODUCT_SOONG_NAMESPACES
QCOM_SOONG_NAMESPACE ?= hardware/qcom-caf/$(QCOM_HARDWARE_VARIANT)
PRODUCT_SOONG_NAMESPACES += $(QCOM_SOONG_NAMESPACE)

# Define kernel headers location
PRODUCT_VENDOR_KERNEL_HEADERS += hardware/qcom-caf/$(QCOM_HARDWARE_VARIANT)/kernel-headers

# Add display-commonsys-intf to PRODUCT_SOONG_NAMESPACES for QSSI supported platforms
ifeq ($(call is-board-platform-in-list, $(QSSI_SUPPORTED_PLATFORMS)),true)
PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/commonsys-intf/display
endif

# Add display-commonsys and display for non-GKI platforms
ifneq ($(filter $(UM_NO_GKI_PLATFORMS),$(PRODUCT_BOARD_PLATFORM)),)
PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/commonsys/display
endif

# Add data-ipa-cfg-mgr to PRODUCT_SOONG_NAMESPACES if needed
ifneq ($(USE_DEVICE_SPECIFIC_DATA_IPA_CFG_MGR),true)
ifneq ($(filter $(UM_NO_GKI_PLATFORMS),$(PRODUCT_BOARD_PLATFORM)),)
    PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/data-ipa-cfg-mgr-nogki
endif
ifneq ($(filter $(UM_6_1_FAMILY),$(PRODUCT_BOARD_PLATFORM)),)
    PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/sm8650/data-ipa-cfg-mgr
endif
endif

# Add dataservices to PRODUCT_SOONG_NAMESPACES if needed
ifneq ($(USE_DEVICE_SPECIFIC_DATASERVICES),true)
    PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/dataservices
endif

# Add nxp opensource to PRODUCT_SOONG_NAMESPACES if needed
ifeq ($(USE_NQ_NFC),true)
    PRODUCT_SOONG_NAMESPACES += vendor/nxp/opensource
endif

# Add wlan to PRODUCT_SOONG_NAMESPACES
PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/wlan

include vendor/statix/build/core/qcom_target.mk
