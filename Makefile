LIBDIR := lib

plantuml-dep ?= .plantuml.dep
DEPS_FILES += $(plantuml-dep)

include $(LIBDIR)/main.mk

$(plantuml-dep):
ifeq (true,$(CI))
	@apk add --no-cache plantuml
endif
	@touch $@


$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update --init
else
ifneq (,$(wildcard $(ID_TEMPLATE_HOME)))
	ln -s "$(ID_TEMPLATE_HOME)" $(LIBDIR)
else
	git clone -q --depth 10 -b main \
	    https://github.com/martinthomson/i-d-template $(LIBDIR)
endif
endif
