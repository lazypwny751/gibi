# Configuration.
PREFIX	:= /usr
BINDIR	:= $(PREFIX)/bin
WORKDIR	:= $(PREFIX)/share/bcpm

# Executables with arguments.
MD	:= mkdir -p
RM	:= rm -rf
CP	:= cp -r

define setup
	$(MD) $(BINDIR) $(WORKDIR)
	$(CP) lib $(WORKDIR)
	$(CP) src/bcpm.py $(WORKDIR)
	install -m 755 src/bcpm.sh $(BINDIR)/bcpm
endef

define remove
	$(RM) $(WORKDIR) $(BINDIR)/bcpm
endef

install:
	@echo "installing.."
	@$(setup)
	@echo "installed."

uninstall:
	@echo "uninstalling.."
	@$(remove)
	@echo "uninstalled."

reinstall:
	@echo "uninstalling.."
	@$(remove)
	@echo "uninstalled."
	@echo "installing.."
	@$(setup)
	@echo "installed."
	@echo "reinstalled."

.PHONY: install, uninstall, reinstall