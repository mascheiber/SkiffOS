################################################################################
#
# skiff-core-gentoo
#
################################################################################

SKIFF_CORE_GENTOO_DEPENDENCIES = skiff-core skiff-core-defconfig

# Select the distro based on the architecture.

# amd64 (default)
SKIFF_CORE_GENTOO_COREENV_ARCH = amd64

# arm
ifeq ($(BR2_arm),y)
SKIFF_CORE_GENTOO_COREENV_ARCH = arm

# armv6 (default)
SKIFF_CORE_GENTOO_COREENV_MICROARCH = armv6j

# armv5
ifeq ($(BR2_ARM_CPU_ARMV5),y)
SKIFF_CORE_GENTOO_COREENV_MICROARCH = armv5tel
endif

# armv7a
ifeq ($(BR2_ARM_CPU_ARMV7A),y)
SKIFF_CORE_GENTOO_COREENV_MICROARCH = armv7a
endif

endif

# aarch64 / arm64
ifeq ($(BR2_aarch64),y)
SKIFF_CORE_GENTOO_COREENV_ARCH = arm64
SKIFF_CORE_GENTOO_COREENV_MICROARCH = arm64
endif

SKIFF_CORE_GENTOO_COREENV_DIST = \
	http://distfiles.gentoo.org/releases/$(SKIFF_CORE_GENTOO_COREENV_ARCH)/autobuilds

# default microarch to equal arch
ifeq ($(SKIFF_CORE_GENTOO_COREENV_MICROARCH),)
SKIFF_CORE_GENTOO_COREENV_MICROARCH = $(SKIFF_CORE_GENTOO_COREENV_ARCH)
endif

define SKIFF_CORE_GENTOO_INSTALL_COREENV
	mkdir -p $(TARGET_DIR)/opt/skiff/coreenv/skiff-core-gentoo
	cd $(TARGET_DIR)/opt/skiff/coreenv/skiff-core-gentoo ; \
		cp -r $(SKIFF_CORE_GENTOO_PKGDIR)/coreenv/* ./ ;\
		$(INSTALL) -m 0644 $(SKIFF_CORE_GENTOO_PKGDIR)/coreenv-defconfig.yaml \
			../defconfig.yaml ; \
		bash ./mkoverride.sh ARCH $(SKIFF_CORE_GENTOO_COREENV_ARCH); \
		bash ./mkoverride.sh MICROARCH $(SKIFF_CORE_GENTOO_COREENV_MICROARCH); \
		bash ./mkoverride.sh SUFFIX $(SKIFF_CORE_GENTOO_COREENV_SUFFIX); \
		bash ./mkoverride.sh DIST "$(SKIFF_CORE_GENTOO_COREENV_DIST)"; \
		touch ../.overridden
endef

SKIFF_CORE_GENTOO_POST_INSTALL_TARGET_HOOKS += SKIFF_CORE_GENTOO_INSTALL_COREENV

$(eval $(generic-package))
