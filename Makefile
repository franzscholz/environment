.PHONY: all
all:
	@echo "Use 'make Brewfile' to update the Brewfile."
	@exit 64

.PHONY: Brewfile
Brewfile:
	$(RM) Brewfile
	brew bundle dump --file=$(PWD)/Brewfile

.PHONY: cleanup
cleanup:
	
	brew bundle cleanup --file=$(PWD)/Brewfile --force

