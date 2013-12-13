##
# This program is free software; you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software Foundation;
# either version 2 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with this program;
# if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA
##

# CHECK FOR PHP
# Use your composer.json to require a specific version of PHP
ifeq "$(shell php -v 2>/dev/null)" ""
    $(error Please install PHP CLI)
endif

# CHECK FOR ACL
ifeq "$(shell setfacl -v 2>/dev/null)" ""
    SETFACL=$(call echoc,error,setfacl is not available. Try installing the acl package.)\#
else
    SETFACL=setfacl
endif

###################################################################
#                      S0Me ScRiPtIng
###################################################################

# Include modules
$(foreach module,$(MODULES), $(eval include $(SELF_DIR)/$(module).mk))

# TRY TO GET VERSION FROM GIT IF NOT DEFINED
ifndef BUILD_VERSION
    ifneq ("$(shell git --version 2>/dev/null)", "")
        GIT_OUTPUT=$(shell cd $(BASE_DIR) && git log --pretty="%H" -n1 HEAD 2>/dev/null)
        ifneq ($(GIT_OUTPUT),)
            BUILD_VERSION=$(GIT_OUTPUT)
        endif
    endif
endif

# PREPARE PROPERTIES FOR JSON DUMP
ifdef CUSTOM_PROPERTIES_JSON
PROP_PREFIX=,
endif

define PROPERTIES_JSON
{
  "properties": {
    "project_name":  "$(PROJECT_NAME)",
    "build_dir":     "$(BUILD_DIR)",
    "vendor_dir":    "$(VENDOR_DIR)",
    "build_version": "$(BUILD_VERSION)",
    "build_time":    "$(shell date -u +%s)"$(PROP_PREFIX)
    $(CUSTOM_PROPERTIES_JSON)
  }
}
endef

export PROPERTIES_JSON

####################################################################
#                        buILd taRGetS
####################################################################

DEFAULT_TARGET    = $(OVERRIDE_DEFAULT)default
BUILD_TARGET      = $(OVERRIDE_BUILD)$(BUILD_DIR)
PROPERTIES_TARGET = $(OVERRIDE_PROPERTIES)$(PROPERTIES_FILE)
CLEAN_TARGET      = $(OVERRIDE_CLEAN)clean
PURGE_TARGET      = $(OVERRIDE_PURGE)purge

##
# Default target
##
$(DEFAULT_TARGET): $(BUILD_TARGET) $(CUSTOM_DEFAULT_DEPS) $(PROPERTIES_TARGET) $(VENDOR_TARGET)
ifdef MODULES
	$(call echoc,comment,Used modules: $(MODULES))
endif
	$(call echoc,success,\\n$(PROJECT_NAME) is ready.\\n)

##
# Create build directory
##
$(BUILD_TARGET):
	mkdir -p $(BUILD_DIR)
	$(setfacl rwX,$(BUILD_DIR))

##
# Write the build properties to a file for later use in your PHP project
##
$(PROPERTIES_TARGET): $(BUILD_TARGET)
	@echo $$PROPERTIES_JSON > $(PROPERTIES_FILE)
	$(call echoc,comment,"Properties written to $(PROPERTIES_FILE)")

##
# Clean the built project configuration
##
$(CLEAN_TARGET): $(CUSTOM_CLEAN_DEPS)
	rm -rf $(BUILD_DIR)
	$(call echoc,success,\\nCleaned $(PROJECT_NAME). Run \"make purge\" if you want to clean the vendor libraries too.\\n)

##
# Purge all custom files
##
$(PURGE_TARGET): $(CLEAN_TARGET) $(CUSTOM_PURGE_DEPS)

##
# Auto-completion
##
.PHONY: build clean purge

# Phew... ':-|
