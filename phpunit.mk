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

TEST_OUTFILE=$(BUILD_DIR)/phpunit.xml
TEST_CONFIGFILE=$(BASE_DIR)
# We output the coverage in the same go, otherwise
# it would be required to run all the tests again
TEST_FLAGS= \
  -c $(TEST_CONFIGFILE) \
  --log-junit=$(TEST_OUTFILE) \
  --coverage-clover=$(BUILD_DIR)/coverage.xml \
  --coverage-html=$(BUILD_DIR)/coverage.html \
  --colors
TEST_DEPS=$(TEST_OUTFILE)
TEST_CMD=$(BIN_DIR)/phpunit
TEST_DIR=$(SRC_DIR)

# Define a "test" target in order to be able to
# call "make test"
TEST_TARGET=$(OVERRIDE_TEST)test
$(TEST_TARGET): $(TEST_DEPS)

# Define a target for the test results
$(TEST_OUTFILE):
	$(TEST_CMD) $(TEST_FLAGS) $(TEST_DIR)

# Add a clean target for the test output
CLEAN_TEST_TARGET=$(OVERRIDE_CLEAN_TEST)clean_test
CUSTOM_CLEAN_DEPS+=$(CLEAN_TEST_TARGET)

$(CLEAN_TEST_TARGET): $(CUSTOM_CLEAN_TEST_DEPS)
	rm -f $(TEST_OUTFILE)
	rm -f $(BUILD_DIR)/coverage.xml
	rm -f $(BUILD_DIR)/coverage.html
