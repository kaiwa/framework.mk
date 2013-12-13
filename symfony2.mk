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

# DEFINE APPLICATION LOG AND CACHE DIRECTORY
#
# This can be overwritten on the command line by calling make with
#   make LOG_DIR=... CACHE_DIR=...
#
WEB_DIR=$(BASE_DIR)/web
LOG_DIR=$(BASE_DIR)/app/logs
CACHE_DIR=$(BASE_DIR)/app/cache

# STORE BOTH SETTINGS TO THE PROPERTIES JSON FILE FOR LATER USE
# IN THE PHP APPLICATION. READ THEM IN YOUR APP WITH
# json_decode(file_get_contents('build/properties.json'))
define CUSTOM_PROPERTIES_JSON
 "log_dir":   "$(LOG_DIR)",
 "cache_dir": "$(CACHE_DIR)"
endef

$(LOG_DIR):
	mkdir -p $(LOG_DIR)

$(CACHE_DIR):
	mkdir -p $(CACHE_DIR)

# DEFINE CUSTOM CLEAN TARGETS FOR BOTH DIRECTORIES
# So the directories will be removed when calling "make clean"
CLEAN_LOGS_TARGET=$(OVERRIDE_CLEAN_LOGS)clean_logs
CLEAN_CACHE_TARGET=$(OVERRIDE_CLEAN_CACHE)clean_cache
WEB_DIR_TARGET=$(OVERRIDE_WEB_DIR)$(WEB_DIR)

# DEFINE CUSTOM BUILD TARGETS FOR BOTH DIRECTORIES
# So the directories will be created when calling "make"
CUSTOM_DEFAULT_DEPS+=$(LOG_DIR) $(CACHE_DIR) $(WEB_DIR_TARGET)

# DEFINE CUSTOM BUILD TARGETS FOR BOTH DIRECTORIES
# So the directories will be created when calling "make"
CUSTOM_DEFAULT_DEPS+=$(LOG_DIR) $(CACHE_DIR) $(WEB_DIR_TARGET)
CUSTOM_CLEAN_DEPS+=$(CLEAN_LOGS_TARGET) $(CLEAN_CACHE_TARGET)

$(CLEAN_LOGS_TARGET):
	rm -rf $(LOG_DIR)

$(CLEAN_CACHE_TARGET):
	rm -rf $(CACHE_DIR)

$(WEB_DIR_TARGET):
	chown -R $(WWW_USER):$(WWW_GROUP) web
	chmod $(UMASK_DIR) web
	$(SETFACL) -R -m u:$(WWW_USER):rx -m g:$(WWW_GROUP):rx -m u:$(CONSOLE_USER):rw -m g:$(CONSOLE_USER_GROUP):rw $(BUILD_DIR)
	$(SETFACL) -dR -m u:$(WWW_USER):rx -m g:$(WWW_GROUP):rx -m u:$(CONSOLE_USER):rw -m g:$(CONSOLE_USER_GROUP):rw $(BUILD_DIR)
