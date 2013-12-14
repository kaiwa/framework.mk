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

ifneq ($(shell command -v composer.phar --version 2>/dev/null),)
  COMPOSER_INSTALLED=1
endif

# SET VENDOR DIR FOR COMPOSER
COMPOSER_VENDOR_DIR:=$(VENDOR_DIR)

VENDOR_TARGET     = $(OVERRIDE_VENDOR)$(VENDOR_DIR)
COMPOSER_TARGET   = $(OVERRIDE_COMPOSER)composer.phar
COMPOSER_FLAGS    = --no-interaction

##
# Install third-party libraries using composer
##
$(VENDOR_TARGET): $(PROPERTIES_TARGET) $(CUSTOM_VENDOR_TARGET_DEPS) | $(COMPOSER_TARGET)
	mkdir -p $(VENDOR_DIR) -m $(UMASK_DIR)
	chown $(CONSOLE_USER):$(CONSOLE_USER_GROUP) $(VENDOR_DIR)
	@composer.phar install $(COMPOSER_FLAGS) --prefer-dist

##
# Install composer dependency manager
##
$(COMPOSER_TARGET):
#       Even if the file is not found, check if composer might be installed globally
        ifdef COMPOSER_INSTALLED
		$(call echoc,comment,Global composer installation detected.)
        else
		$(call echoc,info,Could not find composer. Downloading.)
		@curl -sS "https://getcomposer.org/installer" | php
		chown $(CONSOLE_USER):$(CONSOLE_USER_GROUP) composer.phar
		chmod $(UMASK_EXE) composer.phar
        endif

#
# Add composer purge target to default purge targets
#
COMPOSER_PURGE_TARGET=$(OVERRIDE_COMPOSER_PURGE)purge_composer
CUSTOM_PURGE_DEPS+=$(COMPOSER_PURGE_TARGET)
$(COMPOSER_PURGE_TARGET):
	rm -f composer.phar
	rm -rf $(VENDOR_DIR)
