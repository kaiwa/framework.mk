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

# The directory to check for if the vendor libraries are installed
ifndef vendor_dir
  vendor_dir=$(base_dir)/vendor
endif

ifneq ($(shell command -v composer.phar --version 2>/dev/null),)
  composer_installed=1
endif

# SET VENDOR DIR ENVIRONMENT VARIABLE FOR COMPOSER
COMPOSER_VENDOR_DIR:=$(vendor_dir)

ifndef vendor_target
  vendor_target = $(vendor_dir)
endif

ifndef vendor_target_deps
  vendor_target_deps = $(properties_target) $(custom_vendor_target_deps) | $(composer_target)
endif

ifndef composer_install_flags
  composer_install_flags = --ansi --prefer-dist
endif

ifdef no-interaction
  composer_install_flags += --no-interaction
endif

##
# Install third-party libraries using composer
##
$(vendor_target): $(vendor_target_deps)
	mkdir -p $(vendor_dir) -m $(umask_dir)
	chown $(console_user):$(console_user_group) $(vendor_dir)
	@composer.phar install $(composer_install_flags)

ifndef composer_target
  composer_target = composer.phar
endif

ifndef composer_target_deps
  composer_target_deps = $(custom_composer_target_deps)
endif

##
# Install composer dependency manager
##
$(composer_target): $(composer_target_deps)
#       Even if the file is not found, check if composer might be installed globally
        ifdef COMPOSER_INSTALLED
		$(call echoc,comment,Global composer installation detected.)
        else
		$(call echoc,info,Could not find composer. Downloading.)
		@curl -sS "https://getcomposer.org/installer" | php
		chown $(console_user):$(console_user_group) composer.phar
		chmod $(umask_exe) composer.phar
        endif

#
# Composer Purge target
#

ifndef composer_purge_target
  composer_purge_target = purge_composer
endif

ifndef composer_purge_target_deps
  composer_purge_target_deps = $(custom_composer_purge_target_deps)
endif

$(composer_purge_target): $(composer_purge_target_deps)
	rm -f composer.phar
	rm -rf $(vendor_dir)

# Add composer purge target to main purge target
custom_purge_target_deps+=$(composer_purge_target)
