################################################################################
#
# make
#
################################################################################

MAKE_VERSION = 4.3
MAKE_SOURCE = make-$(MAKE_VERSION).tar.lz
MAKE_SITE = $(BR2_GNU_MIRROR)/make
MAKE_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES) host-pkgconf
MAKE_LICENSE = GPL-3.0+
MAKE_LICENSE_FILES = COPYING
MAKE_CPE_ID_VENDOR = gnu

MAKE_CONF_OPTS = --without-guile

# Disable the 'load' operation for static builds since it needs dlopen
ifeq ($(BR2_STATIC_LIBS),y)
MAKE_CONF_OPTS += --disable-load
endif

HOST_MAKE_DEPENDENCIES = host-pkgconf
HOST_MAKE_CONF_OPTS = --without-guile
HOST_MAKE_CONF_OPTS += make_cv_sys_gnu_glob=yes

# Configure host-make binary to be 'host-make' to ensure it isn't
# accidently used by packages when they invoke recursive / sub-make.
HOST_MAKE_CONF_OPTS += --program-prefix=host-

$(eval $(autotools-package))
$(eval $(host-autotools-package))