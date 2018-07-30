# Copyright (C) 2018  Kouhei Sutou <kou@clear-code.com>
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

class ParserTest < Test::Unit::TestCase
  include Helper::Fixture

  def parse(input)
    parser = GroongaLog::Parser.new
    parser.parse(input).collect(&:to_h)
  end

  def test_text
    input = GroongaLog::Input.new(fixture_path("groonga.log"))
    raw_entries = [
      {
        :timestamp => Time.local(2018, 1, 15, 15, 1, 23, 305389),
        :log_level => :notice,
        :pid => nil,
        :thread_id => nil,
        :message => "grn_init: <7.1.0-1-gef1bd38>",
      },
      {
        :timestamp => Time.local(2018, 1, 15, 15, 1, 23, 712541),
        :log_level => :notice,
        :pid => nil,
        :thread_id => nil,
        :message => "grn_fin (0)",
      },
    ]
    assert_equal(raw_entries, parse(input))
  end

  def test_gzip
    input = GroongaLog::Input.new(fixture_path("groonga.log.gz"))
    raw_entries = [
      {
        :timestamp => Time.local(2018, 1, 15, 15, 1, 23, 305389),
        :log_level => :notice,
        :pid => nil,
        :thread_id => nil,
        :message => "grn_init: <7.1.0-1-gef1bd38>",
      },
      {
        :timestamp => Time.local(2018, 1, 15, 15, 1, 23, 712541),
        :log_level => :notice,
        :pid => nil,
        :thread_id => nil,
        :message => "grn_fin (0)",
      },
    ]
    assert_equal(raw_entries, parse(input))
  end

  def test_zip
    input = GroongaLog::Input.new(fixture_path("groonga.log.zip"))
    raw_entries = [
      {
        :timestamp => Time.local(2018, 1, 15, 15, 1, 23, 305389),
        :log_level => :notice,
        :pid => nil,
        :thread_id => nil,
        :message => "grn_init: <7.1.0-1-gef1bd38>",
      },
      {
        :timestamp => Time.local(2018, 1, 15, 15, 1, 23, 712541),
        :log_level => :notice,
        :pid => nil,
        :thread_id => nil,
        :message => "grn_fin (0)",
      },
    ]
    assert_equal(raw_entries, parse(input))
  end
end
