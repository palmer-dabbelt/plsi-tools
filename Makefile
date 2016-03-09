# Tools required for PLSI to run

# To bump a tool to a newer version, change these variables
UNITS_VERSION=2.12
PYTHON3_VERSION=3.4.3

ALL += install/bin/units
ALL += install/bin/python3
ALL += enter.bash

.PHONY: all
all: $(ALL)

.PHONY: clean
clean:
	rm -rf install distfiles src enter.bash

enter.bash:
	rm -f $@
	echo 'export PATH="$(abspath install/bin):$$PATH"' >> $@

###############################################################################
# GNU Units
###############################################################################
install/bin/units: src/units/units
	mkdir -p $(dir $@)
	$(MAKE) -C $(dir $^) install

src/units/units: src/units/Makefile
	$(MAKE) -C $(dir $@) $(notdir $@)

src/units/Makefile: src/units/configure
	cd $(dir $@); ./configure --prefix=$(abspath install)

src/units/configure: distfiles/units-$(UNITS_VERSION).tar.gz
	rm -rf $(dir $@)
	mkdir -p $(dir $@)
	tar -C $(dir $@) -xpf $^ --strip-components=1
	touch $@

distfiles/units-$(UNITS_VERSION).tar.gz:
	mkdir -p $(dir $@)
	wget http://ftp.gnu.org/gnu/units/units-$(UNITS_VERSION).tar.gz -O $@

###############################################################################
# Python 3
###############################################################################
install/bin/python3: src/python3/build.stamp
	mkdir -p $(dir $@)
	$(MAKE) -C src/python3 install

src/python3/build.stamp: src/python3/Makefile
	$(MAKE) -C $(dir $@)
	touch $@

src/python3/Makefile: src/python3/configure
	cd $(dir $@); ./configure --prefix=$(abspath install)

src/python3/configure: distfiles/python3-$(PYTHON3_VERSION).tar.gz
	rm -rf $(dir $@)
	mkdir -p $(dir $@)
	tar -C $(dir $@) -xpf $^ --strip-components=1
	touch $@

distfiles/python3-$(PYTHON3_VERSION).tar.gz:
	mkdir -p $(dir $@)
	wget https://www.python.org/ftp/python/$(PYTHON3_VERSION)/Python-$(PYTHON3_VERSION).tgz -O $@
