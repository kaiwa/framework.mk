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

# Get relative path to Makefile and strip trailing slash
PATH_TO_MAKEFILE := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

# CONSTRUCT ABSOLUTE PATH TO MAKEFILE
ifeq ($(PATH_TO_MAKEFILE),.)
    # If we are in the same directory as the Makefile we use the absolute path from CURDIR
    SELF_DIR := $(CURDIR)
# Compare first character, if it is a slash assume its an absolute path
else ifeq ($(shell echo $(PATH_TO_MAKEFILE) | cut -c -1),/)
    # We have an absolute path
    # Strip trailing slash from path for consistency
    SELF_DIR := $(patsubst %/,%,$(PATH_TO_MAKEFILE))
else
    # If none of the above matches the path shold be relative
    # We construct it from the current dir and the relative path
    SELF_DIR := $(CURDIR)/$(PATH_TO_MAKEFILE)
endif

# Main makefile is located in basedir
# SELF_DIR points to current makefile
BASE_DIR=$(shell readlink -f $(SELF_DIR)/..)

#####################################################################
#                           VaRIabLEs
#####################################################################

# Flags to pass to composer when installing vendor libraries
COMPOSER_FLAGS=--ansi --no-interaction --prefer-dist

# The build directory
# It will be in the same directory as the Makefile, regardless from where you call
BUILD_DIR:=$(BASE_DIR)/build

# The directory to check for if the vendor libraries are installed
VENDOR_DIR:=$(BASE_DIR)/vendor

# The directory where composer puts binary dependencies
# Not used in the main file atm but in modules
BIN_DIR:=$(BASE_DIR)/bin

# The directories where your actual code is placed
# Not used in the main file atm but in modules
SRC_DIR:=$(BASE_DIR)/src

# Name is used for output messages and stored in the properties file
PROJECT_NAME:=$(notdir $(BASE_DIR))

# The build properties will be written in JSON format to this file
# Use json_decode(file_get_contents('build/properties.json')) to
# read the properties into your application.
PROPERTIES_FILE=$(BUILD_DIR)/properties.json

# Shortcut to call other targets
CALL:=@$(MAKE) -C $(BASE_DIR) --no-print-directory

# Use $(call target,mytarget)
define target
  $(CALL) $1;
endef

# Name of the privileged console user, defaults to current user
CONSOLE_USER=$(shell whoami)
CONSOLE_USER_GROUP=$(CONSOLE_USER)

# Webserver username and group
WWW_USER=www-data
WWW_GROUP=$(WWW_USER)

# Default permissions for new files
UMASK_DIR=0770
UMASK_EXE=0770
UMASK_FILE=0660

# -~+ adD SomE PlAyfUl cOlORs +~-
color_black="\033[0;30m"
color_red="\033[0;31m"
color_green="\033[0;32m"
color_yellow="\033[0;33m"
color_blue="\033[0;34m"
color_magenta="\033[0;35m"
color_cyan="\033[0;36m"
color_white="\033[0;37m"
color_transparent="\033[0m"

# color aliases
color_success  = $(color_green)
color_error    = $(color_red)
color_warning  = $(color_yellow)
color_info     = $(color_magenta)
color_comment  = $(color_blue)
color_headline = "\033[0;97;44m"

# echoc - echo colored
define echoc
  @echo $(3)$(color_$(1))$2$(color_transparent)$(4);
endef

define headline
  $(call echoc,headline, $(1) ,\\n,\\n)
endef

# Ease ACL pain

define setfacl
  chmod $(UMASK_DIR) $(2)
  $(SETFACL) -bR $(2)
  $(SETFACL) -R -m u:$(WWW_USER):$(1) -m g:$(WWW_GROUP):$(1) -m u:$(CONSOLE_USER):$(1) -m g:$(CONSOLE_USER_GROUP):$(1) $(2);
  $(SETFACL) -dR -m u:$(WWW_USER):$(1) -m g:$(WWW_GROUP):$(1) -m u:$(CONSOLE_USER):$(1) -m g:$(CONSOLE_USER_GROUP):$(1) $(2);
endef

# First target must be defined here to set correct default entry point
DEFAULT_TARGET=$(OVERRIDE_DEFAULT)default
$(OVERRIDE_INIT)init:$(DEFAULT_TARGET)
