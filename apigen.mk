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

APIDOC_DIR=$(BUILD_DIR)/apidoc
APIGEN_CONFIG_FILE=$(BASE_DIR)/apigen.neon.dist

APIDOC_TARGET=$(APIGEN_OVERRIDE)apidoc
APIDOC_EXCLUDE=--exclude=test/ --exclude=tests/* --exclude=Test/* --exclude=Tests/* --exclude=*Test.php
APIDOC_FLAGS=$(APIDOC_EXCLUDE) --todo --charset utf8 --title "$(PROJECT_NAME) (build $(BUILD_VERSION))"
APIGEN_TARGET=$(APIGEN_OVERRIDE)$(APIDOC_DIR)

$(APIGEN_TARGET): $(APIDOC_TARGET)

$(APIDOC_TARGET): $(BUILD_TARGET)
	apigen --source $(SRC_DIR) --destination $(APIDOC_DIR) $(APIDOC_FLAGS)
