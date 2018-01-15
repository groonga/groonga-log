#!/usr/bin/env ruby
#
# Copyright (C) 2012-2018  Kouhei Sutou <kou@clear-code.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

$VERBOSE = true

require "pathname"

base_dir = Pathname.new(__FILE__).dirname.parent.expand_path
top_dir = base_dir.parent

lib_dir = base_dir + "lib"
test_dir = base_dir + "test"

require "test/unit"

Test::Unit::Priority.enable

$LOAD_PATH.unshift(lib_dir.to_s)

require_relative "helper"


exit(Test::Unit::AutoRunner.run(true, test_dir))
