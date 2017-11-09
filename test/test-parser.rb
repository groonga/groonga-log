# Copyright (C) 2017 Yasuhiro Horimoto <horimoto@clear-code.com>
# Copyright (C) 2017 Kentaro Hayashi <hayashi@clear-code.com>
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

require "helper"

class ParserTest < Test::Unit::TestCase
  def test_extract_field
    raw_statistic = {
      :timestamp => Time.local(2017, 7, 19, 14, 9, 5, 663978),
      :log_level => :notice,
      :context_id => "18c61700",
      :message => "spec:2:update:Object:32(type):8",
    }
    statistics = parse(<<-LOG)
2017-07-19 14:09:05.663978|n|18c61700|spec:2:update:Object:32(type):8
    LOG
    assert_equal([raw_statistic],
                 statistics.collect(&:to_h))
  end

  def test_log_level
    expected = [
      :emergency,
      :alert,
      :critical,
      :error,
      :warning,
      :notice,
      :information,
      :debug,
      :dump
    ]
    statistics = parse(<<-LOG)
2017-07-19 14:41:05.663978|E|18c61700|emergency
2017-07-19 14:41:06.663978|A|18c61700|alert
2017-07-19 14:41:06.663978|C|18c61700|critical
2017-07-19 14:41:06.663978|e|18c61700|error
2017-07-19 14:41:06.663978|w|18c61700|warning
2017-07-19 14:41:06.663978|n|18c61700|notice
2017-07-19 14:41:06.663978|i|18c61700|information
2017-07-19 14:41:06.663978|d|18c61700|debug
2017-07-19 14:41:06.663978|-|18c61700|dump
    LOG
    assert_equal(expected,
                 statistics.collect(&:log_level))
  end

  def test_extract_field_no_context_id
    raw_statistic = {
      :timestamp => Time.local(2017, 7, 19, 14, 9, 5, 663978),
      :log_level => :notice,
      :context_id => nil,
      :message => " spec:2:update:Object:32(type):8",
    }
    statistics = parse(<<-LOG)
2017-07-19 14:09:05.663978|n| spec:2:update:Object:32(type):8
    LOG
    assert_equal([raw_statistic],
                 statistics.collect(&:to_h))
  end

  def test_log_level_no_context_id
    expected = [
      :emergency,
      :alert,
      :critical,
      :error,
      :warning,
      :notice,
      :information,
      :debug,
      :dump
    ]
    statistics = parse(<<-LOG)
2017-07-19 14:41:05.663978|E| emergency
2017-07-19 14:41:06.663978|A| alert
2017-07-19 14:41:06.663978|C| critical
2017-07-19 14:41:06.663978|e| error
2017-07-19 14:41:06.663978|w| warning
2017-07-19 14:41:06.663978|n| notice
2017-07-19 14:41:06.663978|i| information
2017-07-19 14:41:06.663978|d| debug
2017-07-19 14:41:06.663978|-| dump
    LOG
    assert_equal(expected,
                 statistics.collect(&:log_level))
  end

  private
  def parse(log)
    parser = GroongaLog::Parser.new
    parser.parse(log).to_a
  end
end
