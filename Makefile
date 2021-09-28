TARGET := ilt.vhd

VHDL_FILES := ilt_pkg.vhd
VHDL_FILES += ilt_apb.vhd ilt_register.vhd ilt_frt.vhd
VHDL_FILES += ilt_latch.vhd
VHDL_FILES += $(TARGET)

RM  := rm -f
GIT := /usr/bin/git
SED := /bin/sed
GHDL:= ghdl

GIT_ID  := $(shell $(GIT) rev-parse --short=8 HEAD)
SED_CMD := $(SED) -e 's/%GIT_ID%/$(GIT_ID)/'

.PHONY: all test clean distclean

all: $(TARGET)

test: $(TARGET)
	$(GHDL) -s $(VHDL_FILES)

clean:
	$(RM) $(TARGET)

distclean: clean
	$(RM) *~

%.vhd: %.vhd.in
	$(SED_CMD) < $< > $@
