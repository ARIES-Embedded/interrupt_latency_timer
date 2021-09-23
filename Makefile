TARGET := ilt.vhd

RM  := rm -f
GIT := /usr/bin/git
SED := /bin/sed

GIT_ID  := $(shell $(GIT) rev-parse --short=8 HEAD)
SED_CMD := $(SED) -e 's/%GIT_ID%/$(GIT_ID)/'

.PHONY: all clean distclean

all: $(TARGET)

clean:
	$(RM) $(TARGET)

distclean: clean
	$(RM) *~

%.vhd: %.vhd.in
	$(SED_CMD) < $< > $@
