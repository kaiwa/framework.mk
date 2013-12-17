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

ifndef phpunit_outfile
  phpunit_outfile = $(build_dir)/phpunit.xml
endif

ifndef phpunit_target
  phpunit_target = $(phpunit_outfile)
endif

ifndef phpunit_target_deps
  phpunit_target_deps=$(custom_phpunit_target_deps)
endif

ifndef phpunit_cmd
  phpunit_cmd = $(bin_dir)/phpunit
endif

ifndef phpunit_src_dir
  phpunit_src_dir = $(src_dir)
endif

ifndef phpunit_flags
  phpunit_flags = \
   --log-junit=$(phpunit_outfile) \
   --coverage-clover=$(build_dir)/coverage.xml \
   --coverage-html=$(build_dir)/coverage.html
endif

ifdef test_target
  # add phpunit to test deps
  test_target_deps+=phpunit
else
  # define test target as alias
  test: $(phpunit_target) $(custom_test_target_deps)
endif

# Define overridable phpunit clean target name
ifndef phpunit_clean_target
  phpunit_clean_target = clean_phpunit
endif

ifndef phpunit_clean_target_deps
  phpunit_clean_target_deps=$(phpunit_custom_clean_target_deps)
endif

# Add phpunit clean target to "make clean"
custom_clean_target_deps+=$(phpunit_clean_target)

# Define phpunit clean target
$(phpunit_clean_target): $(phpunit_clean_target_deps)
	rm -f $(phpunit_outfile)
	rm -f $(build_dir)/coverage.xml
	rm -f $(build_dir)/coverage.html

# Define phpunit target
$(phpunit_target): $(phpunit_target_deps)
	$(phpunit_cmd) $(phpunit_flags) $(phpunit_src_dir)
