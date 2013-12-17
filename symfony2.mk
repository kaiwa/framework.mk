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

ifndef sf_web_dir
  sf_web_dir=$(base_dir)/web
endif

ifndef sf_log_dir
  sf_log_dir=$(base_dir)/app/logs
endif

ifndef cache_dir
 sf_cache_dir=$(base_dir)/app/cache
endif

ifndef sf_parameters_file
  sf_parameters_file=$(build_dir)/parameters.yml
endif

custom_properties_json+=, "log_dir": "$(sf_log_dir)"
custom_properties_json+=, "cache_dir": "$(sf_cache_dir)"

ifndef sf_log_dir_target
  sf_log_dir_target=$(sf_log_dir)
endif

ifndef sf_cache_dir_target
  sf_cache_dir_target=$(sf_cache_dir)
endif

$(sf_log_dir_target):
	mkdir -p -m $(umask_dir) $(sf_log_dir)
	$(call setfacl,rwX,$(sf_log_dir))

$(sf_cache_dir_target):
	mkdir -p -m $(umask_dir) $(sf_cache_dir)
	$(call setfacl,rwX,$(sf_cache_dir))

ifndef sf_clean_logs_target
  sf_clean_logs_target=clean_logs
endif

ifndef sf_clean_cache_target
  sf_clean_cache_target=clean_cache
endif

ifndef sf_web_dir_target
  sf_web_dir_target=$(sf_web_dir)
endif

ifndef sf_parameters_target
  sf_parameters_target=$(build_dir)/parameters.yml
endif

ifndef sf_parameters_target_deps
  sf_parameters_target_deps=$(vendor_target)
endif

custom_default_target_deps+=$(sf_log_dir_target) $(sf_cache_dir_target) $(sf_web_dir_target) $(sf_parameters_target)
custom_clean_target_deps+=$(sf_clean_logs_target) $(sf_clean_cache_target)

$(sf_clean_logs_target): $(sf_clean_logs_target_deps)
	rm -rf $(sf_log_dir)

$(sf_clean_cache_target): $(sf_clean_cache_target_deps)
	rm -rf $(sf_cache_dir)

$(sf_web_dir_target): $(sf_web_dir_target_deps)
	$(call setfacl,rwX,$(sf_web_dir))

ifndef composer_run_script_flags
  composer_run_script_flags = --ansi
endif

ifdef no-interaction
  composer_run_script_flags += --no-interaction
endif

$(sf_parameters_target): $(sf_parameters_target_deps)
	@composer.phar run-script $(composer_run_script_flags) post-install-cmd
