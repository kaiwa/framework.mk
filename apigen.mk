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

ifndef apigen_output_dir
  apigen_output_dir=$(build_dir)/apidoc
endif

ifndef apigen_source_dir
  apigen_source_dir=$(base_dir)/src
endif

ifndef apigen_config_file
  apigen_config_file=$(base_dir)/apigen.neon.dist
endif

ifndef apigen_target
  apigen_target=$(apigen_output_dir)
endif

ifndef apigen_exclude
  apigen_exclude=--exclude=test/ --exclude=tests/* --exclude=Test/* --exclude=Tests/* --exclude=*Test.php --exclude=specs/* --exclude=Specs/* --exclude=*Spec.php
endif

ifndef apigen_flags
  apigen_flags=$(apigen_exclude) --todo --charset utf8 --title "$(project_name) (build $(build_version))"
endif

ifndef apigen_binary
  apigen_bin=apigen
endif

$(apigen_target): $(apigen_target_deps)
	$(apigen_binary) --source $(apigen_source_dir) --destination $(apigen_output_dir) $(apigen_flags)
