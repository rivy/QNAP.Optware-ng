###########################################################
#
# py-paramiko
#
###########################################################

#
# PY-PARAMIKO_VERSION, PY-PARAMIKO_SITE and PY-PARAMIKO_SOURCE define
# the upstream location of the source code for the package.
# PY-PARAMIKO_DIR is the directory which is created when the source
# archive is unpacked.
# PY-PARAMIKO_UNZIP is the command used to unzip the source.
# It is usually "zcat" (for .gz) or "bzcat" (for .bz2)
#
# You should change all these variables to suit your package.
# Please make sure that you add a description, and that you
# list all your packages' dependencies, seperated by commas.
#
# If you list yourself as MAINTAINER, please give a valid email
# address, and indicate your irc nick if it cannot be easily deduced
# from your name or email address.  If you leave MAINTAINER set to
# "NSLU2 Linux" other developers will feel free to edit.
#
PY-PARAMIKO_VERSION=1.7.6
PY-PARAMIKO_SITE=http://www.lag.net/paramiko/download
PY-PARAMIKO_SOURCE=paramiko-$(PY-PARAMIKO_VERSION).tar.gz
PY-PARAMIKO_DIR=paramiko-$(PY-PARAMIKO_VERSION)
PY-PARAMIKO_UNZIP=zcat
PY-PARAMIKO_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PY-PARAMIKO_DESCRIPTION=ssh2 protocol for python.
PY-PARAMIKO_SECTION=misc
PY-PARAMIKO_PRIORITY=optional
PY25-PARAMIKO_DEPENDS=python25
PY26-PARAMIKO_DEPENDS=python26
PY-PARAMIKO_CONFLICTS=

#
# PY-PARAMIKO_IPK_VERSION should be incremented when the ipk changes.
#
PY-PARAMIKO_IPK_VERSION=1

#
# PY-PARAMIKO_CONFFILES should be a list of user-editable files
#PY-PARAMIKO_CONFFILES=$(TARGET_PREFIX)/etc/py-paramiko.conf $(TARGET_PREFIX)/etc/init.d/SXXpy-paramiko

#
# PY-PARAMIKO_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
#PY-PARAMIKO_PATCHES=$(PY-PARAMIKO_SOURCE_DIR)/configure.patch

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
PY-PARAMIKO_CPPFLAGS=
PY-PARAMIKO_LDFLAGS=

#
# PY-PARAMIKO_BUILD_DIR is the directory in which the build is done.
# PY-PARAMIKO_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# PY-PARAMIKO_IPK_DIR is the directory in which the ipk is built.
# PY-PARAMIKO_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
PY-PARAMIKO_BUILD_DIR=$(BUILD_DIR)/py-paramiko
PY-PARAMIKO_SOURCE_DIR=$(SOURCE_DIR)/py-paramiko

PY25-PARAMIKO_IPK_DIR=$(BUILD_DIR)/py25-paramiko-$(PY-PARAMIKO_VERSION)-ipk
PY25-PARAMIKO_IPK=$(BUILD_DIR)/py25-paramiko_$(PY-PARAMIKO_VERSION)-$(PY-PARAMIKO_IPK_VERSION)_$(TARGET_ARCH).ipk

PY26-PARAMIKO_IPK_DIR=$(BUILD_DIR)/py26-paramiko-$(PY-PARAMIKO_VERSION)-ipk
PY26-PARAMIKO_IPK=$(BUILD_DIR)/py26-paramiko_$(PY-PARAMIKO_VERSION)-$(PY-PARAMIKO_IPK_VERSION)_$(TARGET_ARCH).ipk

.PHONY: py-paramiko-source py-paramiko-unpack py-paramiko py-paramiko-stage py-paramiko-ipk py-paramiko-clean py-paramiko-dirclean py-paramiko-check

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
#
$(DL_DIR)/$(PY-PARAMIKO_SOURCE):
	$(WGET) -P $(@D) $(PY-PARAMIKO_SITE)/$(@F) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
py-paramiko-source: $(DL_DIR)/$(PY-PARAMIKO_SOURCE) $(PY-PARAMIKO_PATCHES)

#
# This target unpacks the source code in the build directory.
# If the source archive is not .tar.gz or .tar.bz2, then you will need
# to change the commands here.  Patches to the source code are also
# applied in this target as required.
#
# This target also configures the build within the build directory.
# Flags such as LDFLAGS and CPPFLAGS should be passed into configure
# and NOT $(MAKE) below.  Passing it to configure causes configure to
# correctly BUILD the Makefile with the right paths, where passing it
# to Make causes it to override the default search paths of the compiler.
#
# If the compilation of the package requires other packages to be staged
# first, then do that first (e.g. "$(MAKE) <bar>-stage <baz>-stage").
#
$(PY-PARAMIKO_BUILD_DIR)/.configured: $(DL_DIR)/$(PY-PARAMIKO_SOURCE) $(PY-PARAMIKO_PATCHES)
	$(MAKE) py-setuptools-stage
	rm -rf $(BUILD_DIR)/$(PY-PARAMIKO_DIR) $(@D)
	mkdir -p $(@D)
	# 2.5
	$(PY-PARAMIKO_UNZIP) $(DL_DIR)/$(PY-PARAMIKO_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	if test -n "$(PY-PARAMIKO_PATCHES)"; then \
		cat $(PY-PARAMIKO_PATCHES) | $(PATCH) -d $(BUILD_DIR)/$(PY-PARAMIKO_DIR) -p1; \
	fi
	mv $(BUILD_DIR)/$(PY-PARAMIKO_DIR) $(@D)/2.5
	(cd $(@D)/2.5; \
	    ( \
		echo "[build_ext]"; \
	        echo "include-dirs=$(STAGING_INCLUDE_DIR):$(STAGING_INCLUDE_DIR)/python2.5"; \
	        echo "library-dirs=$(STAGING_LIB_DIR)"; \
	        echo "rpath=$(TARGET_PREFIX)/lib"; \
		echo "[build_scripts]"; \
		echo "executable=$(TARGET_PREFIX)/bin/python2.5"; \
		echo "[install]"; \
		echo "install_scripts=$(TARGET_PREFIX)/bin"; \
	    ) >> setup.cfg; \
	)
	# 2.6
	$(PY-PARAMIKO_UNZIP) $(DL_DIR)/$(PY-PARAMIKO_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	if test -n "$(PY-PARAMIKO_PATCHES)"; then \
		cat $(PY-PARAMIKO_PATCHES) | $(PATCH) -d $(BUILD_DIR)/$(PY-PARAMIKO_DIR) -p1; \
	fi
	mv $(BUILD_DIR)/$(PY-PARAMIKO_DIR) $(@D)/2.6
	(cd $(@D)/2.6; \
	    ( \
		echo "[build_ext]"; \
	        echo "include-dirs=$(STAGING_INCLUDE_DIR):$(STAGING_INCLUDE_DIR)/python2.6"; \
	        echo "library-dirs=$(STAGING_LIB_DIR)"; \
	        echo "rpath=$(TARGET_PREFIX)/lib"; \
		echo "[build_scripts]"; \
		echo "executable=$(TARGET_PREFIX)/bin/python2.6"; \
		echo "[install]"; \
		echo "install_scripts=$(TARGET_PREFIX)/bin"; \
	    ) >> setup.cfg; \
	)
	touch $@

py-paramiko-unpack: $(PY-PARAMIKO_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(PY-PARAMIKO_BUILD_DIR)/.built: $(PY-PARAMIKO_BUILD_DIR)/.configured
	rm -f $@
	(cd $(@D)/2.5; \
	$(TARGET_CONFIGURE_OPTS) LDSHARED='$(TARGET_CC) -shared' \
	    $(HOST_STAGING_PREFIX)/bin/python2.5 setup.py build; \
	)
	(cd $(@D)/2.6; \
	$(TARGET_CONFIGURE_OPTS) LDSHARED='$(TARGET_CC) -shared' \
	    $(HOST_STAGING_PREFIX)/bin/python2.6 setup.py build; \
	)
	touch $@

#
# This is the build convenience target.
#
py-paramiko: $(PY-PARAMIKO_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
#$(PY-PARAMIKO_BUILD_DIR)/.staged: $(PY-PARAMIKO_BUILD_DIR)/.built
#	rm -f $@
#	$(MAKE) -C $(PY-PARAMIKO_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
#	touch $@
#
#py-paramiko-stage: $(PY-PARAMIKO_BUILD_DIR)/.staged

#
# This rule creates a control file for ipkg.  It is no longer
# necessary to create a seperate control file under sources/py-paramiko
#
$(PY25-PARAMIKO_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: py25-paramiko" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PY-PARAMIKO_PRIORITY)" >>$@
	@echo "Section: $(PY-PARAMIKO_SECTION)" >>$@
	@echo "Version: $(PY-PARAMIKO_VERSION)-$(PY-PARAMIKO_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PY-PARAMIKO_MAINTAINER)" >>$@
	@echo "Source: $(PY-PARAMIKO_SITE)/$(PY-PARAMIKO_SOURCE)" >>$@
	@echo "Description: $(PY-PARAMIKO_DESCRIPTION)" >>$@
	@echo "Depends: $(PY25-PARAMIKO_DEPENDS)" >>$@
	@echo "Conflicts: $(PY-PARAMIKO_CONFLICTS)" >>$@

$(PY26-PARAMIKO_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: py26-paramiko" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PY-PARAMIKO_PRIORITY)" >>$@
	@echo "Section: $(PY-PARAMIKO_SECTION)" >>$@
	@echo "Version: $(PY-PARAMIKO_VERSION)-$(PY-PARAMIKO_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PY-PARAMIKO_MAINTAINER)" >>$@
	@echo "Source: $(PY-PARAMIKO_SITE)/$(PY-PARAMIKO_SOURCE)" >>$@
	@echo "Description: $(PY-PARAMIKO_DESCRIPTION)" >>$@
	@echo "Depends: $(PY26-PARAMIKO_DEPENDS)" >>$@
	@echo "Conflicts: $(PY-PARAMIKO_CONFLICTS)" >>$@

#
# This builds the IPK file.
#
# Binaries should be installed into $(PY-PARAMIKO_IPK_DIR)$(TARGET_PREFIX)/sbin or $(PY-PARAMIKO_IPK_DIR)$(TARGET_PREFIX)/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(PY-PARAMIKO_IPK_DIR)$(TARGET_PREFIX)/{lib,include}
# Configuration files should be installed in $(PY-PARAMIKO_IPK_DIR)$(TARGET_PREFIX)/etc/py-paramiko/...
# Documentation files should be installed in $(PY-PARAMIKO_IPK_DIR)$(TARGET_PREFIX)/doc/py-paramiko/...
# Daemon startup scripts should be installed in $(PY-PARAMIKO_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S??py-paramiko
#
# You may need to patch your application to make it use these locations.
#
$(PY25-PARAMIKO_IPK) $(PY26-PARAMIKO_IPK): $(PY-PARAMIKO_BUILD_DIR)/.built
	# 2.5
	rm -rf $(BUILD_DIR)/py-paramiko_*_$(TARGET_ARCH).ipk
	rm -rf $(PY25-PARAMIKO_IPK_DIR) $(BUILD_DIR)/py25-paramiko_*_$(TARGET_ARCH).ipk
	(cd $(PY-PARAMIKO_BUILD_DIR)/2.5; \
	    $(HOST_STAGING_PREFIX)/bin/python2.5 setup.py install --root=$(PY25-PARAMIKO_IPK_DIR) --prefix=$(TARGET_PREFIX); \
	)
	(cd $(PY25-PARAMIKO_IPK_DIR)$(TARGET_PREFIX)/lib/python2.5/site-packages; \
		find . -name '*.so' -exec chmod +w {} \; ; \
		find . -name '*.so' -exec $(STRIP_COMMAND) {} \; ; \
		find . -name '*.so' -exec chmod -w {} \; ; \
	)
	$(MAKE) $(PY25-PARAMIKO_IPK_DIR)/CONTROL/control
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PY25-PARAMIKO_IPK_DIR)
	# 2.6
	rm -rf $(PY26-PARAMIKO_IPK_DIR) $(BUILD_DIR)/py26-paramiko_*_$(TARGET_ARCH).ipk
	(cd $(PY-PARAMIKO_BUILD_DIR)/2.6; \
	    $(HOST_STAGING_PREFIX)/bin/python2.6 setup.py install --root=$(PY26-PARAMIKO_IPK_DIR) --prefix=$(TARGET_PREFIX); \
	)
	(cd $(PY26-PARAMIKO_IPK_DIR)$(TARGET_PREFIX)/lib/python2.6/site-packages; \
		find . -name '*.so' -exec chmod +w {} \; ; \
		find . -name '*.so' -exec $(STRIP_COMMAND) {} \; ; \
		find . -name '*.so' -exec chmod -w {} \; ; \
	)
	$(MAKE) $(PY26-PARAMIKO_IPK_DIR)/CONTROL/control
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PY26-PARAMIKO_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
py-paramiko-ipk: $(PY25-PARAMIKO_IPK) $(PY26-PARAMIKO_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
py-paramiko-clean:
	-$(MAKE) -C $(PY-PARAMIKO_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
py-paramiko-dirclean:
	rm -rf $(BUILD_DIR)/$(PY-PARAMIKO_DIR) $(PY-PARAMIKO_BUILD_DIR)
	rm -rf $(PY25-PARAMIKO_IPK_DIR) $(PY25-PARAMIKO_IPK)
	rm -rf $(PY26-PARAMIKO_IPK_DIR) $(PY26-PARAMIKO_IPK)

#
# Some sanity check for the package.
#
py-paramiko-check: $(PY25-PARAMIKO_IPK) $(PY26-PARAMIKO_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $^
