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
  sub_test_case("extract fields") do
    def test_with_pid
      raw_statistic = {
        :timestamp => Time.local(2017, 7, 19, 14, 9, 5, 663978),
        :log_level => :notice,
        :pid => 29,
        :message => "spec:2:update:Object:32(type):8",
      }
      statistics = parse(<<-LOG)
2017-07-19 14:09:05.663978|n|29: spec:2:update:Object:32(type):8
      LOG
      assert_equal([raw_statistic],
                   statistics.collect(&:to_h))
    end

    def test_without_pid
      raw_statistic = {
        :timestamp => Time.local(2017, 7, 19, 14, 9, 5, 663978),
        :log_level => :notice,
        :pid => nil,
        :message => "spec:2:update:Object:32(type):8",
      }
      statistics = parse(<<-LOG)
2017-07-19 14:09:05.663978|n| spec:2:update:Object:32(type):8
      LOG
      assert_equal([raw_statistic],
                   statistics.collect(&:to_h))
    end
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
2017-07-19 14:41:05.663978|E|29: emergency
2017-07-19 14:41:06.663978|A| alert
2017-07-19 14:41:06.663978|C|29: critical
2017-07-19 14:41:06.663978|e| error
2017-07-19 14:41:06.663978|w|29: warning
2017-07-19 14:41:06.663978|n| notice
2017-07-19 14:41:06.663978|i|29: information
2017-07-19 14:41:06.663978|d| debug
2017-07-19 14:41:06.663978|-|29: dump
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
