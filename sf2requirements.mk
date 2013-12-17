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

ifndef requirements_log_file
  requirements_log_file=$(build_dir)/requirements.log
endif

ifndef requirements_check_file
  requirements_check_file=$(base_dir)/app/check.php
endif

ifndef requirements_target
  requirements_target=$(requirements_log_file)
endif

ifndef requirements_target_deps
  requirements_target_deps=$(vendor_target) $(custom_requirements_target_deps)
endif

custom_prepare_target_deps+=$(requirements_target)

$(requirements_target): $(requirements_target_deps)
	@if php $(requirements_check_file) > $(requirements_log_file); then \
            echo $(color_success)Symfony2 requirements check OK.$(color_transparent); \
        else \
            mv $(requirements_log_file) $(requirements_log_file).err; \
            echo $(color_error)Symfony2 requirements check failed!$(color_transparent)\\nPlease see $(requirements_log_file).err for details.\\n; \
            exit 1; \
        fi;
