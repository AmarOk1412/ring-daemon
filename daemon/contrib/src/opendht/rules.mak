# OPENDHT
OPENDHT_VERSION := 1789a5680e1e50bc593b9aa715a7f0a655d044fe
OPENDHT_URL := https://github.com/aberaud/opendht/archive/$(OPENDHT_VERSION).tar.gz

PKGS += opendht
ifeq ($(call need_pkg,'opendht'),)
PKGS_FOUND += opendht
endif

# Avoid building distro-provided dependencies in case opendht was built manually
ifneq ($(call need_pkg,"gnutls >= 3.0.20"),)
DEPS_opendht = gnutls $(DEPS_gnutls)
endif

$(TARBALLS)/opendht-$(OPENDHT_VERSION).tar.gz:
	$(call download,$(OPENDHT_URL))

.sum-opendht: opendht-$(OPENDHT_VERSION).tar.gz
	$(warning $@ not implemented)
	touch $@

opendht: opendht-$(OPENDHT_VERSION).tar.gz .sum-opendht
	$(UNPACK)
	$(UPDATE_AUTOCONFIG) && cd $(UNPACK_DIR)
	$(MOVE)

.opendht: opendht
	mkdir -p $</m4 && $(RECONF)
	cd $< && $(HOSTVARS) ./configure $(HOSTCONF)
	cd $< && $(MAKE) install
	touch $@