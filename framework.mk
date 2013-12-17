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
path_to_makefile := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

# CONSTRUCT ABSOLUTE PATH TO MAKEFILE
ifeq ($(path_to_makefile),.)
    # If we are in the same directory as the Makefile we use the absolute path from CURDIR
    self_dir := $(CURDIR)
# Compare first character, if it is a slash assume its an absolute path
else ifeq ($(shell echo $(path_to_makefile) | cut -c -1),/)
    # We have an absolute path
    # Strip trailing slash from path for consistency
    self_dir := $(patsubst %/,%,$(path_to_makefile))
else
    # If none of the above matches the path shold be relative
    # We construct it from the current dir and the relative path
    self_dir := $(CURDIR)/$(path_to_makefile)
endif

# Main makefile is located in basedir
# SELF_DIR points to current makefile
base_dir=$(shell readlink -f $(self_dir)/..)

#####################################################################
#                           VaRIabLEs
#####################################################################

# The build directory
# It will be in the same directory as the Makefile, regardless from where you call
build_dir:=$(base_dir)/build

# The directory where composer puts binary dependencies
# Not used in the main file atm but in modules
bin_dir:=$(base_dir)/bin

# The directories where your actual code is placed
# Not used in the main file atm but in modules
src_dir:=$(base_dir)/src

# Name is used for output messages and stored in the properties file
project_name:=$(notdir $(base_dir))

# The build properties will be written in JSON format to this file
# Use json_decode(file_get_contents('build/properties.json')) to
# read the properties into your application.
properties_file=$(build_dir)/properties.json

# Shortcut to call other targets
CALLTARGET:=@$(MAKE) -C $(base_dir) --no-print-directory

# Use $(call target,mytarget)
define target
  $(CALLTARGET) $1;
endef

# Name of the privileged console user, defaults to current user
console_user=$(shell whoami)
console_user_group=$(console_user)

# Webserver username and group
www_user=www-data
www_group=$(www_user)

# Default permissions for new files
umask_dir=0770
umask_exe=0770
umask_file=0660

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
  chmod $(umask_dir) $(2)
  chown $(console_user):$(console_group) $(2)
  $(setfacl_cmd) -bR $(2)
  $(setfacl_cmd) -R -m u:$(www_user):$(1) -m g:$(www_group):$(1) -m u:$(console_user):$(1) -m g:$(console_user_group):$(1) $(2);
  $(setfacl_cmd) -dR -m u:$(www_user):$(1) -m g:$(www_group):$(1) -m u:$(console_user):$(1) -m g:$(console_user_group):$(1) $(2);
endef

# First target must be defined here to set correct default entry point

ifndef init_target
init_target=init
endif

ifndef init_target_deps
init_target_deps = $(custom_init_target_deps) build
endif

$(init_target): $(init_target_deps)
