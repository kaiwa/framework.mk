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
    setfacl_cmd=$(call echoc,error,setfacl is not available. Try installing the acl package.)\#
else
    setfacl_cmd=setfacl
endif

###################################################################
#                      S0Me ScRiPtIng
###################################################################

# TRY TO GET VERSION FROM GIT IF NOT DEFINED
ifndef build_version
    ifneq ("$(shell git --version 2>/dev/null)", "")
        __tmp=$(shell cd $(base_dir) && git log --pretty="%H" -n1 HEAD 2>/dev/null)
        ifneq ($(__tmp),)
            build_version=$(__tmp)
        endif
    endif
endif

####################################################################
#                        buILd taRGetS
####################################################################

ifndef default_target
  default_target = build
endif
ifndef prepare_target
  prepare_target = prepare
endif
ifndef properties_target
  properties_target = $(properties_file)
endif
ifndef clean_target
  clean_target = clean
endif
ifndef purge_target
  purge_target = purge
endif

ifndef default_target_deps
  default_target_deps = $(prepare_target) $(properties_target) $(custom_default_target_deps)
endif

##
# Default target
##
$(default_target): $(default_target_deps)
	$(call echoc,success,\\n$(project_name) is ready.\\n)

ifndef build_dir_target
  build_dir_target=$(build_dir)
endif

ifndef build_dir_target_deps
  build_dir_target_deps=$(custom_build_dir_target_deps)
endif

$(build_dir_target): $(build_dir_target_deps)
	mkdir -p $(build_dir)
	$(setfacl rwX,$(build_dir))

##
# Create build directory
##
ifndef prepare_target_deps
  prepare_target_deps = $(build_dir_target) $(custom_prepare_target_deps)
endif

$(prepare_target): $(prepare_target_deps)

##
# Write the build properties to a file for later use in your PHP project
##

ifndef properties_target_deps
  properties_target_deps = $(build_target) $(custom_properties_target_deps)
endif

define BUILD_PROPERTIES_JSON
{
  "properties": {
    "project_name":  "$(project_name)",
    "build_dir":     "$(build_dir)",
    "build_version": "$(build_version)",
    "build_time":    "$(shell date -u +%s)"
    $(custom_properties_json)
  }
}
endef

export BUILD_PROPERTIES_JSON

$(properties_target): $(properties_target_deps)
	@echo $$BUILD_PROPERTIES_JSON > $(properties_file)
	$(call echoc,comment,"Properties written to $(properties_file)")

##
# Clean the built project configuration
##

ifndef clean_target_deps
  clean_target_deps = $(custom_clean_target_deps)
endif

$(clean_target): $(clean_target_deps)
	rm -rf $(build_dir)
	$(call echoc,success,\\nCleaned $(project_name).\\n)

##
# Purge all custom files
##
ifndef purge_target_deps
  purge_target_deps = $(clean_target) $(custom_purge_target_deps)
endif

$(purge_target): $(purge_target_deps)

##
# Auto-completion
##
.PHONY: build prepare clean purge

# Phew... ':-|
